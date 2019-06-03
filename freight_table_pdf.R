library(dplyr)
library(magrittr)
library(tabulizer)
library(stringr)
library(reshape2)

ExtractDFFromPDF <- function(location) {
  # Extract the table
  # locate_areas(location)
  
  out <- extract_tables(location, pages = 1,
                        output = "data.frame", area = list(c(210, 35,
                                                             354, 395)))
}

# a system constant from now on
location <- rio::import("pdf_location.xlsx") %>% as.character()
out <- ExtractDFFromPDF(location)
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
