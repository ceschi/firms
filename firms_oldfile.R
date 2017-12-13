##### Firms and wages ####

library(tidyverse)

#### Importing and tidying data ####

# importing data
df=read_delim('D:\\emanu\\OneDrive\\Datasets\\Amadeus\\amadeus_clean.csv', na='nan', col_names=T, delim=';')

# subsampling & rename
db_firms=data.frame(df[,212], df[, 62:91], df[, 122:136],  df[,217], df[,218])
names(db_firms) <- c('id', paste(rep('empl', 15),-1*(-2011:-1997), sep=''),
                  paste(rep('sales', 15),-1*(-2011:-1997), sep='.'),
                  paste(rep('staff', 15),-1*(-2011:-1997), sep='.'), 'country', 'last')
rm(df)


db_firms <- data.frame(id=db_firms[,1],
                        data.frame(lapply(db_firms[,2:46], function (x) as.numeric(unlist(x)))), 
                        db_firms[,(ncol(db_firms)-1):ncol(db_firms)])

ratio <- db_firms[, 32:46]/db_firms[, 2:16]

names(ratio) <- paste(rep('ratio', ncol(ratio)), -1*(-2011:-1997), sep='.')

db_wage <- data.frame(id=db_firms[,1], ratio, db_firms[,17:31], db_firms[,47:48])
rm(ratio, db_firms)

db_wage <- subset(db_wage, id != 'ACCNR')

db_long <- reshape(db_wage, direction='long', 
                         idvar=c('id'),        
                            # identificatore unico,per osservazione, tipo: idvar=c('famiglia', componente) per riflettere gerarchia
                         varying=c(2:31),      
                            # varying identifica le variabili che variano (con la data in questo caso)// set di variabli
                         new.row.names= NULL)
                            # se unbalanced i.e. ratio non osservato in 2011, aggiungere colonna vuota con nome ad hoc 
db_long_ord <- sort()

row.names(db_long) <- NULL    # removes row names
rm(db_wage)

# remove 'Inf's and NA's maybe

db_short <- subset(db_long, ratio<Inf)
