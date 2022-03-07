library(tidyverse)
library(ggplot2)
library(readxl)
library(readr)
## Questão 1
path_populacao = "Dados/estimativa_dou_2021.xls"
populacao = read_excel(path_populacao, range = "A2:E5572", sheet = 2 )

## Questão 2

populacao = populacao %>% filter(UF == "SP") %>%
  rename(MUNICIPIO = `NOME DO MUNICÍPIO`, POPULACAO = `POPULAÇÃO ESTIMADA`) %>%
  select(MUNICIPIO,POPULACAO) %>%
  mutate(POPULACAO = as.integer(POPULACAO))

## Questão 3

maiusc_sem_acento = function(v){
  stringi::stri_trans_general(str_to_upper(v), id = "Latin-ASCII")
}

populacao = populacao %>% mutate(MUNICIPIO = maiusc_sem_acento(MUNICIPIO))

## Questão 4

my_cols = cols_only(NM_MUNICIPIO = "c", NM_CANDIDATO = 'c',QT_VOTOS_NOMINAIS = 'i')

getStats = function(input, pos){
  input %>% mutate(NM_CANDIDATO = ifelse(NM_CANDIDATO == "JAIR MESSIAS BOLSONARO",
                                         "BOLSONARO",NM_CANDIDATO),
                   NM_CANDIDATO = ifelse(NM_CANDIDATO == "FERNANDO HADDAD",
                                         "HADDAD",NM_CANDIDATO))
}


votos = read_csv_chunked('Dados/eleicoes_turno2_SP.csv',
                 callback=DataFrameCallback$new(getStats),
                 chunk_size = 100,
                 col_types = my_cols)



computeStats = function(input){
  input%>%
    group_by(NM_MUNICIPIO, NM_CANDIDATO) %>%
    summarise(QT_VOTOS_NOMINAIS = sum(QT_VOTOS_NOMINAIS),
              .groups = 'drop') 
}

votos = votos %>% computeStats()

## Questão 5

covid19sp = read_tsv("Dados/covid19SP.tsv")

## Questão 6
covid19sp %>% anti_join(populacao %>% drop_na(POPULACAO), by = c("nome_munic" = "MUNICIPIO"))

## Questão 7

dados_covid_sp = populacao %>% left_join(votos, by = c("MUNICIPIO"="NM_MUNICIPIO")) %>%
  left_join(covid19sp, by = c("MUNICIPIO" = "nome_munic"))

## Questão 8

dados_covid_sp %>% filter(NM_CANDIDATO == "BOLSONARO") %>%
  ggplot(aes(x = QT_VOTOS_NOMINAIS/POPULACAO, y = CASOS/POPULACAO)) +
  geom_point()


