required_packages = c(
  "shiny",
  "e1071",
  "ranger",
  "xgboost",
  "igraph",
  "kknn",
  "extraTrees",
  "plotly",
  "mlr",
  "shinycssloaders",
  "shinyBS",
  "shinythemes",
  "class",
  "R6",
  "assertthat",
  "kernlab",
  "R.utils",
  "shinytest"
)

for (package in required_packages)
  require(package, character.only = TRUE)

# R6 classes definitions (one class per file, filename equals class name)
source("R6Classes/LearningProcess.R",          local = TRUE)
source("R6Classes/ClassifLearningProcess.R",   local = TRUE)
source("R6Classes/Classif3dLearningProcess.R", local = TRUE)
source("R6Classes/RegrLearningProcess.R",      local = TRUE)
source("R6Classes/Regr3dLearningProcess.R",    local = TRUE)
source("R6Classes/ClusterLearningProcess.R",   local = TRUE)
# helper functions ("read.config", "modified_req")
source("helpers.R",                            local = TRUE)
# function for calculating the data ("calculate_data")
source("datasets.R",                           local = TRUE)



# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

# READ AND PARSE CONFIG
config = read.config("learner.config")
# init process variable, so req(process) doesn't crash during start
process = NULL
