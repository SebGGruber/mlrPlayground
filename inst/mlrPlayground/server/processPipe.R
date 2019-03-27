# PROCESS INSTANCE CREATION - HERE IS WHERE THE FUN STARTS
observe({
  # this creates a new R6 class instance whenever the tasktype is loaded/changed
  tasktype = req(input$tasktype)

  # remove this and everything is totally messed up :)
  # reset selections once tasktype changes
  updateSelectInput(session, "learner_1", selected = "")
  updateSelectInput(session, "learner_2", selected = "")
  updateSelectInput(session, "measure_sel", selected = "")

  # assign on global scope
  if (tasktype == "classif") {
    process <<- isolate(ClassifLearningProcess$new(config$valid.learners))

  } else if (tasktype == "regr") {
    process <<- isolate(RegrLearningProcess$new(config$valid.learners))

  } else if (tasktype == "cluster") {
    process <<- isolate(ClusterLearningProcess$new(config$valid.learners))

  } else if (tasktype == "classif3d") {
    process <<- isolate(Classif3dLearningProcess$new(config$valid.learners))

  } else if (tasktype == "regr3d") {
    process <<- isolate(Regr3dLearningProcess$new(config$valid.learners))
  }

})


observe({
  # check if "process" is already initialized as class instance (NOT REACTIVE)
  req(process$data)
  # Parameters for function call
  task        = req(input$task)
  amount      = req(input$datasize)
  train.ratio = req(input$test_ration)
  noise       = req(input$noise)

  data = calculate_data(task, amount, noise, train.ratio)

  process$setData(data, train.ratio)
})


# create learner 1 based on selected learner
observe({
  learner = req(input$learner_1)
  # only react to prob when classif
  if (isolate(process$task$type) == "classif")
    prob = modified_req(input$prob)
  else
    prob = NULL
  process$initLearner(learner, 1, prob)
})


# update learner 1 based on selected parameters
observe({

  names    = req(process$params[["1"]])
  lrn_id   = isolate(process$learners[["1"]]$id)
  # check for and get input values if parameters exist
  par.vals = lapply(names, function(par) {
    id = paste0("parameter_", par, 1, lrn_id)
    modified_req(input[[id]])
  })
  process$updateHyperparam(par.vals, 1)
})


# create learner 2 based on selected learner
observe({
  learner = req(input$learner_2)
  # only react to prob when classif
  if (isolate(process$task$type) == "classif")
    prob = modified_req(input$prob)
  else
    prob = NULL
  process$initLearner(learner, 2, prob)
})


# update learner 2 based on selected parameters
observe({

  names    = req(process$params[["2"]])
  lrn_id   = isolate(process$learners[["2"]]$id)
  # check for and get input values if parameters exist
  par.vals = lapply(names, function(par) {
    id = paste0("parameter_", par, 2, lrn_id)
    modified_req(input[[id]])
  })

  process$updateHyperparam(par.vals, 2)

})

observe({
  # whenever learner 1 or test set is updated, calculate predictions
  req(process$data$test.set)
  learner = req(process$updated_learners[["1"]])
  process$calculatePred(1)
  print("Preds 1 successfully calculated")
})


observe({
  # whenever learner 2 or test set is updated, calculate predictions
  req(process$data$test.set)
  learner = req(process$updated_learners[["2"]])
  process$calculatePred(2)
  print("Preds 2 successfully calculated")
})
