library(tidytext)
library(tidyr)
library(tidylda)
library(tidyverse)
library(Matrix)

# raw coal dataset from MSHA
docs <- read_rds('data/raw_coal_data.rds')


# tokenize using tidytext's unnest_tokens
tidy_docs <- docs %>%
  mutate(ACC_ID = as.character(ACC_ID)) %>%
  select(ACC_ID, NARRATIVE) %>%
  unnest_tokens(output = word,
                input = NARRATIVE,
                stopwords = stop_words$word,
                token = "ngrams",
                n_min = 1, n = 2) %>%
  count(ACC_ID, word) %>%
  filter(n>1) 
# Filtering for words/bigrams per document, rather than per corpus


# filter words that are just numbers
tidy_docs <- tidy_docs %>%
  filter(! stringr::str_detect(tidy_docs$word, "^[0-9]+$"))

# append observation level data
colnames(tidy_docs)[1:2] <- c("document", "term")

# turn a tidy tbl into a sparse dgCMatrix

# note tidylda has support for several document term matrix formats
d <- tidy_docs %>%
  cast_sparse(document, term, n)

set.seed(123)

lda_model <- tidylda(
  data = d,
  k = 10,
  iterations = 200,
  burnin = 175,
  alpha = 0.1, 
  eta = 0.05, 
  optimize_alpha = FALSE, 
  calc_likelihood = TRUE,
  calc_r2 = TRUE,
  return_data = FALSE)

