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


source("R6Classes/LearningProcess.R",          local = TRUE)
source("R6Classes/ClassifLearningProcess.R",   local = TRUE)
source("R6Classes/Classif3dLearningProcess.R", local = TRUE)
source("R6Classes/RegrLearningProcess.R",      local = TRUE)
source("R6Classes/Regr3dLearningProcess.R",    local = TRUE)
source("R6Classes/ClusterLearningProcess.R",   local = TRUE)


# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

# READ AND PARSE CONFIG (TODO: put into function)
config = list()
text      = read.csv(file = "learner.config", quote = "", header = FALSE, sep = "\n")
fst_index = which(text$V1 == "### Valid learners")
snd_index = which(text$V1 == "### Hyperparameter definitions")
# list of valid learners (factor format)
config$valid.learners  = text$V1[(fst_index + 1) : (snd_index - 1)]
hyperparameters = text$V1[(snd_index + 1) : nrow(text)]

# dataframe of hyperparameter configurations
param_df = read.table(text = as.character(hyperparameters),  header = TRUE, sep = ",", dec = ".")
# factor to character
param_df = lapply(param_df, as.character)
# whitespace trimming
param_df[c("short.name", "param.name", "new.name")] = lapply(param_df[c("short.name", "param.name", "new.name")], trimws)
# character to integer (don't skip as.character here!!!)
param_df[c("new.min", "new.max", "new.default")] = lapply(param_df[c("new.min", "new.max", "new.default")], as.integer)
config$param_df
# init process variable, so req(process) doesn't crash during start
process = NULL
