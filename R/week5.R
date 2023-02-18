# Script Settings and Resources 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(lubridate)

# Data Import 
Adata_tbl = read_delim("../data/Aparticipants.dat", delim = "-", col_names = c("casenum", "parnum","stimver","datadate","qs"), show_col_types = FALSE)
Anotes_tbl = read_csv("../data/Anotes.csv", show_col_types = FALSE)
Bdata_tbl = read_delim("../data/Bparticipants.dat", delim = "\t", col_names = c("casenum", "parnum", "stimver", "datadate", paste0("q",1:10)), show_col_types = FALSE)
Bnotes_tbl = read_delim("../data/Bnotes.txt", delim = "\t", show_col_types = FALSE)

# Data Cleaning 
Aclean_tbl = Adata_tbl %>% 
  separate(col = qs, into = paste0("q",1:5), sep = " - ") %>% 
  mutate(datadate = mdy_hms(datadate)) %>% 
  mutate(across(q1:q5, as.integer)) %>% 
  left_join(Anotes_tbl, by = "parnum") %>% 
  filter(is.na(notes))
ABclean_tbl = Bdata_tbl %>% 
  mutate(datadate = mdy_hms(datadate)) %>% 
  mutate(across(q1:q10, as.integer)) %>% 
  left_join(Bnotes_tbl, by = "parnum") %>% 
  filter(is.na(notes)) %>% 
  select(-notes) %>% 
  bind_rows(Aclean_tbl, .id = "lab") # Double check
  
  

  
  
  