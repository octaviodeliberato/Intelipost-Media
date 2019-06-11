library(dplyr)
library(magrittr)
library(tabulizer)
library(stringr)
library(reshape2)

# Location of pdf file
location <- 'C:/Users/BlueShift075/Documents/GitHub/Intelipost-Media/data-raw/cliente-eb/55004_PROPOSTA - EB - 28.02.19.pdf'

# Extract the table
# locate_areas(location)
out <- extract_tables(location, pages = 1, 
                      output = "data.frame", area = list(c(210, 35,
                                                           354, 395)))
df <- out[[1]]

df <- df %>% filter(str_length(Destino) >= 2)
names(df) <- make.names(names(df))

aux <- select_at(df, vars(contains("kg")))
aux2 <- lapply(aux, str_extract, pattern = "...[:digit:],.+")
aux2 <- lapply(aux2, str_replace_all, pattern = " ", replacement = "")
aux2 <- as.data.frame(aux2)

aux <- df[, !grepl("kg", colnames(df), ignore.case = T)]
df <- cbind(aux, aux2)
df[, grepl("Ad.", colnames(df), ignore.case = T)] %<>% str_replace("%", "")

mynames <- names(df)[!grepl("kg", colnames(df), ignore.case = F)]
df.m <- melt(df, id.vars = mynames)

rio::export(df.m, "freight_table_pdf.xlsx")
