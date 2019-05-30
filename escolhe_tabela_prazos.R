library(readxl)
library(dplyr)
library(stringr)

origem <- "SERRA"

filename <- "C:/Users/BlueShift075/Documents/GitHub/Intelipost-Media/data-raw/cliente-duf/42519_PRAZO DE ATENDIMENTO MMA 2018 envio.xlsx"


guias <- excel_sheets(filename)
uf <- case_when(
  str_detect(origem, "SERRA") ~ "ES",
  str_detect(origem, "RIO") ~ "RJ",
  str_detect(origem, "GUA") ~ "SP",
  TRUE ~ "PR"
)

guia <- guias[str_detect(guias, uf)]

prazos <- read_excel(filename, sheet = guia, skip = 2)
