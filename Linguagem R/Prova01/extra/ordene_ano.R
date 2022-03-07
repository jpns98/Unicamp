#João Pedro do Nascimento Sandolin RA:176146

ordene_ano <- function(ano, dados = gapminder, dir="dados/"){

    dados <- dados[,-c(5,6)]
    dados <- dados[which(dados$year==ano),]
    dados <- dados[order(dados$lifeExp,decreasing = TRUE),]
    write_csv(dados, sprintf("%s/gapminder_%d.csv", dir,ano))
  
}
