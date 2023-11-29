# libraries and setup --------------------------------------------------------
library(tidyverse)
library(shiny)
# library(shinythemes)
library(kableExtra)
library(LDAvis)

# Define server logic required

skim_html <-
  read_file('skim_workaround.html')

coal <-
  read_rds('data/raw_coal_data.rds')

analysis <- 
  read_file('coal_analysis.html')

server <- function(input, output) {
  
  # starterPanel data ----------------------------------------------------------
  
  output$skimmer <- 
    renderText({ skim_html })
  
  # resultsPanel data ----------------------------------------------------------
  
  output$analysis <-
    renderText({ analysis})
  
  # explorerPanel data ---------------------------------------------------------
  
  get_rand_row <- eventReactive(input$random_row, {
    return(coal %>%
             sample_n(1) %>%
             select(NARRATIVE) %>%
             kable())})
  
  output$random_row <- 
    renderText({ get_rand_row() })
}
