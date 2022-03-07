# João Pedro do Nacimento Sandolin RA:176146
# P1

# carregando pacotes
library(tidyverse)
library(ggplot2)
library(readxl)
library(readr)

# caminho para os arquivos
path_populacao = "Dados/estimativa_dou_2021.xls"
path_votos = "Dados/eleicoes_turno2_SP.csv"
path_covid19sp = "Dados/covid19SP.tsv"

## Questão 1--------------------------------------------------------------------

populacao = read_excel(path_populacao, range = "A2:E5572", sheet = 2 )


## Questão 2--------------------------------------------------------------------

populacao = populacao %>% filter(UF == "SP") %>%
  rename(MUNICIPIO = `NOME DO MUNICÍPIO`, POPULACAO = `POPULAÇÃO ESTIMADA`) %>%
  select(MUNICIPIO,POPULACAO)

#       faltou transformar a coluna populacao para inteiro
#       mutate(POPULACAO = as.integer(POULACAO))

## Questão 3--------------------------------------------------------------------

maiusc_sem_acento = function(v){
  stringi::stri_trans_general(str_to_upper(v), id = "Latin-ASCII")
}

populacao = populacao %>% mutate(MUNICIPIO = maiusc_sem_acento(MUNICIPIO))


## Questão 4--------------------------------------------------------------------

my_cols = cols_only(NM_MUNICIPIO = "c", NM_CANDIDATO = 'c',
                    QT_VOTOS_NOMINAIS = 'i')

getStats = function(input, pos){
  input %>% 
    mutate(NM_CANDIDATO = ifelse(NM_CANDIDATO == "JAIR MESSIAS BOLSONARO",
                                         "BOLSONARO",NM_CANDIDATO),
                   NM_CANDIDATO = ifelse(NM_CANDIDATO == "FERNANDO HADDAD",
                                         "HADDAD",NM_CANDIDATO))
}
# Poderia ter usado drop_na() (nesse caso nao fazia diferança)
# poderia ter usado %>% mutate(NM_CANDIDATO = word(NM_CANDIDATO,-1))
# Pegaria apenas a ultima palavra da coluna

votos = read_csv_chunked(path_votos,
                 callback=DataFrameCallback$new(getStats),
                 chunk_size = 100,
                 col_types = my_cols)



computeStats = function(input){
  input %>%
    group_by(NM_MUNICIPIO, NM_CANDIDATO) %>%
    summarise(QT_VOTOS_NOMINAIS = sum(QT_VOTOS_NOMINAIS),
              .groups = 'drop') %>%
    pivot_wider(names_from = NM_CANDIDATO,
                values_from = QT_VOTOS_NOMINAIS ) 
}

 votos = votos %>% computeStats()


## Questão 5--------------------------------------------------------------------

covid19sp = read_tsv(path_covid19sp)

## Questão 6--------------------------------------------------------------------
covid19sp %>% anti_join(populacao %>%
              drop_na(POPULACAO), by = c("nome_munic" = "MUNICIPIO"))


## Questão 7--------------------------------------------------------------------

dados_covid_sp = populacao %>%
   left_join(votos, by = c("MUNICIPIO"="NM_MUNICIPIO")) %>%
   left_join(covid19sp, by = c("MUNICIPIO" = "nome_munic"))


## Questão 8--------------------------------------------------------------------

dados_covid_sp %>%
  mutate(POPULACAO = as.integer(POPULACAO)) %>%
  ggplot(aes(x = BOLSONARO/POPULACAO, y = CASOS/POPULACAO)) +
  geom_point()


