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


# this function uses heavily input values and thus is defined here instead
# of in the R6 classes
update_hyperparameters = function(learner, i){
  #' @description Function updating hyperparameters reactively of a learner given index i
  #' @param i Index of the learner to update
  #' @return mlr learner object

  tasktype    = req(process$task$type)
  valid_types = c("integer", "numeric", "discrete", "logical")
  is_valid    = sapply(learner$par.set$pars, function(par) par$has.default & par$tunable & par$type %in% valid_types)
  names       = names(learner$par.set$pars)[is_valid]
  par.vals    = lapply(names,    function(par) modified_req(input[[paste0("parameter_", par, i, tasktype)]]))
  par.vals    = lapply(par.vals, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
  names(par.vals) = names

  setHyperPars(learner, par.vals = par.vals)
}


observe({
  # this creates a new R6 class instance whenever the tasktype is loaded/changed
  tasktype = req(input$tasktype)
  # assign on global scope
  if (tasktype == "classif") {
    process <<- ClassifLearningProcess$new(config$valid.learners)

  } else if (tasktype == "regr") {
    process <<- RegrLearningProcess$new(config$valid.learners)

  } else if (tasktype == "cluster") {
    process <<- ClusterLearningProcess$new(config$valid.learners)

  } else if (tasktype == "classif3d") {
    process <<- Classif3dLearningProcess$new(config$valid.learners)

  } else if (tasktype == "regr3d") {
    process <<- Regr3dLearningProcess$new(config$valid.learners)
  }

  # remove this and everything is totally messed up :)
  # reset selections once tasktype changes
  updateSelectInput(session, "learner_1", selected = "")
  updateSelectInput(session, "learner_2", selected = "")
  updateSelectInput(session, "measure_sel", selected = "")

})


# observer modifying reactively values$data based on relevant inputs
source("server/observe_for_data.R", local = TRUE)

# render UI for the measure selection
output$measure_1_sel = renderUI({
  # measures need to be initialized
  req(process$task$measures)
  # only render when learner_1 is not NULL
  req(input$learner_1)
  # optional dependency: Only renders once prediction plots
  # also render
  req(process$learners[["1"]])
  selectInput("measure_sel", "", choices = process$task$measures)
})

# render helptext
output$measure_2_sel = renderText({
  req(process$task$measures)
  input$measure_sel
})


# create learner 1 based on selected learner
observe({
  learner = req(input$learner_1)
  process$initLearner(learner, 1)
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
