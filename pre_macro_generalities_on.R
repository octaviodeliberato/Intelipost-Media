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

de_para <- c("gris_value",
             "gris_min",
             "tollvalue",
             "delivery_fixed",
             "tas_fixed",
             "não usa",
             "não usa",
             "cubic_factor_capital",
             "cubic_factor_interior",
             "tde_value",
             "tde_min",
             "tde_max",
             "não usa",
             "não usa",
             "não usa",
             "não usa",
             "não usa",
             "não usa",
             "não usa",
             "não usa",
             "não usa")

precos$X__1 <- de_para
precos <- precos %>% filter(X__1 != "não usa")
# gris_value
gris_value <- precos[grepl("gris_value", precos$X__1), 2] %>% as.numeric()
gris_value <- as.character(gris_value * 100 )
gris_value %<>% sub(pattern = "\\.", replacement = ",")
precos[grepl("gris_value", precos$X__1), 2] <- gris_value
#tde_value
tde_value <- precos[grepl("tde_value", precos$X__1), 2] %>% as.numeric()
tde_value <- as.character(tde_value * 100 )
tde_value %<>% sub(pattern = "\\.", replacement = ",")
precos[grepl("tde_value", precos$X__1), 2] <- tde_value
# cubic_capital
cubic_fac <- precos[grepl("cubic_factor_capital", precos$X__1), 2]
cubic_fac %<>% str_extract(pattern = "[:digit:]+")
precos[grepl("cubic_factor_capital", precos$X__1), 2] <- cubic_fac
# cubic_interior
cubic_fac <- precos[grepl("cubic_factor_interior", precos$X__1), 2]
cubic_fac %<>% str_extract(pattern = "[:digit:]+")
precos[grepl("cubic_factor_interior", precos$X__1), 2] <- cubic_fac