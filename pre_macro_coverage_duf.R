library(readxl)
library(excel.link)
library(dplyr)
library(magrittr)
library(stringr)

filename <- "C:/Users/BlueShift075/Documents/GitHub/Intelipost-Media/GeraCEP_v2019.1.0.xlsx"

geraCEP <- read_excel(filename, col_names = TRUE)
geraCEP %<>% select(`UF-CIDADE`, `CEP INI 1`, `CEP FIM 1`)
geraCEP %<>% .[complete.cases(.), ]

ind.dupl <- duplicated(geraCEP$`UF-CIDADE`)
geraCEP <- geraCEP[!ind.dupl, ]

geraCEP %<>% .[order(geraCEP$`UF-CIDADE`), ]

filename <- "C:/Users/BlueShift075/Documents/GitHub/Intelipost-Media/data-raw/cliente-duf/42519_TRT por CEP-IF.xlsx"

trt <- read_excel(filename, col_names = TRUE, skip = 1)
trt <- trt[, 1:4]
trt %<>% .[complete.cases(.), ]
trt$`UF-CIDADE` <- paste0(trt$UF, "-", trt$CIDADE)
trt %<>% select(`UF-CIDADE`, CEP, ENDERECO)

QuebraCEP <- function(rua, uf_cidade, atual, inicio, fim) {
  df <- data.frame(ENDERECO=character(3), 
                   CEPI=numeric(3), 
                   CEPF=numeric(3))
  df$ENDERECO <- rep(rua, 3)
  df$`UF-CIDADE` <- rep(uf_cidade, 3)
  df$CEPI[1] <- inicio
  df$CEPF[1] <- atual - 1
  df$CEPI[2] <- atual
  df$CEPF[2] <- atual
  df$CEPI[3] <- atual + 1
  df$CEPF[3] <- fim
  return(df)
}

trt.por.cep <- merge(x = trt, y = geraCEP, by = "UF-CIDADE")
ind <- (str_length(trt.por.cep$ENDERECO) > 5)
trt.por.cep <- trt.por.cep[ind, ]
trt.por.cep %<>% select(ENDERECO, `UF-CIDADE`, CEP, `CEP INI 1`, `CEP FIM 1`)

t <- mapply(QuebraCEP, trt.por.cep$ENDERECO, trt.por.cep$`UF-CIDADE`, 
            trt.por.cep$CEP, trt.por.cep$`CEP INI 1`, trt.por.cep$`CEP FIM 1`)

ConvertToDF3 <- function(alist, j=0) {
  df3 <- data.frame(character(3), numeric(3), numeric(3), character(3))
  names(df3) <- c("ENDERECO", "CEPI", "CEPF", "UF-CIDADE")
  df3$ENDERECO <- alist[[1 + j]]
  df3$CEPI <- alist[[2 + j]]
  df3$CEPF <- alist[[3 + j]]
  df3$`UF-CIDADE` <- alist[[4 + j]]
  return(df3)
}

j <- seq.int(from = 0, to = length(t) - 4, by = 4)
df <- list()
for (i in seq_along(j)) {
  df[[i]] <- ConvertToDF3(t, j[i])
}
df <- Reduce(rbind, df)
trt.cvrg <- df %>% select(ENDERECO, `UF-CIDADE`, CEPI, CEPF)
