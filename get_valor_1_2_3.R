library(dplyr)
library(stringr)

tabela <- read.csv("~/TABELA_para_Regex.csv", stringsAsFactors=FALSE)

tabela.1 <- tabela[str_detect(tabela$TAXA, "pickup"), ]
tabela.2 <- tabela[!str_detect(tabela$TAXA, "pickup"), ]
string <- tabela.1$VALOR_TAXA_ORIGINAL

############
# tabela.1 #
############
# valor1
pattern1 <- "[:digit:]+(?=,)"
# str_view(string = string, pattern = pattern1)
pattern2 <- "(?<=,)[:digit:]+"
# str_view(string = string, pattern = pattern2)
valor1.1p <- str_extract(string = string, pattern = pattern1)
valor1.2p <- str_extract(string = string, pattern = pattern2)
valor1 <- paste0(valor1.1p, ",", valor1.2p)

# valor2
pattern1 <- "[:digit:]+(?= k)"
# str_view(string = string, pattern = pattern1)
valor2 <- str_extract(string = string, pattern = pattern1)

# valor 3
pattern1 <- "[:digit:]+(?= p)"
# str_view(string = string, pattern = pattern1)
valor3 <- str_extract(string = string, pattern = pattern1)
valor3 <- as.character(as.numeric(valor3) / 100)
valor3 <- sub("\\.", ",", valor3)

# output
tabela.1$valor1 <- valor1
tabela.1$valor2 <- valor2
tabela.1$valor3 <- valor3

############
# tabela.2 #
############
tabela.2$valor1 <- NA
tabela.2$valor2 <- NA
tabela.2$valor3 <- NA

aux <- tabela.2[grepl("insurance", tabela.2$TAXA), 2]
valor1 <- str_extract(string = aux, pattern = ".+(?=%)")
tabela.2[grepl("insurance", tabela.2$TAXA), "valor1"] <- valor1

aux <- tabela.2$VALOR_TAXA_ORIGINAL[3]
valor1 <- str_extract(aux, "[:digit:]...")
tabela.2$valor1[3] <- valor1

mult.kg <- ifelse(!str_detect(aux, "[:digit:]k"), "1,00", "0")
if (mult.kg != "1,00") {
  valor2 <- str_extract(aux, "[:digit:].(?=k)")
} else {
  valor2 <- mult.kg
  }
tabela.2$valor2[3] <- valor2

aux <- tabela.2$VALOR_TAXA_ORIGINAL[4]
valor1 <- str_extract(aux, "[:digit:]...")
tabela.2$valor1[4] <- valor1

output <- rbind(tabela.1, tabela.2)
