# days lost vs total experience--------------------------

coal %>% 
  select(TOT_EXPER, DAYS_LOST) %>%
  drop_na() %>%
  ggplot() +
  geom_point(
    aes(
      x = TOT_EXPER, 
      y = DAYS_LOST),
    alpha = 0.5,
    size = 0.005) +
  labs(
    title = 'Days of work lost vs total work experience') +
  xlab('Total work experience (years)') +
  ylab('Days lost from incident')

# ggsave(
#   'figures/days_lost_vs_total_exp.png',
#   width = 20,
#   height = 20,
#   units = 'cm')

# days lost vs mining experience-------------------------

coal %>% 
  select(MINE_EXPER, DAYS_LOST) %>%
  drop_na() %>%
  ggplot() +
  geom_point(
    aes(
      x = MINE_EXPER, 
      y = DAYS_LOST),
    alpha = 0.5,
    size = 0.005) +
  labs(
    title = 'Days of work lost vs mining work experience') +
  xlab('Mining work experience (years)') +
  ylab('Days lost from incident')

# ggsave(
#   'figures/days_lost_vs_mining_exp.png',
#   width = 20,
#   height = 20,
#   units = 'cm')

# days lost vs job experience----------------------------

coal %>% 
  select(JOB_EXPER, DAYS_LOST) %>%
  drop_na() %>%
  ggplot() +
  geom_point(
    aes(
      x = JOB_EXPER, 
      y = DAYS_LOST),
    alpha = 0.5,
    size = 0.005) +
  labs(
    title = 'Days of work lost vs mining work experience') +
  xlab('Job experience (years)') +
  ylab('Days lost from incident')

# ggsave(
#   'figures/days_lost_vs_job_exp.png',
#   width = 20,
#   height = 20,
#   units = 'cm')
