library(readxl)
library(dplyr)
library(magrittr)
library(stringr)

filename <- "~/GitHub/Intelipost/Média Complexidade/Enviado pela Transportadora/Cliente Duf/42519_Tabela MMA 27.04.xlsx"
precos <- read_excel(filename, col_names = FALSE)

ind <- str_which(precos$X__1, "Generalidades") + 1

precos <- precos[ind:nrow(precos), c("X__1", "X__11")] %>% .[complete.cases(.), ]
