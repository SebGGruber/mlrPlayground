
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
  isolate(process$initLearner(learner, 1))
})

# update learner 1 based on selected parameters
observe({
  req(process$learners[["1"]])
  # remove this if statement once issue is solved
  if (input$tasktype != "cluster") {
    names    = process$getValidHyperparam(1)
    # check for and get input values
    par.vals = lapply(names, function(par) {
      id = paste0("parameter_", par, 1, process$task$type)
      modified_req(input[[id]])
    })
    process$updateHyperparam(par.vals, 1)
  }
})

# create learner 2 based on selected learner
observe({
  learner = req(input$learner_2)
  process$initLearner(learner, 2)
})

# update learner 2 based on selected parameters
observe({
  req(process$learners[["2"]])
  names    = process$getValidHyperparam(2)
  # check for and get input values
  par.vals = lapply(names, function(par) {
    id = paste0("parameter_", par, 2, process$task$type)
    modified_req(input[[id]])
  })
  process$updateHyperparam(par.vals, 2)
})
