# 
# Microeconometrics Project
# Created: 2023-03-19
# Last updated: 2023-05-16
# Names (ID)
#  - Takaaki Kishida (22418495)
#  - Emilien Curchod (16420275)
# 


# Packages ----------------------------------------------------------------

pacman::p_load(here, tidyverse, stargazer, summarytools, labelled, lubridate, fixest, MASS)



# Read and Build Data -----------------------------------------------------

source("src/0_make.R")



# Visualization -----------------------------------------------------------

df_reg %>% 
  dplyr::count(p19n109) %>% 
  dplyr::mutate(account = case_when(p19n109 == 1 ~ "Facebook",
                                    p19n109 == 3 ~ "LinkedIn",
                                    p19n109 == 5 ~ "Twitter",
                                    p19n109 == 6 ~ "Xing",
                                    p19n109 == 7 ~ "Other",
                                    # .default = "NA"
                                    )) %>%  
  dplyr::group_by(account) %>% 
  dplyr::summarize(n = sum(n)) %>% 
  ggplot(aes(x = account, y = n)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(limits = c(0, 3800), expand = c(0, 0)) +
  geom_text(aes(label = n), vjust = -0.25) +
  theme_bw() +
  scale_x_discrete(drop = FALSE) +
  labs(title = "Social Network Sites People Use", 
       x = "", 
       y = "")


## Trust in People ----
df_reg %>%
  dplyr::count(trust_people) %>%
  dplyr::mutate(trust_people = case_when(is.na(trust_people) ~ "NA",
                                         TRUE ~ as.character(trust_people))) %>%
  ggplot(aes(x = trust_people, y = n)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(limits = c(0, 1500), expand = c(0, 0)) +
  geom_text(aes(label = n), vjust = -0.25) +
  theme_bw() +
  scale_x_discrete(drop = FALSE) +
  labs(title = "Trust in People: 0 (Can't be too careful) to 10 (Most people can be trusted)", 
       x = "", 
       y = "")


## Social Media Account ----
df_reg %>% 
  dplyr::count(has_sns_account) %>% 
  dplyr::mutate(has_sns_account = case_when(has_sns_account == 0 ~ "No",
                                            has_sns_account == 1 ~ "Yes")) %>% 
  ggplot(aes(x = has_sns_account, y = n)) + 
  geom_bar(stat = "identity") +
  scale_y_continuous(limits = c(0, 3000), expand = c(0, 0)) +
  geom_text(aes(label = n), vjust = -0.25) + 
  theme_bw() +
  labs(title = "The Number of People Having (any) Social Media Account",
       x = "",
       y = "") 
