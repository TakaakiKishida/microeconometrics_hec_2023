# Microeconometrics 2023 Project


## About 
- This is a repository of Microeconometrics project. 
- This `README.md` can be easily read from the GitHub repository: 
  - https://github.com/TakaakiKishida/microeconometrics_hec_2023


## Names (ID)
- Takaaki Kishida (22418495)
- Emilien Curchod (16420275)


## Note
This repository will be deleted after this semester. 


## 1. Directory Structure
- `/data` contains the dataset of the Swiss Household Panel (SHP) data provided at class.

- `/src` contains all `.R` scripts needed to produce the results. 
  - `/0_make.R` reads data from `/output` and creates dataset for our analysis.
  - `/1_visualization.R` creates figures used in the presentation.
  - `/2_analysis.R` runs regressions presented in the presentation and make tables (in R Console).


## 2. Guidance on Replicating Results
- Code was executed successfully as of May 22, 2023. 
- To work with our code, you need to open the `.Rproj` file. 
- Required packages were installed/loaded in the beginning of each `.R` file. 
  - We use `pacman::p_load()` from `pacman` package. You need to install from CRAN via `install.packages("pacman")`. 
- `/src/0_make.R` is sourced in other `.R` files. Therefore, it is not necessary to run `/src/0_make.R` solely. 
- Execution of `/src/1_visualization.R` and `/src/2_analysis.R` is sufficient to replicate the results. 
