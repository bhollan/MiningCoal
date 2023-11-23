# libraries and titles -------------------------------------------------------

library(tidyverse)
library(shiny)
library(datasets)
library(digest)
library(shinythemes)
library(shinycssloaders)

# Define UI for application

ui <- fluidPage(
  theme = shinytheme('slate'),
  
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
      actionButton(
        'random_row',
        'Pick Random Row',
        icon = icon('dice-five')),
      withSpinner(
        htmlOutput("random_row"))))
)
