# João Pedro do Nascimento Sandolin
# RA:176146
# Data: 4 de Novembro de 2021
# Atividade de Avaliação 3 - ME315 (Manipulação de Banco de Dados)


library(tidyverse)
library(lubridate)
library(RSQLite)
# 1=============================================================================

processaDados <- function(path) {
  
  sql_name = file.path(path, "bigmac.sqlite3")
  conexao = dbConnect(SQLite(),sql_name)
  
  for (arquivo in list.files(path, pattern = ".csv$")){
    
    dados_pais = arquivo %>% str_remove(".csv") %>% str_split('_') %>%
      unlist() %>% tail(3)
    
    arq = file.path(path, arquivo)
    
    conteudo = read_csv(arq, show_col_types = FALSE)
    
    input = conteudo %>%
      rename_all(str_to_title) %>%
      select(Date, Local_price, Dollar_price, Dollar_ex, Usd_raw ) %>%
      transmute(data = format(Date, "%Y-%m-%d"),
                cod_pais = dados_pais[1],
                cod_moeda = dados_pais[3],
                nome_pais = dados_pais[2],
                preco_local = Local_price,
                preco_dolar = Local_price,
                cotacao = Dollar_ex,
                indice_dolar = Usd_raw)
    
    
    dbWriteTable(conexao, "ibm", input, append = TRUE)
  }
  return(conexao)
}

#Caminho para pasta com os dados:
path = "Dados"

con = processaDados(path)

con

dbGetQuery(con, "SELECT COUNT(DISTINCT nome_pais) AS npaises FROM ibm")

# 2=============================================================================


obsPais = function(conexao, paises){
  
  ## Alterando argumento paises para deixar
  ## no formato: "('pais1','pais2','pais3',...)"
  paises_str = toString(paste("'",paises,"'")) %>%
    str_replace_all("' ","'") %>%
    str_replace_all( " '","'")
  
  paises_str = paste("(",paises_str,")")
  
  sql = paste("SELECT nome_pais, COUNT(*) AS n FROM ibm ",
              "WHERE nome_pais IN ",
              paises_str,
              "GROUP BY nome_pais",
              "ORDER BY n DESC")
  
  return (dbGetQuery(conexao, sql))
}

#Exemplo teste
paises = c("Brazil", "Oman", "New Zealand","Poland","Venezuela")
obsPais(con, paises)


# 3=============================================================================

coletaDados <- function(conexao,paises) {
  paises_str = toString(paste("'",paises,"'")) %>%
    str_replace_all("' ","'") %>%
    str_replace_all( " '","'")
  
  paises_str = paste("(",paises_str,")")
    
  sql = paste("SELECT data, nome_pais, preco_dolar, indice_dolar FROM ibm ",
                "WHERE nome_pais IN ",
                paises_str)
  df = dbGetQuery(conexao, sql) %>% mutate(data = date(data))%>%
    arrange(nome_pais, data)
    
  
  return(df)
}


# 4=============================================================================

paises = c("Argentina","Brazil","United States")

df = coletaDados(con, paises)


df %>%
  ggplot(aes(x = data, y = indice_dolar, group = nome_pais))+
  geom_line(aes(color = nome_pais),lwd =1)+
  theme_bw()+
  labs(title = "Evolução do Índice Big Mac",
       subtitle = "Comparação: Argentina, Brasil, Estados Unidos",
       x = "Data",
       y = "Índice Big Mac (não ajustado) em USD",
      color = "Países")




