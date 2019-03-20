# required further down
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
  # wait until learner is loaded, but don't react to it
  isolate(req(process$learners[["1"]]))
  names = process$getValidHyperparam(1)
  par.vals = lapply(names, function(par) modified_req(input[[paste0("parameter_", par, 1, process$task$type)]]))
  process$updateHyperparam(par.vals, 1)
})

# create learner 2 based on selected learner
observe({
  learner = req(input$learner_2)
  process$initLearner(learner, 2)
})

# update learner 2 based on selected parameters
observe({
  # wait until learner is loaded, but don't react to it
  isolate(req(process$learners[["2"]]))
  names = process$getValidHyperparam(2)
  par.vals = lapply(names, function(par) modified_req(input[[paste0("parameter_", par, 2, process$task$type)]]))
  process$updateHyperparam(par.vals, 2)
})
