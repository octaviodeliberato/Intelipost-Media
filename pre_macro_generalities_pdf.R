library(dplyr)
library(magrittr)
library(tabulizer)
library(stringr)

# Location of pdf file
location <- 'C:/Users/BlueShift075/Documents/GitHub/Intelipost-Media/data-raw/cliente-eb/55004_PROPOSTA - EB - 28.02.19.pdf'

# Extract the table
# locate_areas(location)
out <- extract_tables(location, pages = 1, guess = F,
                      output = "data.frame", area = list(c(354, 29,
                                                           616, 474)))
df <- out[[1]]
df <- df[, c(1, 3)]
names(df) <- c("X__1", "X__11")
df <- df[str_length(df$X__11) > 1, ]
df <- df[1:(nrow(df) - 4), ]

de_para <- c("gris_value", "gris_min",
             "toll_value",
             "delivery_value",
             "tas_value",
             "other_fee_value", "other_fee_fraction", 
             "cubic_factor", "tda_value",
             "tda_min", "tda_max",
             "UNKNOWN","UNKNOWN",
             "trt_value", "trt_min",
             "icms_tax_enable", "iss_tax_enable")


lastRow <- df[1:2, ]
lastRow$X__1[1] <- "ICMS"; lastRow$X__11[1] <- "true"
lastRow$X__1[2] <- "ISS"; lastRow$X__11[2] <- "true"
df <- rbind(df, lastRow)
df$X__1 <- de_para
df <- filter(df, X__1 != "UNKNOWN")
df[, 2] %<>% str_replace(pattern = "%", "")
df[, 2] <- ifelse(str_detect(df[, 2], "kg"), 
                  str_extract(df[, 2], pattern = "[:digit:]+(?=k)"), df[, 2])

rio::export(df, "generalities_pdf.xlsx")
