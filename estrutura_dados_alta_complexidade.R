library(dplyr)
library(stringr)
library(rlist)
library(pipeR)
library(readxl)

filename <- "C:\\Users\\BlueShift075\\Downloads\\Arquivos Workshop\\Arquivos Workshop\\Alta Complexidade\\Enviado pela Transportadora\\Cliente 33\\15771_ECCOMERCE SAO PR teste sem isento.xlsx"
guias <- excel_sheets(filename)
guia <- guias[grepl("com", guias, ignore.case = T)]
ecomm <- read_excel(filename, sheet = guia, range = "B6:N19")
mynames <- c("peso", "tarifa.estadual", rep("tarifa.interestadual", 7), 
             rep("interiorizacao", 3), "redespacho")
coln <- 1:length(mynames)
names(ecomm) <- paste0(mynames, ".", coln)

firstRow <- ecomm[1, ]
ecomm <- ecomm[2:nrow(ecomm) ,]
ecomm <- ecomm %>% mutate_all(as.numeric)

firstRow$peso.1 <- NULL
firstRow$redespacho.13 <- NULL

aero.estadual.2 <- str_split(firstRow$tarifa.estadual.2, "\\s", simplify = T)
aero.interestadual.3 <- str_split(firstRow$tarifa.interestadual.3, 
                                  "\\s", simplify = T)
aero.interestadual.4 <- str_split(firstRow$tarifa.interestadual.4, 
                                  "\\s", simplify = T)
aero.interestadual.5 <- str_split(firstRow$tarifa.interestadual.5, 
                                  "\\s", simplify = T)
aero.interestadual.6 <- str_split(firstRow$tarifa.interestadual.6, 
                                  "\\s", simplify = T)
aero.interestadual.7 <- str_split(firstRow$tarifa.interestadual.7, 
                                  "\\s", simplify = T)
aero.interestadual.8 <- str_split(firstRow$tarifa.interestadual.8, 
                                  "\\s", simplify = T)
aero.interestadual.9 <- str_split(firstRow$tarifa.interestadual.9, 
                                  "\\s", simplify = T)

aero.interior.10 <- str_split(firstRow$interiorizacao.10, 
                              "\\s", simplify = T)
aero.interior.11 <- str_split(firstRow$interiorizacao.11, 
                              "\\s", simplify = T)
aero.interior.12 <- str_split(firstRow$interiorizacao.12, 
                              "\\s", simplify = T)
aero.redespacho.14 <- "redespacho"

# a <- reshape2::melt(data = ecomm, id.vars = "peso.1")

aux <- aero.estadual.2 %>% as.vector()
aero.estadual.2 <- list()
aero.estadual.2$tag <- aux
aero.estadual.2$tarifa.tipo <- "estadual"
aero.estadual.2$pesos <- ecomm$peso.1
aero.estadual.2$tarifa.valor <- ecomm$tarifa.estadual.2

aux <- aero.interestadual.3 %>% as.vector()
aero.interestadual.3 <- list()
aero.interestadual.3$tag <- aux
aero.interestadual.3$tarifa.tipo <- "interestadual"
aero.interestadual.3$pesos <- ecomm$peso.1
aero.interestadual.3$tarifa.valor <- ecomm$tarifa.interestadual.3

aux <- aero.interestadual.4 %>% as.vector()
aero.interestadual.4 <- list()
aero.interestadual.4$tag <- aux
aero.interestadual.4$tarifa.tipo <- "interestadual"
aero.interestadual.4$pesos <- ecomm$peso.1
aero.interestadual.4$tarifa.valor <- ecomm$tarifa.interestadual.4

aux <- aero.interestadual.5 %>% as.vector()
aero.interestadual.5 <- list()
aero.interestadual.5$tag <- aux
aero.interestadual.5$tarifa.tipo <- "interestadual"
aero.interestadual.5$pesos <- ecomm$peso.1
aero.interestadual.5$tarifa.valor <- ecomm$tarifa.interestadual.5

aux <- aero.interestadual.6 %>% as.vector()
aero.interestadual.6 <- list()
aero.interestadual.6$tag <- aux
aero.interestadual.6$tarifa.tipo <- "interestadual"
aero.interestadual.6$pesos <- ecomm$peso.1
aero.interestadual.6$tarifa.valor <- ecomm$tarifa.interestadual.6

aux <- aero.interestadual.7 %>% as.vector()
aero.interestadual.7 <- list()
aero.interestadual.7$tag <- aux
aero.interestadual.7$tarifa.tipo <- "interestadual"
aero.interestadual.7$pesos <- ecomm$peso.1
aero.interestadual.7$tarifa.valor <- ecomm$tarifa.interestadual.7

