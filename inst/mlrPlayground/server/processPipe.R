# PROCESS INSTANCE CREATION - HERE IS WHERE THE FUN STARTS
observe({
  # this creates a new R6 class instance whenever the tasktype is loaded/changed
  tasktype = req(input$tasktype)

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

  print("Process successfully initialized")
})


observe({
  # check if "process" is already initialized as class instance (NOT REACTIVE)
  #req(process$task)
  # Parameters for function call
  task        = req(input$task)
  amount      = req(input$datasize)
  train.ratio = req(input$test_ration)
  noise       = req(input$noise)

  data = calculate_data(task, amount, noise, train.ratio)
  isolate(process$setData(data, train.ratio))

  print("Data/Task/ResamplingInstance successfully set")
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

  print("Learner 1 successfully initializied")
})


# update learner 1 based on selected parameters
observe({
  # get parameter names to check input
  names    = names(req(process$params[["1"]]))
  # nameception - looks dumb, but is required to keep names after lapply
  names(names) = names
  lrn_id   = isolate(process$learners[["1"]]$id)
  # check for and get input values if parameters exist
  par.vals = lapply(names, function(par) {
    # remove "." or tooltips wont work
    id = gsub("\\.", "", paste0("parameter_", par, 1, lrn_id))
    modified_req(input[[id]])
  })

  process$updateHyperparam(par.vals, 1)

  print("Learner 1 successfully updated")
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

  print("Learner 2 successfully initializied")
})


# update learner 2 based on selected parameters
observe({
  # get parameter names to check input
  names    = names(req(process$params[["2"]]))
  # nameception - looks dumb, but is required to keep names after lapply
  names(names) = names
  lrn_id   = isolate(process$learners[["2"]]$id)
  # check for and get input values if parameters exist
  par.vals = lapply(names, function(par) {
    # remove "." or tooltips wont work
    id = gsub("\\.", "", paste0("parameter_", par, 2, lrn_id))
    modified_req(input[[id]])
  })

  process$updateHyperparam(par.vals, 2)

  print("Learner 2 successfully updated")
})

observe({
  # whenever learner 1 or task is updated, calculate predictions
  req(process$task$object)
  learner = req(process$updated_learners[["1"]])
  process$calculateResample(1)

  print("Resampling 1 successfully calculated")
})


observe({
  # whenever learner 2 or task is updated, calculate predictions
  req(process$task$object)
  learner = req(process$updated_learners[["2"]])
  process$calculateResample(2)

  print("Resampling 2 successfully calculated")
})
