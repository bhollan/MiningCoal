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
  
  titlePanel("Mine Safety and Health Administration (MSHA) public incident reports from 2000 - 2018"),
  
  h4("Brian Holland"),
  
  tabsetPanel(
    
    # starter panel -----------------------------------------------------------
    
    tabPanel(
      "Start here (raw data)", 
      withSpinner(
        htmlOutput("skimmer"))),
    
    # results panel ------------------------------------------------------------
    
    tabPanel(
      "What I found (results)",
      checkboxGroupInput(
        "Diet",
        "Diets of Chicks for plotting",
        choices  = c("1", "2", "3", "4"),
        selected = c("1", "2", "3", "4")),
      
      h3("Bad Practices"),
      strong("Boldly go nowhere"),
      plotOutput("SecondPlot")),
    
    # explore panel ------------------------------------------------------------
    
    tabPanel(
      "What can you find? (explorer)",
      textInput(
        "HashInputText",
        "Text of Input for Hashing"),
      strong("SHA256 hash output of above text"),
      textOutput("shaOutput"),
      br(),
      br(),
      br(),
      strong("Bitcoin requires a hash that starts with X number of '0's (X depends on the current 'difficulty'). Can you find an input for which the output starts with 2 zeros? (a recent 'difficulty' level for Bitcoin required SEVENTEEN zeros!)"))))
