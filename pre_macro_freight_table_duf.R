library(readxl)
library(dplyr)
library(magrittr)
library(stringr)

filename <- "data-raw/cliente-duf/42519_Tabela MMA 27.04.xlsx"
precos <- read_excel(filename, col_names = FALSE)

precos <- precos %>% select(X__1:X__5)
precos <- precos[complete.cases(precos), ]
colnames(precos) <- precos[1, ]
precos <- precos[-1, ]

colnames(precos) <- c("UF", "Destinos", "invoice_factor", "minimum_freight",
                      "weight_factor")

precos$invoice_factor %<>% as.numeric()
precos$invoice_factor <- precos$invoice_factor * 100
precos$minimum_freight %<>% as.numeric()
precos$weight_factor %<>% as.numeric()

precos$destination_geographic_identifier <- paste0(precos$UF, "-",
                                                     precos$Destinos)

precos %<>% select(destination_geographic_identifier, everything(), 
                   -c(UF, Destinos))

hasDigit <- str_detect(precos$destination_geographic_identifier, "[:digit:]")

uf <- str_extract_all(precos$destination_geographic_identifier,
                      "[:alpha:]{2}(?=-)") %>% as.character()

stdDest <- str_extract(precos$destination_geographic_identifier,
                       "Capital|Interior")
newdf <- precos[1, ]
for (i in seq_along(precos$destination_geographic_identifier)) {
  if (hasDigit[i] == TRUE) {
    precos$destination_geographic_identifier[i] <- paste0(uf[i], "-", 
                                                          stdDest[i], " 1")
    
    newdf <- precos[i, ]
    newdf$destination_geographic_identifier <- paste0(uf[i], "-", 
                                                      stdDest[i], " 2")
    precos <- rbind(precos, newdf)
  }
}
