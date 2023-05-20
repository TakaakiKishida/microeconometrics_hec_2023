# 
# Microeconometrics Project
# Created: 2023-03-19
# Last updated: 2023-05-16
# Names (ID)
#  - Takaaki Kishida (22418495)
#  - Emilien Curchod (16420275)
# 


# Read Data ---------------------------------------------------------------

load(file = here::here("data/SHP.Rdat"))
df <- DATA
df <- labelled::remove_labels(df)
rm(DATA)



# Make Variables ----------------------------------------------------------

df_reg <- df %>%
  mutate_all(as.character) %>% 
  dplyr::mutate(trust_people = dplyr::case_when(p19p45 == "-2" ~ "NA",
                                                p19p45 == "-1" ~ "NA",
                                                TRUE ~ p19p45),
                has_sns_account = dplyr::case_when(p19n108 == "-3" ~ "NA",
                                                   p19n108 == "-2" ~ "NA",
                                                   p19n108 == "-1" ~ "NA",
                                                   p19n108 == "1" ~ "1",
                                                   p19n108 == "2" ~ "0"),
                has_FB_account = dplyr::case_when(p19n109 == "1" ~ "1",
                                                  TRUE ~ "0"),
                income = dplyr::case_when(i19ptotn %in% c(-8, -4, -2, -1) ~ "NA",
                                          TRUE ~ as.character(i19ptotn)),
                life_satisfaction = dplyr::case_when(p19c44 %in% c(-2, -1) ~ "NA",
                                                     TRUE ~ as.character(p19c44)),
                is_female = dplyr::case_when(sex19 == 1 ~ 0,
                                             sex19 == 2 ~ 1)
                ) %>% 
  mutate_at(vars(-("pdate19")), as.numeric) %>% 
  dplyr::mutate(age19_2 = age19^2) 



# Make Subsets of Data ----------------------------------------------------

## Age b/w 15 and 60 ----
df_sub_young <- df_reg %>% 
  dplyr::filter(age19 %in% c(15:60)) 

## Age above > 60 ----
df_sub_old <- df_reg %>% 
  dplyr::filter(age19 >= 61) 

