# libraries and setup --------------------------------------------------------
library(tidyverse)
library(shiny)
library(datasets)
library(digest)
library(shinythemes)
library(skimr)

# Define server logic required

skim_html <-
  read_file('skim_workaround.html')

coal <-
  read_rds('data/raw_coal_data.rds')

server <- function(input, output) {
  
  # starterPanel data ----------------------------------------------------------
  
  output$skimmer <- 
    renderText({ skim_html })
  
  # resultsPanel data ----------------------------------------------------------
  
  output$SecondPlot <- renderPlot({
    datasets::ChickWeight %>%
      filter(Diet %in% input$Diet) %>%
      group_by(Diet) %>%
      ggplot() +
      geom_point(aes(x = Diet, y = weight))
  })
  
  # explorerPanel data ---------------------------------------------------------
  output$shaOutput <- renderText(digest(input$HashInputText, "sha256"))
}

