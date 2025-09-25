{% docs __overview__ %}

# Projeto de Engenharia de Dados: Case iFood (NYC Taxi Data)

Bem-vindo(a) à documentação do nosso pipeline de dados. Este site contém todos os detalhes sobre nossos modelos, fontes, testes e a linhagem de dados completa, desde a ingestão até as tabelas analíticas.

## Visão Geral do Projeto

O objetivo deste projeto é demonstrar um pipeline de dados moderno e robusto, seguindo as melhores práticas de engenharia de dados. O processo consiste em:
1.  **Ingerir** dados brutos das corridas de táxis amarelos de Nova York de Janeiro a Maio de 2023.
2.  **Armazenar** os dados em um Data Lakehouse utilizando Delta Lake.
3.  **Transformar e Modelar** os dados usando dbt, aplicando testes de qualidade e enriquecendo as informações.
4.  **Disponibilizar** tabelas agregadas e prontas para o consumo na camada Gold, respondendo a perguntas de negócio chave.

## Arquitetura (Medallion + ELT)

Nossa arquitetura segue o padrão **ELT (Extract, Load, Transform)** e a abordagem **Medallion**, com uma clara separação de responsabilidades:

- **Bronze (`bronze_taxi_trips`):** Dados brutos ingeridos via PySpark, sem transformações complexas. É o nosso ponto de entrada.
- **Silver (`silver_cleaned_taxi_trips`):** Dados limpos, tipados, deduplicados e validados por "contratos de dados" (testes de qualidade). Esta é a nossa fonte única da verdade.
- **Gold (ex: `gold_monthly_metrics`, `gold_hourly_metrics`):** Tabelas agregadas e denormalizadas, focadas em casos de uso de negócio e prontas para análise.

## Como Navegar Nesta Documentação

Utilize a barra de navegação à esquerda para explorar os componentes do projeto:

- **Sources:** Para ver a descrição e os metadados da nossa fonte de dados brutos (`bronze_taxi_trips`).
- **Projects:** Selecione o projeto `ifood_case` para explorar cada uma das nossas tabelas (`silver` e `gold_`), suas colunas, descrições e testes.

---
*Este projeto foi desenvolvido como uma solução para o Case Técnico de Engenharia de Dados do iFood.*

{% enddocs %}