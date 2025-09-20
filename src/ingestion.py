# Importações necessárias
import urllib.request
from pyspark.sql import SparkSession

# 1. INICIALIZAÇÃO DO SPARK
# Obtém a sessão Spark com as configurações para Delta Lake.
spark = SparkSession.builder.appName("SimpleBronzeIngestion").getOrCreate()
print("Spark Session iniciada.")

# Acesso ao dbutils para manipulação de arquivos no DBFS
dbutils = spark.sparkContext._jvm.com.databricks.backend.common.util.DBUtils

# 2. CONFIGURAÇÕES
# Hardcoded para atender exatamente aos requisitos do case.
TAXI_TYPE = "yellow"
YEAR = 2023
MONTHS = range(1, 6) # Meses de 1 (Janeiro) a 5 (Maio)
STAGING_DIR = "/tmp/ifood_case_staging"
TABLE_NAME = "bronze_taxi_trips"

print(f"Configurações definidas para: Tipo={TAXI_TYPE}, Ano={YEAR}, Meses={list(MONTHS)}")

# 3. SETUP DA ÁREA DE STAGING (LANDING ZONE INTERNA)
# Garante que o diretório de staging exista e esteja limpo antes de começar.
dbutils.fs.rm(STAGING_DIR, recurse=True) # Limpa execuções anteriores
dbutils.fs.mkdirs(STAGING_DIR)
print(f"Diretório de staging '{STAGING_DIR}' preparado.")

# 4. DOWNLOAD DOS DADOS PARA O STAGING
BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/{type}_tripdata_{year}-{month:02d}.parquet"

for month in MONTHS:
    # Formata a URL e o caminho de destino no DBFS
    url = BASE_URL.format(type=TAXI_TYPE, year=YEAR, month=month)
    file_name = url.split("/")[-1]
    staging_path = f"{STAGING_DIR}/{file_name}"
    
    print(f"Baixando {url} para {staging_path}...")
    try:
        # Baixa o conteúdo do arquivo
        with urllib.request.urlopen(url) as response:
            content = response.read()
        # Salva o conteúdo no DBFS
        dbutils.fs.put(staging_path, content, overwrite=True)
        print(f"Arquivo '{file_name}' salvo com sucesso no staging.")
    except Exception as e:
        print(f"ERRO ao baixar o arquivo '{file_name}': {e}")
        # Opcional: parar a execução em caso de erro
        # raise e

# 5. INGESTÃO DOS DADOS DO STAGING PARA A TABELA DELTA (BRONZE)
print(f"\nLendo todos os arquivos parquet do diretório '{STAGING_DIR}'...")
df = spark.read.parquet(STAGING_DIR)

print(f"Salvando {df.count()} registros na tabela Delta '{TABLE_NAME}'...")
(
    df.write
    .format("delta")
    .mode("overwrite") # Sobrescreve a tabela se ela já existir
    .saveAsTable(TABLE_NAME)
)
print(f"Tabela '{TABLE_NAME}' criada com sucesso!")

# 6. LIMPEZA DA ÁREA DE STAGING
print(f"Limpando o diretório de staging '{STAGING_DIR}'...")
dbutils.fs.rm(STAGING_DIR, recurse=True)
print("Limpeza concluída.")

# 7. FINALIZAÇÃO
spark.stop()
print("\nProcesso de ingestão para a camada Bronze finalizado com sucesso.")