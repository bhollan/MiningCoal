# libraries and data reading ---------------------------------------------

library(tidytext)
library(tidyr)
library(tidylda)
library(tidyverse)
library(Matrix)
library(broom)

# raw coal dataset from MSHA
docs <- read_rds('data/raw_coal_data.rds')

# LDA modeling ---------------------------------------------------------

# tokenize using tidytext's unnest_tokens
tidy_docs <- docs %>%
  mutate(ACC_ID = as.character(ACC_ID)) %>%
  select(ACC_ID, NARRATIVE) %>%
  unnest_tokens(
    output = word,
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
# tidylda has support for several document term matrix formats
d <- tidy_docs %>%
  cast_sparse(document, term, n)

set.seed(123)

lda_model <- 
  tidylda(
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

# save model for quick-reading later
# write_rds(lda_model, "data/lda_model.RDS")

# TODO:
# Somehow from the trained model it seems like only training on
# 154949 documents instead of the given 231866 documents

# augment LDA matrix(es) with document IDs (join table: doc, term, topic)
join_table <- 
  augment(
    lda_model, 
    data = tidy_docs)

# save table for quick-reading later
# write_rds(join_table, "data/join_table.RDS")


# PCA modeling -------------------------------------------------------------


# We want to eliminate ID numbers that are unique to rows, like
# accidents and documents, but preserve ID numbers that 
# would make sense in aggregate (like company, mine, etc)

# These are either unwanted ID columns, or had too many coincidental missing
drop_cols <-
  c('ACC_ID',
    'DOCUMENT_NO',
    'CLOSED_DOC_NO',
    #    'TOT_EXPER',    I kept this column (good variation, but 40k missing)
    'MINE_EXPER',
    'JOB_EXPER',
    'SCHEDULE_CHARGE',
    'DAYS_RESTRICT',
    'DAYS_LOST')


pca_docs <-
  docs %>%
  select(
    where(is.numeric),
    -all_of(drop_cols)) %>%
  drop_na() %>%
  select_if(colSums(.) != 0)


pca_model <-
  pca_docs %>%
  prcomp(scale = TRUE)

joined_pca <-
  pca_model %>%
  augment(pca_docs)


# plot data on PCs
joined_pca %>%
  ggplot(
    aes(
      .fittedPC1,
      .fittedPC2)) +
  geom_point(size = 1.0)


# pca_model %>%
# tidy(matrix = 'rotation')


arrow_style <-
  arrow(
    angle = 20, 
    ends = "first", 
    type = "closed", 
    length = grid::unit(8, "pt"))

# plot rotation matrix
pca_model %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(
    names_from = "PC",
    names_prefix = "PC",
    values_from = "value") %>%
  ggplot(aes(PC1, PC2)) +
  geom_segment(
    xend = 0,
    yend = 0,
    arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1,
    nudge_x = -0.02, 
    check_overlap = TRUE,
    color = "#904C2F") +
  xlim(-0.5, 0.05) +
  ylim(-.3, 0.6) +
  coord_fixed()         # fix aspect ratio to 1:1



