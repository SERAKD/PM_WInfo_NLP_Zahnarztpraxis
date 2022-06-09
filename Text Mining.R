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

remotes::install_github("PF2-pasteur-fr/SARTools")1



# 0. Behandlungsdoku reinladen
# Load corpus
behandlungsdoku <- read.delim("Behandlungsdoku.txt", col.names = "Aufzeichnungen", stringsAsFactors = FALSE)
# Vector of tweets
behandlungsdoku <-Behandlungsdoku$text
# View first 5 tweets
head( behandlungsdoku , 5)


# 1 behandlungsdoku Preprocessing
# 1.1 first steps: common preprocessing
behandlungsdoku_preprocess <- 
  tolower(behandlungsdoku) %>%
  removePunctuation(behandlungsdoku) %>%
  stripWhiteSpace(behandlungsdoku) #Funktioniert noch nicht, qdap packages werden nicht erfolgreich geladen

# 1.2 make a vector source & corpus (collection of documents)
# Make a Vector Source: behandlungsdoku_source
behandlungsdoku_source <- VectorSource(behandlungsdoku)
# Make a volatile corpus: behandlungsdoku_corpus
behandlungsdoku_corpus <- VCorpus(behandlungsdoku_source)
behandlungsdoku_corpus[[1]][1]
content(behandlungsdoku_corpus[[1]])
# Apply various preprocessing functions
tm_map(behandlungsdoku_corpus, removePunctuation)
tm_map(behandlungsdoku_corpus, content_transformer(replace_abbreviation)) #Funktioniert noch nicht, qdap packages werden nicht erfolgreich geladen

# 1.3 Word Stemming
# stem words
stem_words <- stemDocument(c("complicatedly", "complicated", "complication"))
stem_words
# Complete words using single word dictionary
stemCompletion(stem_words, c("complicate"))
# Complete words using entire corpus
stemCompletion(stem_words, behandlungsdoku_corpus)

# 2. TDM & DTM
# Generate TDM
behandlungsdoku_tdm <- TermDocumentMatrix(behandlungsdoku_corpus)
behandlungsdoku_tdm
# Generate DTM
behandlungsdoku_dtm <- DocumentTermMatrix(behandlungsdoku_corpus)
behandlungsdoku_dtm
# Generate WFM (Word Frequency Matrix)
library(stringr, lib.loc=".", verbose=TRUE)
library(qdap, lib.loc=".", verbose=TRUE)
library(qdap)
behandlungsdoku_wfm <- wfm(behandlungsdoku_corpus)
plot(behandlungsdoku_wfm)
max(behandlungsdoku_wfm)
sort(behandlungsdoku_wfm,decreasing= TRUE)




