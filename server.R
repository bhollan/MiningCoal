library(tidyverse)
library(shiny)
library(datasets)
library(digest)
library(shinythemes)

# Define server logic required

server <- function(input, output) {
  
  output$FirstPlot <- renderPlot({
    datasets::ChickWeight %>%
      filter(Time > input$Time[1],
             Time < input$Time[2]) %>%
      group_by(Time) %>%
      ggplot() + 
      geom_point(aes(x = Time, y = weight))
  })
  
  output$SecondPlot <- renderPlot({
    datasets::ChickWeight %>%
      filter(Diet %in% input$Diet) %>%
      group_by(Diet) %>%
      ggplot() +
      geom_point(aes(x = Diet, y = weight))
  })
  
  output$shaOutput <- renderText(digest(input$HashInputText, "sha256"))
}
