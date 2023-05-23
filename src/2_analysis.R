# 
# Microeconometrics Project
# Created: 2023-03-19
# Last updated: 2023-05-20
# Names (ID)
#  - Takaaki Kishida (22418495)
#  - Emilien Curchod (16420275)
# 


# Packages ----------------------------------------------------------------

pacman::p_load(here, tidyverse, stargazer, summarytools, labelled, lubridate, fixest, MASS)



# Read and Build Data -----------------------------------------------------

source("src/0_make.R")



# OLS ---------------------------------------------------------------------

## 1.1. Whole Sample ----

# Model 1
m1 <- df_reg %>% 
  feols(trust_people ~ has_sns_account, 
        cluster ~ idhous19) 

# Model 2
m2 <- df_reg %>% 
  feols(trust_people ~ 
          has_sns_account + is_female + log(income) + edyear19 + age19 + age19_2 + life_satisfaction,
        cluster ~ idhous19)

# Model 3
m3 <- df_reg %>% 
  feols(trust_people ~ 
          has_sns_account + is_female + log(income) + edyear19 + age19  + age19_2 + life_satisfaction | pdate19,
        cluster ~ idhous19)

# Display the results 
etable(m1, m2, m3, 
       signif.code = c("***" = 0.01, "**" = 0.05, "*" = 0.10))


## 1.2. By Age ----

df_sub_young %>% 
  summarize(mean = mean(has_sns_account, na.rm = T))

df_sub_old %>% 
  summarize(mean = mean(has_sns_account, na.rm = T))

# Model 1
m_age1 <- df_sub_young %>% 
  feols(trust_people ~ 
          has_sns_account + is_female + log(income) + edyear19 + age19  + age19_2 + life_satisfaction | pdate19,
        cluster ~ idhous19)

# Model 2
m_age2 <- df_sub_old %>% 
  feols(trust_people ~ 
          has_sns_account + is_female + log(income) + edyear19 + age19  + age19_2 + life_satisfaction | pdate19,
        cluster ~ idhous19)

# Display the results 
etable(m_age1, m_age2,
       signif.code = c("***" = 0.01, "**" = 0.05, "*" = 0.10))



# Ordered Probit / Logit --------------------------------------------------

## 2.1. Whole Sample ----

# Model 1: Probit
op1 <- polr(as.factor(trust_people) ~ has_sns_account,
            data = df_reg,
            Hess = TRUE,
            method = "probit")

# Model 2: Probit
op2 <- polr(as.factor(trust_people) ~ 
              has_sns_account + is_female + log(income) + edyear19 + age19 + I(age19^2 /100) + life_satisfaction,
            data = df_reg,
            Hess = TRUE,
            method = "probit")

# Model 3: Logit
ol1 <- polr(as.factor(trust_people) ~ has_sns_account,
            data = df_reg,
            Hess = TRUE,
            method = "logistic")

# Model 4: Logit
ol2 <- polr(as.factor(trust_people) ~ 
              has_sns_account + is_female + log(income) + edyear19 + age19 + life_satisfaction,
            data = df_reg,
            Hess = TRUE,
            method = "logistic")

# Display the results 
stargazer::stargazer(op1, op2, ol1, ol2,
                     ord.intercepts = TRUE, 
                     type = "text",
                     no.space = TRUE)


### 2.1.1 Marginal Effects ----

# In the predict() function for the model from the MASS::polr(), 
# the type argument does not have an option for `response` to obtain 
# the predicted probabilities directly.
# --> Instead, we use `type = "probs"`. 

# Make counterfactual datasets: 

# When years of life satisfaction (0-10 scale) increased by 1 point
df_reg_hypoth_satis <- df_reg %>% 
  dplyr::mutate(life_satisfaction = life_satisfaction + 1) 
  
# When years of education increased by 1 year
df_reg_hypoth_educ <- df_reg %>% 
  dplyr::mutate(edyear19 = edyear19 + 1) 
  
# Obtain predictions: Probit
op2_predict <- predict(op2, newdata = df_reg, type = "probs")
op2_predict_satis <- predict(op2, newdata = df_reg_hypoth_satis, type = "probs")
op2_predict_educ <- predict(op2, newdata = df_reg_hypoth_educ, type = "probs")

