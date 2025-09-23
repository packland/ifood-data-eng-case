# src/ingestion.py

from pyspark.sql import SparkSession

def main():
    """
    Função principal para orquestrar o processo de ingestão de dados
    da fonte para a camada Bronze em formato Delta, de forma otimizada.
    """
    # 1. INICIALIZAÇÃO DO SPARK
    spark = SparkSession.builder.appName("EfficientBronzeIngestion").getOrCreate()
    print("Spark Session iniciada.")

    # 2. CONFIGURAÇÕES
    TAXI_TYPE = "yellow"
    YEAR = 2023
    MONTHS = range(1, 6)
    TABLE_NAME = "bronze_taxi_trips"
    BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/{type}_tripdata_{year}-{month:02d}.parquet"

    print(f"Configurações definidas para: Tipo={TAXI_TYPE}, Ano={YEAR}, Meses={list(MONTHS)}")

    # 3. GERAR LISTA DE URLS
    urls = [
        BASE_URL.format(type=TAXI_TYPE, year=YEAR, month=month)
        for month in MONTHS
    ]

    print(f"Iniciando a leitura de {len(urls)} arquivos Parquet diretamente da fonte...")
    df = spark.read.parquet(*urls)

    print(f"Leitura concluída. Total de {df.count()} registros lidos.")

    print(f"Salvando os registros na tabela Delta '{TABLE_NAME}'...")
    (
        df.write
        .format("delta")
        .mode("overwrite")
        .saveAsTable(TABLE_NAME)
    )
    print(f"Tabela '{TABLE_NAME}' criada/atualizada com sucesso!")

    # 6. FINALIZAÇÃO
    spark.stop()
    print("\nProcesso de ingestão para a camada Bronze finalizado com sucesso.")

if __name__ == "__main__":
    main()