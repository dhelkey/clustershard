##Generate periodic table data
library(RCurl)
library(dplyr)
#csv_raw = getURL(
#  "https://raw.githubusercontent.com/andrejewski/periodic-table/master/data.csv")
csv_parsed = read.csv(text=csv_raw)
c = csv_parsed

##Exclude elements
exclude_elements = c('Ac', 'Am')

e = csv_parsed[  ,c('symbol', 'name',
                              'atomicNumber',
                              'standardState',
                              'groupBlock')]

#Neat trick to apply to data.frame columns
e[] = lapply(e, as.character)
e[] = lapply(e, stringr::str_trim)
e = e[ !(e$symbol %in% exclude_elements), ]

#To save
elements = e
devtools::use_data(elements, overwrite = TRUE)
