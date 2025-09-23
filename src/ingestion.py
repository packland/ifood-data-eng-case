import requests
import pandas as pd
import io
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, LongType, StringType, DoubleType, TimestampType

# --- 1. Inicialização do Spark ---
spark = SparkSession.builder.appName("OfficialSchemaBronzeIngestion").getOrCreate()
print("✅ Spark Session iniciada.")

# --- 2. Definição do Schema Fixo (Baseado no Dicionário de Dados Oficial) ---
# Este é o nosso "Contrato de Dados" para a camada Bronze, garantindo consistência.
official_schema = StructType([
    StructField("VendorID", LongType(), True),
    StructField("tpep_pickup_datetime", TimestampType(), True),
    StructField("tpep_dropoff_datetime", TimestampType(), True),
    StructField("passenger_count", DoubleType(), True), # Usamos Double para segurança com nulos
    StructField("trip_distance", DoubleType(), True),
    StructField("RatecodeID", DoubleType(), True), # Usamos Double para segurança com nulos
    StructField("store_and_fwd_flag", StringType(), True),
    StructField("PULocationID", LongType(), True),
    StructField("DOLocationID", LongType(), True),
    StructField("payment_type", LongType(), True),
    StructField("fare_amount", DoubleType(), True),
    StructField("extra", DoubleType(), True),
    StructField("mta_tax", DoubleType(), True),
    StructField("tip_amount", DoubleType(), True),
    StructField("tolls_amount", DoubleType(), True),
    StructField("improvement_surcharge", DoubleType(), True),
    StructField("total_amount", DoubleType(), True),
    StructField("congestion_surcharge", DoubleType(), True),
    StructField("airport_fee", DoubleType(), True)
])
print("✅ Schema oficial definido com sucesso.")

# --- 3. Configuração ---
TAXI_TYPE = "yellow"
YEAR = 2023
MONTHS_LIST = list(range(1, 6))
BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/{type}_tripdata_{year}-{month:02d}.parquet"
TABLE_NAME = "bronze_taxi_trips"
print(f"⚙️ Configurado para ingerir dados de '{TAXI_TYPE}' com schema oficial.")

# --- 4. Loop de Ingestão e Escrita Incremental ---
for month in MONTHS_LIST:
    url = BASE_URL.format(type=TAXI_TYPE, year=YEAR, month=month)
    print(f"🔄 Processando {url}...")
    
    try:
        # a. Download e leitura para Pandas
        response = requests.get(url)
        response.raise_for_status()
        parquet_file = io.BytesIO(response.content)
        pandas_df = pd.read_parquet(parquet_file)
        
        # b. Criação do Spark DF, forçando o nosso schema oficial
        # O Spark irá converter os tipos do Pandas para os tipos definidos no nosso schema.
        spark_df = spark.createDataFrame(pandas_df, schema=official_schema)
        print(f"  - ✔️ Sucesso: {pandas_df.shape[0]} registros lidos e conformados ao schema oficial.")
        
        # c. Lógica de escrita incremental
        write_mode = "overwrite"
        if month > MONTHS_LIST[0]:
            write_mode = "append"
            
        print(f"  - 💾 Escrevendo dados do mês {month} com o modo: '{write_mode}'...")
        (
            spark_df.write
            .format("delta")
            # Agora que o schema é fixo, não precisamos mais da opção "mergeSchema"
            .mode(write_mode)
            .saveAsTable(TABLE_NAME)
        )
        print(f"  - 🎉 Dados do mês {month} salvos com sucesso!")
        
        # d. Limpeza da memória
        del pandas_df, spark_df, response
        
    except Exception as e:
        print(f"  - ❌ ERRO ao processar o mês {month}: {e}")
        raise e

print("\n✨ Etapa 2 (Ingestão Bronze) concluída com a abordagem final e mais robusta.")