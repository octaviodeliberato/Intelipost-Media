library(readxl)
library(dplyr)
library(stringr)

origem <- "SERRA"

filename <- "C:/Users/BlueShift075/Documents/GitHub/Intelipost-Media/data-raw/cliente-duf/42519_PRAZO DE ATENDIMENTO MMA 2018 envio.xlsx"


guias <- excel_sheets(filename)

for (i in 1:length(guias)) {
  prazos <- read_excel(filename, sheet = guias[1], skip = 2)
  cidade.origem <- as.character(prazos[1, 1])
  if (str_detect(cidade.origem, origem)) {
    break
  }
}