aux <- aero.interestadual.8 %>% as.vector()
aero.interestadual.8 <- list()
aero.interestadual.8$tag <- aux
aero.interestadual.8$tarifa.tipo <- "interestadual"
aero.interestadual.8$pesos <- ecomm$peso.1
aero.interestadual.8$tarifa.valor <- ecomm$tarifa.interestadual.8

aux <- aero.interestadual.9 %>% as.vector()
aero.interestadual.9 <- list()
aero.interestadual.9$tag <- aux
aero.interestadual.9$tarifa.tipo <- "interestadual"
aero.interestadual.9$pesos <- ecomm$peso.1
aero.interestadual.9$tarifa.valor <- ecomm$tarifa.interestadual.9

aux <- aero.interior.10 %>% as.vector()
aero.interior.10 <- list()
aero.interior.10$uf <- aux
aero.interior.10$tarifa.tipo <- "interiorização"
aero.interior.10$pesos <- ecomm$peso.1
aero.interior.10$tarifa.valor <- ecomm$interiorizacao.10

aux <- aero.interior.11 %>% as.vector()
aero.interior.11 <- list()
aero.interior.11$uf <- aux
aero.interior.11$tarifa.tipo <- "interiorização"
aero.interior.11$pesos <- ecomm$peso.1
aero.interior.11$tarifa.valor <- ecomm$interiorizacao.11

aux <- aero.interior.12 %>% as.vector()
aero.interior.12 <- list()
aero.interior.12$uf <- aux
aero.interior.12$tarifa.tipo <- "interiorização"
aero.interior.12$pesos <- ecomm$peso.1
aero.interior.12$tarifa.valor <- ecomm$interiorizacao.12

ecommerce <- list(aero.estadual.2,
                  aero.interestadual.3,
                  aero.interestadual.4,
                  aero.interestadual.5,
                  aero.interestadual.6,
                  aero.interestadual.7,
                  aero.interestadual.8,
                  aero.interestadual.9)

interiorizacao <- list(aero.interior.10,
                       aero.interior.11,
                       aero.interior.12)

interiorizacao[[1]][["tag"]] <- c("VIX", "CNF", "DIQ", "GVR", "IPN", "JDF", "MOC", "PLU", "POO", "QET", "UBA", "UDI", "VAG", "CAC", "CWB", "IGU", "LDB", "MGF", "GIG", "SDU", "GEL", "PFB", "POA", "URG", "CCM", "FLN", "JOI", "LAJ", "NVT", "XAP", "ARU", "CGH", "GRU", "JTC", "MII", "PPB", "RAO", "SJP", "VCP")

interiorizacao[[2]][["tag"]] <- c("MCZ", "BPS", "BRA", "IOS", "SSA", "VDC", "FOR", "JDO", "JJD", "BSB", "GYN", "IMP", "SLZ", "CPV", "JPA", "FEN", "PNZ", "REC", "THE", "NAT", "AJU")

interiorizacao[[3]][["tag"]] <- c("RBR", "MAO", "TBT", "TFF", "MCP", "CGR", "CMG", "DOU", "TJL", "AFL", "BPG", "CGB", "OPS", "ROO", "SMT", "ATM", "BEL", "CKS", "MAB", "STM", "BVH", "JPR", "OAL", "PVH", "BVB", "PMW")

for (i in seq_along(ecommerce)) {
  for (j in seq_along(interiorizacao)) {
    if (any(ecommerce[[i]][["tag"]] %in% interiorizacao[[j]][["tag"]])) {
      ecommerce[[i]][["tarifa.valor2"]] <- ecommerce[[i]][["tarifa.valor"]] + interiorizacao[[j]][["tarifa.valor"]]
      break
    }
  }
}

for (i in seq_along(ecommerce)) {
  ecommerce[[i]][["tarifa.redesp"]] <- ecomm$redespacho.13
}

mylist <- list()
aux <- list()

for (i in seq_along(ecommerce)) {
  for (j in seq_along(ecommerce[[i]][["tag"]])) {
    aux$tag <- rep(ecommerce[[i]]$tag[j], length(ecommerce[[i]]$pesos))
    aux$pesos <- ecommerce[[i]]$pesos
    aux$valor <- ecommerce[[i]]$tarifa.valor
    aux$valor2 <- ecommerce[[i]]$tarifa.valor2
    aux$redesp <- ecommerce[[i]]$tarifa.redesp
    mylist <- mylist %>>% list.append(aux)
  }
}

mydf <- NULL
for (i in seq_along(mylist)) {
  if (i == 1) {
    mydf <- list.cbind(mylist[[i]])
  } else {
    mydf <- rbind(mydf, list.cbind(mylist[[i]]))
  }
}

mydf <- as.data.frame(mydf)
