modified_req = function(x){
  #' @description modified version of the req function
  #' doesn't throw error if x equals FALSE
  #' @param x anything to check for
  # '!' doesn't work here because x can be anything
  #' @return input
  if (!is.null(x) && x == FALSE)
    x
  else
    req(x)
}


update_hyperparameters = function(learner, i){
  #' @description Function updating hyperparameters reactively of a learner given index i
  #' @param i Index of the learner to update
  #' @return mlr learner object

  tasktype    = req(input$tasktype)
  valid_types = c("integer", "numeric", "discrete", "logical")
  is_valid    = sapply(learner$par.set$pars, function(par) par$has.default & par$tunable & par$type %in% valid_types)
  names       = names(learner$par.set$pars)[is_valid]
  par.vals    = lapply(names,    function(par) modified_req(input[[paste0("parameter_", par, i, tasktype)]]))
  par.vals    = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
  names(par.vals) = names

  setHyperPars(learner, par.vals = par.vals)
}


values = reactiveValues( learner_choices = NULL, measure_choices = NULL) #data = NULL, task = NULL,data = NULL, process_1 = NULL, process_2 = NULL,

output$measure_1 = renderUI({
  # wait until everything in "process" is loaded - "measures" is not reactive,
  # thus not usable as trigger
  req(process$data$train.set)
  selectInput("measure_1", "", choices = process$measures)
})


observe({
  # this creates a new R6 class whenever the tasktype is loaded/changed
  tasktype = req(input$tasktype)
  # assign on global scope
  if (tasktype == "classif") {
#    values$measure_choices = c(
#      "acc", "tnr", "tpr", "f1", "mmce", "brier.scaled", "bac", "fn", "fp", "fnr", "qsr", "fpr", "npv",
#      "brier", "auc", "multiclass.aunp", "multiclass.aunu","ber", "multiclass.brier", "ssr",
#      "ppv", "wkappa", "tn", "tp", "multiclass.au1u", "gmean"
#    )
    process <<- ClassifLearningProcess$new()
  } else if (tasktype == "regr") {
    process <<- RegrLearningProcess$new()
#    values$measure_choices = c(
#      "mae", "mape", "medse", "msle", "rae", "spearmanrho", "rmsle", "medae", "sse", "expvar",
#      "kendalltau", "rmse", "mse", "rrse", "rsq", "sae", "arsq"
#    )

  } else if (tasktype == "cluster") {
    process <<- ClusterLearningProcess$new()
#    values$measure_choices = c(
#      "db", "dunn", "G1", "G2"
#    )
  }

  # list of all remaining measures
  #c(
  #  "iauc.uno", "featperc", "multilabel.tpr",
  #  "ibrier", "multilabel.hamloss", "mcc",
  #  "mcp", "lsr",
  #  "multilabel.subset01", "meancosts", "timeboth", "timetrain",
  #  "timepredict", "multilabel.ppv", "logloss",
  #  "cindex.uno", "multilabel.f1",
  #  "multiclass.au1p", "multilabel.acc", "silhouette", "fdr",
  #  "kappa", "cindex", "gpr"
  #)

})


# observer modifying reactively values$data based on relevant inputs
source("server/observe_for_data.R", local = TRUE)


# create learner 1 based on selected learner
observe({
  req(input$tasktype)
  learner = req(input$learner_1)
  process$initLearner(learner, 1)
  #create_learner(1)
})

# update learner 1 based on selected parameters
observe({
  learner = req(process$learners[["1"]])

  process$learners[["1"]] = update_hyperparameters(learner, 1)
})

# create learner 2 based on selected learner
observe({
  req(input$tasktype)
  learner = req(input$learner_2)
  process$initLearner(learner, 2)
})

# update learner 2 based on selected parameters
observe({
  learner = req(process$learners[["2"]])

  process$learners[["2"]] = update_hyperparameters(learner, 2)
})
