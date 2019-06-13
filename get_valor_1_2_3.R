library(dplyr)
library(stringr)

tabela <- read.csv("~/TABELA_para_Regex.csv", stringsAsFactors=FALSE)

tem.pickup <- any(str_detect(tabela$TAXA, "pickup_") == TRUE)
tem.insurance <- any(str_detect(tabela$TAXA, "insurance_") == TRUE)
tem.other <- any(str_detect(tabela$TAXA, "other_") == TRUE)
tem.cte <- any(str_detect(tabela$TAXA, "cte_") == TRUE)

tabela.1 <- tabela[str_detect(tabela$TAXA, "pickup"), ]
tabela.2 <- tabela[str_detect(tabela$TAXA, "insurance"), ]
tabela.3 <- tabela[str_detect(tabela$TAXA, "other"), ]
tabela.4 <- tabela[str_detect(tabela$TAXA, "cte"), ]


if (tem.pickup) {
  tabela.1$valor1 <- NA
  tabela.1$valor2 <- NA
  tabela.1$valor3 <- NA
  string <- tabela.1$VALOR_TAXA_ORIGINAL
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
}

if (tem.insurance) {
  tabela.2$valor1 <- NA
  tabela.2$valor2 <- NA
  tabela.2$valor3 <- NA
  string <- tabela.2$VALOR_TAXA_ORIGINAL
  # valor1
  valor1 <- str_extract(string = string, pattern = ".+(?=%)")
  tabela.2$valor1 <- valor1
}

if (tem.other) {
  tabela.3$valor1 <- NA
  tabela.3$valor2 <- NA
  tabela.3$valor3 <- NA
  string <- tabela.3$VALOR_TAXA_ORIGINAL
  # valor1
  valor1 <- str_extract(string, "[:digit:]...")
  tabela.3$valor1 <- valor1
  # valor2
  mult.kg <- ifelse(!str_detect(string, "[:digit:]k"), "1,00", "0")
  if (mult.kg[1] != "1,00") {
    valor2 <- str_extract(string, "[:digit:].(?=k)")
  } else {
    valor2 <- mult.kg
  }
  tabela.3$valor2 <- valor2
}

if (tem.cte) {
  tabela.4$valor1 <- NA
  tabela.4$valor2 <- NA
  tabela.4$valor3 <- NA
  string <- tabela.4$VALOR_TAXA_ORIGINAL
  # valor1
  valor1 <- str_extract(string, "[:digit:]...")
  tabela.4$valor1 <- valor1
}

output <- bind_rows(tabela.1, tabela.2, tabela.3, tabela.4)
output <- output %>% mutate_if(is.logical, as.character)
