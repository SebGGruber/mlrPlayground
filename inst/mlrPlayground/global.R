require(shinytest)
require(shiny)
require(e1071)
require(ranger)
require(xgboost)
require(igraph)
require(kknn)
require(plotly)
require(mlr)
require(shinycssloaders)
require(shinyBS)
require(shinyjs)
require(class)
require(R6)
require(assertthat)
require(kernlab)
require(extraTrees)
require(RWeka)
#require(mvtnorm) # can we not use this? R 3.5 is required
#require(fpc)
#require(clusterSim)
require(clValid)
require(testthat)


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

# configure mlr behaviour to be as quiet as possible as long as nothing breaks
configureMlr(on.learner.warning = "quiet", show.info = FALSE, show.learner.output = FALSE)

### COLORS FOR PLOTS
# class 1 (red-ish)
color_1 = "#CE1B28"
# class 2 (blue-ish)
color_2 = "#428bca"
# pred class 1
color_11 = "#d74852"
# pred class 2
color_21 = "#67a2d4"

# there are two packages include dunn
dunn = mlr::dunn
