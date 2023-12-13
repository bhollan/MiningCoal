# libraries and titles -------------------------------------------------------

library(tidyverse)
library(shiny)
library(datasets)
library(digest)
library(shinycssloaders)

# Define UI for application

ui <- fluidPage(
  
  titlePanel('Mine Safety and Health Administration 
             (MSHA) public incident reports from 2000 - 2018'),
  
  h4('Brian Holland'),
  
  tabsetPanel(
    
    # starter panel -----------------------------------------------------------
    
    tabPanel(
      'Start here (raw data)', 
      withSpinner(
        type = 4,
        htmlOutput('skimmer'))),
    
    # results panel ------------------------------------------------------------
    
    tabPanel(
      'What I found (results)',
      withSpinner(
        type = 4,
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
      
      # days-lost-vs-experience plots ------------------------------------------
      selectInput(
        'days_plot_pick',
        label = 'Days Lost vs...',
        choices = list(
          `Total experience` = 'days_vs_tot',
          `Mining experience` = 'days_vs_mining',
          `Job experience (non-mining)` = 'days_vs_job')),
      withSpinner(
        type = 4,
        imageOutput(
            'days_lost_plot',
            height = '800px',
            width = '800px')),
      
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
      withSpinner(
        type = 4,
        plotOutput("topic_plot")),
      
      # random-by-prcomp --------------------------------------------------
      htmlOutput('rand_from_pcx'),
      actionButton(
        'random_by_pc',
        'Get random from PC#...',
        icon = icon('dice-three')),
      selectInput(
        'pc_choice',
        label = NULL,
        choices = 1:16),
      
      # state-tree-map plots ----------------------------------------------
      selectInput(
        'state_plot_pick',
        label = 'TreeMap Selector',
        choices = list(
          `Incidents per state` = 'inc_per_state',
          `Mines per state` = 'mines_per_state',
          `Incidents per mine` = 'inc_per_mine_state')),
      withSpinner(
        type = 4,
        plotOutput('state_plot')),
    ))
)


















