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

server <- function(input, output) {
  
  # starterPanel data ----------------------------------------------------------
  
  output$skimmer <- 
    renderText({ skim_html })
  
  # resultsPanel data ----------------------------------------------------------
  
  output$analysis <-
    renderText({ analysis})
  
  # explorerPanel data ---------------------------------------------------------
  
  get_rand_row <- 
    eventReactive(input$random_row, {
      return(coal %>%
               sample_n(1) %>%
               select(NARRATIVE) %>%
               kable())})
  
  output$random_row <- 
    renderText({ get_rand_row() })
  
  get_rand_from_topic <- 
    eventReactive(input$random_topical, {
      return(coal %>%
               filter(
                 ACC_ID == join_table %>%
                   filter(topic == input$topic_choice) %>%
                   sample_n(1) %>%
                   select(document) %>%
                   as.double()) %>%
               select(NARRATIVE) %>%
               kable())})
  
  output$random_from_topic <- 
    renderText({ get_rand_from_topic() })
  
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


# withSpinner(
#   htmlOutput('rand_from_pcx')),
# actionButton(
#   'random_by_pc',
#   'Get random from PC#...',
#   icon = icon('dice-three')),
# selectInput(
#   'pc_choice',
#   label = NULL,
#   choices = 1:16)







