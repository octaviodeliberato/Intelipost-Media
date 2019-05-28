library(readxl)
library(dplyr)
library(magrittr)
library(stringr)

filename <- "data-raw/cliente-duf/42519_Tabela MMA 27.04.xlsx"
precos <- read_excel(filename, col_names = FALSE)

ind <- str_which(precos$X__1, "Generalidades") + 1

precos <- precos[ind:nrow(precos), c("X__1", "X__11")] %>% .[complete.cases(.), ]
