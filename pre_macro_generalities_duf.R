library(readxl)
library(dplyr)
library(magrittr)
library(stringr)

filename <- "data-raw/cliente-duf/42519_Tabela MMA 27.04.xlsx"
precos <- read_excel(filename, col_names = FALSE)

nr.of.names <- length(names(precos))
for (i in 1:nr.of.names) {
  names(precos)[i] <- paste0("X__", as.character(i))
}
ind <- str_which(precos$X__1, "Generalidades") + 1

precos <- precos[ind:nrow(precos), c("X__1", "X__11")] %>% 
  .[complete.cases(.), ]

precos <- precos[c(1:9, 14, 15), ]

de_para <- c("gris_value", "gris_min",
             "toll_value",
             "delivery_value",
             "tas_value",
             "other_fee_value", "other_fee_fraction", 
             "cubic_factor",
             "tda_fixed",
             "trt_value", "trt_min",
             "icms_tax_enable", "iss_tax_enable")

lastRow <- precos[1:2, ]
lastRow$X__1[1] <- "ICMS"; lastRow$X__11[1] <- "true"
lastRow$X__1[2] <- "ISS"; lastRow$X__11[2] <- "true"
precos <- rbind(precos, lastRow)
precos$X__1 <- de_para

ind <- which(precos$X__1 == "cubic_factor")
precos$X__11[ind] %<>% str_extract("[:digit:]+")
precos$X__11[1] <- as.numeric(precos$X__11[1]) * 100
ind <- which(precos$X__1 == "trt_value")
precos$X__11[ind] <- as.numeric(precos$X__11[ind]) * 100
