## João Pedro do Nascimento Sandolin RA:176146
## P2 ME315

library(RSQLite)
library(tidyverse)
library(lubridate)

sqlname ="meteorologia.sqlite3"

estacoes_arq = "estacoes_p2.csv"
microondas_arq = "microdados_p2.csv"
#Questão 1----------------------------------------------------------------------
conexao = dbConnect(SQLite(),sqlname)
estacoes = read_csv(estacoes_arq)

dbWriteTable(conexao, "estacoes", estacoes)

#Questão 2----------------------------------------------------------------------
lerDados = function(input,pos){
 input = input %>% mutate(data = ymd(data),
                          hora = hour(hora),
                          dia = day(data),
                          mes = month(data),
                          ano = year(data),
                          precipitacao = precipitacao_total,
                          temperatura = temperatura_max) %>%
   inner_join(estacoes) %>% 
   filter(estacao %in% c('Brasilia', 'Oeiras','Piracicaba',' Passo Fundo')) %>%
   select(id_estacao, dia, mes, ano, hora, precipitacao, temperatura)
   
  dbWriteTable(conexao, "dados_meteorologicos", input, append = TRUE)
}

mycols = cols_only(data = 'c', hora = '?', id_estacao = 'c',
                   precipitacao_total = 'd', temperatura_max = 'd')


read_csv_chunked(microondas_arq,
                col_types = mycols,
                chunk_size = 10000,
                callback = SideEffectChunkCallback$new(lerDados))



#Questão 3----------------------------------------------------------------------

sql3 = paste(
  "SELECT estacao, ano, COUNT(*) AS n",
  "FROM dados_meteorologicos",
  "INNER JOIN estacoes ON dados_meteorologicos.id_estacao = estacoes.id_estacao",
  "GROUP BY estacao, ano",
  "ORDER BY estacao"
  )
dbGetQuery(conexao, sql3)



#Questão 4----------------------------------------------------------------------

sql4 = paste(
  "SELECT dia, mes, ano, estacoes.estacao AS estacao,AVG(precipitacao) AS prec_media, AVG(temperatura) AS temp_media",
  "FROM dados_meteorologicos",
  "INNER JOIN estacoes ON dados_meteorologicos.id_estacao = estacoes.id_estacao",
  "GROUP BY dia, mes, ano, estacao"
)
dbGetQuery(conexao, sql4)
#Questão 5----------------------------------------------------------------------

sql5 = paste(
  "SELECT dia, mes, ano, estacoes.estacao AS estacao,AVG(temperatura) AS temp_diurna",
  "FROM dados_meteorologicos",
  "INNER JOIN estacoes ON dados_meteorologicos.id_estacao = estacoes.id_estacao",
  "GROUP BY dia, mes, ano, estacao",
  "HAVING hora > 8 AND hora < 18"
)
dados_temp = dbGetQuery(conexao, sql5)


#Questão 6----------------------------------------------------------------------
dados_temp %>%
  filter(temp_diurna > 32)%>%
  group_by(estacao, ano) %>%
  summarise(n = n(), .groups = "drop")

#Desconectando do Banco de dados:
dbDisconnect(conexao)
