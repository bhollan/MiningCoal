# libraries and setup --------------------------------------------------------

library(tidyverse)
library(tidylda)
library(tidytext)
library(shiny)
library(kableExtra)
library(treemapify)
library(tigris)
data('fips_codes')
fips_codes <-
  fips_codes %>%
  mutate(
    state_code = state_code %>% 
      as.double())

skim_html <-
  read_file('skim_workaround.html')

coal <-
  read_rds('data/raw_coal_data.rds')

analysis <- 
  read_file('coal_analysis.html')

lda_model <-
  read_rds('data/lda_model.rds')

treemaps <- list()

join_table <-
  read_rds('data/join_table.rds')

joined_pca <-
  read_rds('data/joined_pca.rds')

pca_id <- 
  joined_pca %>%
  sample_n(1) %>%
  select(.rownames)

# SERVER LOGIC -----------------------------------------------------------------

server <- function(input, output, session) {
  
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
  
  # SCATTER plotting -----------------------------------------------------------
  # These took literally so long to render that it would freeze Shiny
  # I don't like having them as images, but it's where I'm at
  
  scatterplots <- list(
    'days_vs_tot' = './figures/days_lost_vs_total_exp.png',
    'days_vs_mining' = './figures/days_lost_vs_mining_exp.png',
    'days_vs_job' = './figures/days_lost_vs_job_exp.png')
  
  output$days_lost_plot <- 
    renderImage({
      list(src = 
             scatterplots[[input$days_plot_pick]] %>%
             normalizePath(),
           width = '100%',
           height = '100%',
           alt = 'days lots vs experience')
    }, 
    deleteFile = FALSE)
  
  
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
  
  # TreeMap plotting --------------------------------------
  
  ###### Incidents per state-------------------------------
  incidents_per_state <- 
    coal %>% 
    summarise(
      num_incidents = n(),
      .by = FIPS_STATE_CD) %>%
    left_join(
      fips_codes,
      by = join_by(FIPS_STATE_CD == state_code)) %>%
    select(num_incidents, state) %>%
    unique()
  
  treemaps$inc_per_state <- 
    ggplot(incidents_per_state,
           aes(
             area = num_incidents, 
             label = state)) + 
    geom_treemap() + 
    geom_treemap_text(color = 'white') + 
    theme(text = element_text(size = 22)) +
    labs(
      title = "Incidents per US state/territory")
  ###### Mines per state----------------------------------
  mines_per_state <- 
    coal %>%
    select(c(
      FIPS_STATE_CD,
      MINE_ID)) %>%
    unique() %>%
    summarise(
      num_mines = n(),
      .by = FIPS_STATE_CD) %>%
    left_join(
      fips_codes,
      by = join_by(FIPS_STATE_CD == state_code)) %>%
    select(num_mines, state) %>%
    unique()
  
  treemaps$mines_per_state <- 
    ggplot(mines_per_state,
           aes(
             area = num_mines, 
             label = state)) + 
    geom_treemap() + 
    geom_treemap_text(color = 'white') + 
    theme(text = element_text(size = 22)) +
    labs(
      title = "Number of mines per US state/territory")
  ###### Incidents per mine------------------------------
  incidents_per_mine_by_state <-
    left_join(
      incidents_per_state,
      mines_per_state,
      by = 'state') %>%
    mutate(
      incidents_per_mine = num_incidents / num_mines) %>%
    select(state, incidents_per_mine)
  
  treemaps$inc_per_mine_state <- 
    ggplot(incidents_per_mine_by_state,
           aes(
             area = incidents_per_mine, 
             label = state)) + 
    geom_treemap() + 
    geom_treemap_text(color = 'white') + 
    theme(text = element_text(size = 22)) +
    labs(
      title = "Incidents per mine by US state/territory")
  
  # treemap switching -------------------------------------
  
  output$state_plot <- renderPlot({treemaps[[input$state_plot_pick]]})
  
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






