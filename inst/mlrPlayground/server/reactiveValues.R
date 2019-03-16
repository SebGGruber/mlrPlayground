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

#create_learner = function(i) {
  #
#  name    = paste0("learner_", i)
#  learner = req(input[[name]])
#  tryCatch({
#    values[[name]] = makeLearner(
#      listLearners()$class[listLearners()$short.name == learner & listLearners()$type == input$tasktype]
#    )#},
    #error = function(e) {
    #  content = paste(
    #    "Please install package(s):",
    #    paste(listLearners()$package[listLearners()$name == learner & listLearners()$type == input$tasktype], collapse = ", ")
    #  )
    #  createAlert(
    #    session, "learner_error", title = "Can't create learner!", content = content, append = FALSE
    #  )
    #}
  #)
#}


#makeTask = function(data, tasktype) {

#  if (tasktype == "classif")
#    makeClassifTask(data = data, target = "class")
#  else if (tasktype == "regr")
#    makeRegrTask(data = data, target = "y")
#  else if (tasktype == "cluster")
#    makeClusterTask(data = data)
#}


update_hyperparameters = function(learner, i){
  #' @description Function updating hyperparameters reactively of a learner given index i
  #' @param i Index of the learner to update
  #' @return mlr learner object

  valid_types = c("integer", "numeric", "discrete", "logical")
  is_valid    = sapply(learner$par.set$pars, function(par) par$has.default & par$tunable & par$type %in% valid_types)
  names       = names(learner$par.set$pars)[is_valid]
  par.vals    = lapply(names,    function(par) modified_req(input[[paste0("parameter_", par, i)]]))
  par.vals    = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
  names(par.vals) = names

  setHyperPars(learner, par.vals = par.vals)
}


observe({
  # this creates a new R6 class whenever the tasktype is loaded/changed
  tasktype = req(input$tasktype)
  # assign on global scope
  if (tasktype == "classif")
    process <<- ClassifLearningProcess$new()

})

values = reactiveValues( learner_choices = NULL) #data = NULL, task = NULL,data = NULL, process_1 = NULL, process_2 = NULL,

# observer modifying reactively values$data based on relevant inputs
source("server/observe_for_data.R", local = TRUE)


# create task based on selected data
#observe({
#  data      = req(process$data$train.set)
#  tasktype  = req(input$tasktype)
#  isolate(process_1$initTask(data))
#})


# create learner 1 based on selected learner
observe({
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
  learner = req(input$learner_2)
  process$initLearner(learner, 2)
})

# update learner 2 based on selected parameters
observe({
  learner = req(process$learners[["2"]])

  process$learners[["2"]] = update_hyperparameters(learner, 2)
})
