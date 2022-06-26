# Gestaltung, Anwendung und Erprobung von Text Mining und Natural Language Processing an einem Praxis Case
# Übersetzung vom zahnärztlichen Mitschriften in textuelle Behandlungs- Beschreibungen bzw. Basis-Texte für Rechnungen

# 1. Text Mining

library(devtools)
install_github("trinker/qdapDictionaries")
install_github("trinker/qdapRegex")
install_github("trinker/qdapTools")
install_github("trinker/qdap")
library(qdapDictionaries)
library(dplyr)
library(tm)
library(qdap)
library(qdaptools)
library(qdapRegex)

remotes::install_github("PF2-pasteur-fr/SARTools")



# 0. Dok1privaat.txt reinladen
# Load corpus
behandlungsdoku_privat <- read.delim("Dok1privatnurMitschriften.txt", col.names = "Aufzeichnungen", stringsAsFactors = FALSE, fileEncoding="UTF-16LE")
# Vector of tweets
behandlungsdoku_privat <-behandlungsdoku_privat$text
# View first 5 tweets
head( behandlungsdoku_privat , 5)


# 1 behandlungsdoku Preprocessing
# 1.1 first steps: common preprocessing
behandlungsdoku_privat_preprocess <- 
  tolower(behandlungsdoku_privat) %>%
  removePunctuation(behandlungsdoku_privat) #%>%
  #stripWhiteSpace(behandlungsdoku) #Funktioniert noch nicht, qdap packages werden nicht erfolgreich geladen

# 1.2 make a vector source & corpus (collection of documents)
# Make a Vector Source: behandlungsdoku_source
behandlungsdoku_privat_source <- VectorSource(behandlungsdoku_privat)
# Make a volatile corpus: behandlungsdoku_corpus
behandlungsdoku_privat_corpus <- VCorpus(behandlungsdoku_privat_source)
behandlungsdoku_privat_corpus[[1]][1]
content(behandlungsdoku_privat_corpus[[1]])
# Apply various preprocessing functions
tm_map(behandlungsdoku_privat_corpus, removePunctuation)
tm_map(behandlungsdoku_privat_corpus, content_transformer(replace_abbreviation)) #Funktioniert noch nicht, qdap packages werden nicht erfolgreich geladen

# 1.3 Word Stemming
# stem words
#stem_words <- stemDocument(c("complicatedly", "complicated", "complication"))
#stem_words
# Complete words using single word dictionary
#stemCompletion(stem_words, c("complicate"))
# Complete words using entire corpus
#stemCompletion(stem_words, behandlungsdoku_corpus)

# 2. TDM & DTM
# Generate TDM
behandlungsdoku_privat_tdm <- TermDocumentMatrix(behandlungsdoku_privat_corpus)
behandlungsdoku_privat_tdm
# Generate DTM
behandlungsdoku_privat_dtm <- DocumentTermMatrix(behandlungsdoku_privat_corpus)
behandlungsdoku_privat_dtm
# Generate WFM (Word Frequency Matrix)
library(stringr, lib.loc=".", verbose=TRUE)
library(qdap, lib.loc=".", verbose=TRUE)
library(qdap)
behandlungsdoku_privat_wfm <- wfm(behandlungsdoku_privat_corpus)
plot(behandlungsdoku_privat_wfm)
max(behandlungsdoku_privat_wfm)
sort(behandlungsdoku_privat_wfm,decreasing= TRUE)

behandlungsdoku_privat_wfm

# Ergebnisse für die Weiterverarbeitung als xlsx Datei exportieren
install.packages("writexl")
install.packages(c("readxl","writexl")) 
library(readxl)
library(writexl)
df_behandlungsdoku_privat_wfm <- as.data.frame(df_behandlungsdoku_privat_wfm)
df_behandlungsdoku_privat_wfm <- setNames(cbind(rownames(df_behandlungsdoku_privat_wfm), df_behandlungsdoku_privat_wfm, row.names = NULL), 
           c("Woerter", "Anzahl"))
#library(tidyverse)
#rownames_to_column(df_behandlungsdoku_privat_wfm, var = "Woerter")

write_xlsx(df_behandlungsdoku_privat_wfm,"WoerterAnzahl.xlsx")

