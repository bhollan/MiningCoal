# libraries and setup --------------------------------------------------------

library(tidyverse)
library(shiny)
library(kableExtra)

# Define server logic required

skim_html <-
  read_file('skim_workaround.html')

coal <-
  read_rds('data/raw_coal_data.rds')

analysis <- 
  read_file('coal_analysis.html')

join_table <-
  read_rds('data/join_table.rds')

joined_pca <-
  read_rds('data/joined_pca.rds')

pca_id <- 
  joined_pca %>%
  sample_n(1) %>%
  select(.rownames)

x <- 4

server <- function(input, output) {
  
  # starterPanel data ----------------------------------------------------------
  
  output$skimmer <- 
    renderText({ skim_html })
  
  # resultsPanel data ----------------------------------------------------------
  
  output$analysis <-
    renderText({ analysis})
  
  # explorerPanel data ---------------------------------------------------------
  
  ###### random narrative ---------------------------------
  get_rand_row <- 
    eventReactive(input$random_row, {
      return(coal %>%
               sample_n(1) %>%
               mutate(Narrative = NARRATIVE %>%
                        str_to_sentence()) %>%
               select(Narrative) %>%
               kable())})
  
  output$random_row <- 
    renderText({ get_rand_row() })
  ###### random-from-topic / topic_plot--------------------
  get_rand_from_topic <- 
    eventReactive(input$random_topical, {
      return(coal %>%
               filter(
                 ACC_ID == join_table %>%
                   filter(topic == input$topic_choice) %>%
                   sample_n(1) %>%
                   select(document) %>%
                   as.double()) %>%
               mutate(Narrative = NARRATIVE %>%
                        str_to_sentence()) %>%
               select(Narrative) %>%
               kable())})
  
  output$random_from_topic <- 
    renderText({ get_rand_from_topic() })
  
  output$topic_plot <- 
    renderPlot({
      t <- input$topic_choice %>%
        as.integer()
      
      fill_colors <-
        RColorBrewer::brewer.pal(
          12,
          'Paired')
      
      tidy(lda_model, 'beta') %>%
        group_by(topic) %>%
        slice_max(
          beta,
          n = 12) %>%
        ungroup() %>%
        arrange(
          topic,
          beta) %>%
        mutate(token = reorder_within(token, beta, topic)) %>%
        filter(topic == t) %>%
        ggplot(aes(beta, token)) +
        theme(text = element_text(size = 22)) +
        geom_col(
          show.legend = FALSE,
          fill = fill_colors[t]) +
        labs(
          title = "Probability of a token (word) for the selected topic") +
        xlab("Probability") +
        ylab("Token (word)") +
        scale_y_reordered() 
    })
  ###### random-by-prcomp ---------------------------------
  get_rand_from_pcx <- 
    eventReactive(input$random_by_pc, {
      
      input$pc_choice
      
      return(joined_pca %>%
               sample_n(1) %>%
               select(-starts_with('.fittedPC')) %>%
               kable())})
  
  output$rand_from_pcx <- 
    renderText({ get_rand_from_pcx() })
}






