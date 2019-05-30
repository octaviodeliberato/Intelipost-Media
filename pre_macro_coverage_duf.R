library(readxl)
# library(excel.link)
library(dplyr)
library(magrittr)
library(stringr)

filename <- "C:/Users/BlueShift075/Documents/GitHub/Intelipost-Media/GeraCEP_v2019.1.0.xlsx"

geraCEP <- read_excel(filename, col_names = TRUE)
geraCEP %<>% select(`UF-CIDADE`, `CEP INI 1`, `CEP FIM 1`)
geraCEP %<>% .[complete.cases(.), ]

ind.dupl <- duplicated(geraCEP$`UF-CIDADE`)
geraCEP <- geraCEP[!ind.dupl, ]
# geraCEP %<>% .[order(geraCEP$`UF-CIDADE`), ]

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

df <- list()
for (i in seq_along(trt$`UF-CIDADE`)) {
  for (j in seq_along(geraCEP$`UF-CIDADE`)) {
    if (trt$CEP[i] >= geraCEP$`CEP INI 1`[j] &&
        trt$CEP[i] <= geraCEP$`CEP FIM 1`[j]) {
      df[[i]] <- QuebraCEP(rua = trt$ENDERECO[i],
                           uf_cidade = trt$`UF-CIDADE`[i],
                           atual = trt$CEP[i],
                           inicio = geraCEP$`CEP INI 1`[j],
                           fim = geraCEP$`CEP FIM 1`[j]
                           )
      break
    }
  }
}

df <- Reduce(rbind, df)

trt.cvrg <- df %>% select(ENDERECO, `UF-CIDADE`, CEPI, CEPF)
cvrg <- df %>% select(`UF-CIDADE`)
new.names <- c("UF", "CIDADE")
cvrg <- cvrg %>% tidyr::separate(col = 1, into = new.names, 
                                 sep = "-", extra = "merge")
trt.cvrg$UF <- cvrg$UF
trt.cvrg$CIDADE <- cvrg$CIDADE
trt.cvrg <- trt.cvrg %>% select(ENDERECO, UF, CIDADE, `UF-CIDADE`, CEPI, CEPF)
