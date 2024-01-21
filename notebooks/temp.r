
install.packages(c(
"openxlsx"
,"tidyverse" # view(tidyverse_deps(recursive = FALSE)) # was ist alles drin in tidyverse?
,"readr"
,"lubridate"
,"clipr"
# ,"utils" # sollte normalerweise von vornherein geladen sein
,"Hmisc" # für capitalize(Vorname) etc.
,"sjmisc" # for move_columns()
,"readxl"
,"usethis" #for edit_file
,"esquisse" 
))
install.packages(c(
  "reticulate"
))

library(reticulate)
py_install("seaborn")
# restart RStudio (in the cloud upper right 3 dots 'Relaunch Project') before running
use_virtualenv("r-reticulate")
repl_python()
