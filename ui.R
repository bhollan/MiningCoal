# libraries and titles -------------------------------------------------------

library(tidyverse)
library(shiny)
library(datasets)
library(digest)
library(shinycssloaders)

# Define UI for application

ui <- fluidPage(
  
  titlePanel('Mine Safety and Health Administration (MSHA) public incident reports from 2000 - 2018'),
  
  h4('Brian Holland'),
  
  tabsetPanel(
    
    # starter panel -----------------------------------------------------------
    
    tabPanel(
      'Start here (raw data)', 
      withSpinner(
        htmlOutput('skimmer'))),
    
    # results panel ------------------------------------------------------------
    
    tabPanel(
      'What I found (results)',
      withSpinner(
        htmlOutput('analysis'))),
    
    # explore panel ------------------------------------------------------------
    
    tabPanel(
      'What can you find? (explorer)',
      
      # random narrative button --------------------------------------------
      htmlOutput('random_row'),
      actionButton(
        'random_row',
        'Pick Random Row',
        icon = icon('dice-five')),
      br(),
      br(),
      # random-from-topic -------------------------------------------------
      htmlOutput('random_from_topic'),
      actionButton(
        'random_topical',
        'Pick Randomly from topic...',
        icon = icon('dice-six')),
      selectInput(
        'topic_choice',
        label = NULL,
        choices = 1:12),
      plotOutput("topic_plot"),
      # random-by-prcomp --------------------------------------------------
      htmlOutput('rand_from_pcx'),
      actionButton(
        'random_by_pc',
        'Get random from PC#...',
        icon = icon('dice-three')),
      selectInput(
        'pc_choice',
        label = NULL,
        choices = 1:16)
    ))
)


















