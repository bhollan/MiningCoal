library(tidyverse)
library(shiny)
library(datasets)
library(digest)
library(shinythemes)

# Define UI for application

ui <- fluidPage(
  theme = shinytheme('slate'),
  
  titlePanel("This is a demo dashboard (using canned R-datasets data)."),
  
  h2("Brian Holland"),
  
  tabsetPanel(
    tabPanel("Chick Wieghts over Time", 
             sliderInput("Time",
                         "Window of relevant time:",
                         min = 0,
                         max = 24,
                         value = c(0, 24)),
             # FIRST PLOT
             h3("Good Practices"),
             strong("Boldly go somewhere"),
             plotOutput("FirstPlot")
    ),
    tabPanel("Chick Weights by Deit",
             checkboxGroupInput("Diet",
                                "Diets of Chicks for plotting",
                                choices  = c("1", "2", "3", "4"),
                                selected = c("1", "2", "3", "4")),
             # SECOND PLOT
             h3("Bad Practices"),
             strong("Boldly go nowhere"),
             plotOutput("SecondPlot")),
    tabPanel("SHA256 of text",
             textInput("HashInputText",
                       "Text of Input for Hashing"),
             strong("SHA256 hash output of above text"),
             textOutput("shaOutput"),
             br(),
             br(),
             br(),
             strong("Bitcoin requires a hash that starts with X number of '0's (X depends on the current 'difficulty'). Can you find an input for which the output starts with 2 zeros? (a recent 'difficulty' level for Bitcoin required SEVENTEEN zeros!)"))
  )
)
