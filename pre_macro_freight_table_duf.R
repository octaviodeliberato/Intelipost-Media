library(readxl)
library(dplyr)
library(magrittr)
library(stringr)

filename <- "~/GitHub/Intelipost/Média Complexidade/Enviado pela Transportadora/Cliente Duf/42519_Tabela MMA 27.04.xlsx"
precos <- read_excel(filename, col_names = FALSE)

precos <- precos %>% select(X__1:X__5)
precos <- precos[complete.cases(precos), ]
colnames(precos) <- precos[1, ]
precos <- precos[-1, ]

capital.ind <- str_detect(precos$Destinos, "Capital")
interior.ind <- str_detect(precos$Destinos, "Interior")

precos$Destinos[capital.ind] <- "Capital"
precos$Destinos[interior.ind] <- "Interior"

precos$Percentual %<>% as.numeric()
precos$Percentual <- precos$Percentual * 100
precos$`Frete Minímo` %<>% as.numeric()
precos$`Frete Garantia` %<>% as.numeric()

names(precos) <- c("UF", "Destinos", "invoice_factor", "minimum_freight",
                   "weight_factor")
precos$`destination_geographic_identifier` <- paste0(precos$UF, "-",
                                                     precos$Destinos)
precos %<>% select(`destination_geographic_identifier`, everything(), 
                   -c(UF, Destinos))
