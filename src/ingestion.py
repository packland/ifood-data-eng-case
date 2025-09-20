# src/ingestion.py

from pyspark.sql import SparkSession
from pyspark.sql.functions import lit

def main():
    """
    Função principal para ingerir dados de táxis de NY para a camada Bronze.
    
    Este script faz o download dos dados de Jan a Mai de 2023, os une
    e salva como uma tabela Delta na camada Bronze.
    """
    # 1. Inicializa a SparkSession com suporte para Delta Lake
    spark = (
        SparkSession.builder
        .appName("BronzeIngestionNYCTaxi")
        .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
        .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
        .getOrCreate()
    )

    print("Spark Session iniciada com sucesso.")

    # 2. Define as URLs dos arquivos Parquet de Jan a Mai de 2023
    base_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_{year}-{month:02d}.parquet"
    year = 2023
    months = range(1, 6)
    
    urls = [base_url.format(year=year, month=month) for month in months]
    
    print("Lendo os seguintes arquivos:")
    for url in urls:
        print(f" - {url}")

    # 3. Lê todos os arquivos Parquet em um único DataFrame
    # O Spark é otimizado para ler múltiplos arquivos de uma vez.
    df = spark.read.parquet(*urls)

    print(f"Total de {df.count()} registros lidos.")

    # 4. Salva o DataFrame como uma tabela Delta na camada Bronze
    # Usamos o modo "overwrite" para garantir que a ingestão seja idempotente.
    # Se o script for executado novamente, ele substituirá os dados existentes.
    table_name = "bronze_taxi_trips"
    
    print(f"Salvando dados na tabela Delta: {table_name}...")
    
    (
        df.write
        .format("delta")
        .mode("overwrite")
        .saveAsTable(table_name)
    )

    print(f"Tabela {table_name} salva com sucesso no formato Delta.")

    # 5. Finaliza a sessão Spark
    spark.stop()

if __name__ == "__main__":
    main()