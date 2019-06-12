library(readxl)
library(dplyr)
library(magrittr)
library(stringr)

filename <- "data-raw/cliente-on/47730_kit tabela onofre mma atualizado 22-10-18.xlsx"
guias <- excel_sheets(filename)
guia.certa <- guias[grepl("mma", guias, ignore.case = T)]
precos <- read_excel(filename, sheet = guia.certa)
nr.of.names <- length(names(precos))
for (i in 1:nr.of.names) {
  names(precos)[i] <- paste0("X__", as.character(i))
}
ind <- str_which(precos$X__1, "Generalidades") + 1

precos <- precos[ind:nrow(precos), c("X__1", "X__12")] %>% 
  .[complete.cases(.), ]
