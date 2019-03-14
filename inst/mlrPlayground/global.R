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
  "class"
)

for (package in required_packages)
  require(package, character.only = TRUE)


# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

# READ AND PARSE CONFIG
text      = read.csv(file = "../../learner.config", quote = "", header = FALSE, sep = "\n")
fst_index = which(text$V1 == "### Valid learners")
snd_index = which(text$V1 == "### Hyperparameter definitions")
# list of valid learners (factor format)
valid_learners  = text$V1[(fst_index + 1) : (snd_index - 1)]
hyperparameters = text$V1[(snd_index + 1) : nrow(text)]

# dataframe of hyperparameter configurations
param_df = read.table(text = as.character(hyperparameters),  header = TRUE, sep = ",", dec = ".")
# factor to character
param_df = lapply(param_df, as.character)
# whitespace trimming
param_df[c("short.name", "param.name", "new.name")] = lapply(param_df[c("short.name", "param.name", "new.name")], trimws)
# character to integer (don't skip as.character here!!!)
param_df[c("new.min", "new.max", "new.default")] = lapply(param_df[c("new.min", "new.max", "new.default")], as.integer)
