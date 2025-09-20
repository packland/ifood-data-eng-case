# src/ingestion.py

import urllib.request
from pyspark.sql import SparkSession

def get_spark_session():
    """Obtém ou cria uma SparkSession com suporte a Delta Lake."""
    return (
        SparkSession.builder
        .appName("BronzeIngestionNYCTaxi")
        .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
        .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
        .getOrCreate()
    )

def download_file_to_dbfs(url, dbfs_path, spark):
    """Baixa um arquivo de uma URL para um caminho no DBFS."""
    # A API dbutils está disponível nativamente em notebooks Databricks
    dbutils = spark.sparkContext._jvm.com.databricks.backend.common.util.DBUtils
    
    print(f"Baixando {url} para {dbfs_path}...")
    try:
        # Usa urllib para ler o conteúdo do arquivo
        with urllib.request.urlopen(url) as response:
            content = response.read()
        
        # Usa dbutils para escrever os bytes no DBFS
        dbutils.fs.put(dbfs_path, content, True) # True para overwrite
        print("Download para DBFS concluído.")
        return True
    except Exception as e:
        print(f"Erro ao baixar {url}: {e}")
        return False

def main():
    """
    Função principal para ingerir dados de táxis de NY para a camada Bronze.
    Implementa o padrão: Baixar -> Armazenar (Staging) -> Ingerir -> Limpar.
    """
    spark = get_spark_session()

    # 1. Configurações
    base_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_{year}-{month:02d}.parquet"
    year = 2023
    months = range(1, 6)
    staging_dir = "/tmp/nyc_taxi_raw"
    table_name = "bronze_taxi_trips"

    # Garante que o diretório de staging exista e esteja limpo
    dbutils = spark.sparkContext._jvm.com.databricks.backend.common.util.DBUtils
    dbutils.fs.mkdirs(staging_dir)
    print(f"Diretório de staging '{staging_dir}' preparado.")

    # 2. Loop de Download para o Staging no DBFS
    for month in months:
        file_url = base_url.format(year=year, month=month)
        file_name = file_url.split("/")[-1]
        dbfs_staging_path = f"{staging_dir}/{file_name}"
        download_file_to_dbfs(file_url, dbfs_staging_path, spark)

    # 3. Ingestão para a Camada Bronze a partir do DBFS
    print(f"Lendo todos os arquivos Parquet de '{staging_dir}'...")
    df = spark.read.parquet(staging_dir)

    print(f"Total de {df.count()} registros lidos do staging.")
    
    print(f"Salvando dados na tabela Delta: {table_name}...")
    (
        df.write
        .format("delta")
        .mode("overwrite")
        .saveAsTable(table_name)
    )
    print(f"Tabela {table_name} salva com sucesso.")

    # 4. Limpeza do diretório de staging
    print(f"Limpando diretório de staging '{staging_dir}'...")
    dbutils.fs.rm(staging_dir, recurse=True)
    print("Limpeza concluída.")

    # 5. Finaliza a sessão Spark
    spark.stop()

if __name__ == "__main__":
    main()