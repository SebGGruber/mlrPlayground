# WIP
#library(data.table)
text = read.csv(file = "learner.config", quote = "", header = FALSE, sep = "\n")
fst_index = which(text$V1 == "### Valid learners")
snd_index = which(text$V1 == "### Hyperparameter definitions")
# list of valid learners (factor format)
valid_learners  = text$V1[(fst_index + 1) : (snd_index - 1)]
hyperparameters = text$V1[(snd_index + 1) : nrow(text)]

# dataframe of hyperparameter configurations
param_df = read.table(text = as.character(hyperparameters),  header = TRUE, sep = ",", dec = ".")
