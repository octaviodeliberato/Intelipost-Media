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
ind <- str_which(precos$X__1, "rigem: ")
origem <- str_replace(precos$X__1[ind], "Origem:  ", "")
ind <- str_which(precos$X__1, "UF")
keep <- names(precos)[!is.na(precos[ind, ])]
precos <- precos[, keep]
precos <- precos[complete.cases(precos), ]
names(precos) <- precos[1, ]
precos <- precos[2:nrow(precos), ]
precos$`Ad. Valorem%` %<>% as.numeric()
precos$`Ad. Valorem%` <- precos$`Ad. Valorem%` * 100
precos$`Ad. Valorem%` %<>% as.character()

mynames <- names(precos)[!grepl("kg", colnames(precos), ignore.case = T)]
mynames <- c(mynames, 
             names(precos)[grepl("exced", colnames(precos), ignore.case = T)])

df.m <- reshape2::melt(precos, id.vars = mynames)
df.m$Origem <- origem

range_end <- as.character(df.m$variable)
a <- str_extract_all(range_end, "[:digit:]+(?=k)", simplify = T)
df.m$variable <- ifelse(a[, 2] == "", a[, 1], a[, 2])