# Obtain predictions: Logit
ol2_predict <- predict(ol2, newdata = df_reg, type = "probs")
ol2_predict_satis <- predict(ol2, newdata = df_reg_hypoth_satis, type = "probs")
ol2_predict_educ <- predict(ol2, newdata = df_reg_hypoth_educ, type = "probs")

# Subtract probs resulting from the original dataset from counterfactual dataset
mean(op2_predict_satis - op2_predict, na.rm = TRUE)
mean(op2_predict_educ - op2_predict, na.rm = TRUE)

mean(ol2_predict_satis - ol2_predict, na.rm = TRUE)
mean(ol2_predict_educ - ol2_predict, na.rm = TRUE)


## 2.2. By Age ----

op_young <- polr(as.factor(trust_people) ~ 
              has_sns_account + is_female + log(income) + edyear19 + age19 + life_satisfaction,
            data = df_sub_young,
            Hess = TRUE,
            method = "probit")

ol_young <- polr(as.factor(trust_people) ~ 
              has_sns_account + is_female + log(income) + edyear19 + age19 + life_satisfaction,
            data = df_sub_young,
            Hess = TRUE,
            method = "logistic")

op_old <- polr(as.factor(trust_people) ~ 
              has_sns_account + is_female + log(income) + edyear19 + age19 + life_satisfaction,
            data = df_sub_old,
            Hess = TRUE,
            method = "probit")

ol_old <- polr(as.factor(trust_people) ~ 
              has_sns_account + is_female + log(income) + edyear19 + age19 + life_satisfaction,
            data = df_sub_old,
            Hess = TRUE,
            method = "logistic")

stargazer::stargazer(op_young, ol_young, op_old, ol_old,
                     ord.intercepts = TRUE, 
                     type = "text",
                     no.space = TRUE)


### 2.2.1 Marginal Effects ----

# Make counterfactual datasets: 

# When years of life satisfaction (0-10 scale) increased by 1 point
## Young
df_sub_young_hypoth_satis <- df_sub_young %>% 
  dplyr::mutate(life_satisfaction = life_satisfaction + 1) 
# Old
df_sub_old_hypoth_satis <- df_sub_old %>% 
  dplyr::mutate(life_satisfaction = life_satisfaction + 1) 

# When years of education increased by 1 year
## Young
df_sub_young_hypoth_educ <- df_sub_young %>% 
  dplyr::mutate(edyear19 = edyear19 + 1) 
# Old
df_sub_old_hypoth_educ <- df_sub_old %>% 
  dplyr::mutate(edyear19 = edyear19 + 1) 

# Obtain predictions: Probit
op2_predict <- predict(op_young, newdata = df_sub_young, type = "probs")
op2_predict_satis_young <- predict(op_young, newdata = df_sub_young_hypoth_satis, type = "probs")
op2_predict_satis_old <- predict(op_young, newdata = df_sub_old_hypoth_satis, type = "probs")
op2_predict_educ_young <- predict(op_young, newdata = df_sub_young_hypoth_educ, type = "probs")
op2_predict_educ_old <- predict(op_young, newdata = df_sub_old_hypoth_educ, type = "probs")

# Obtain predictions: Logit
ol2_predict <- predict(ol_young, newdata = df_sub_young, type = "probs")
ol2_predict_satis_young <- predict(ol_young, newdata = df_sub_young_hypoth_satis, type = "probs")
ol2_predict_satis_old <- predict(ol_old, newdata = df_sub_old_hypoth_satis, type = "probs")
ol2_predict_educ_young <- predict(ol_young, newdata = df_sub_young_hypoth_educ, type = "probs")
ol2_predict_educ_old <- predict(ol_old, newdata = df_sub_old_hypoth_educ, type = "probs")

# Subtract probs resulting from the original dataset from counterfactual dataset
mean(ol2_predict_satis_young - ol2_predict, na.rm = TRUE)
mean(ol2_predict_satis_old - ol2_predict, na.rm = TRUE)

mean(ol2_predict_educ_young - ol2_predict, na.rm = TRUE)
mean(ol2_predict_educ_old - ol2_predict, na.rm = TRUE)

# mean(ol2_predict_satis - ol2_predict, na.rm = TRUE)
# mean(ol2_predict_educ - ol2_predict, na.rm = TRUE)