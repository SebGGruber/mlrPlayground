
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


# render UI for the measure selection
output$measure_multi_lc = renderUI({
  # measures need to be initialized
  req(process$task$measures)
  # only render when learner_1 is not NULL
  req(input$learner_1)
  # optional dependency: Only renders once plots
  # also render
  req(process$learners[["1"]])
  selectInput("measure_multi_lc", "", multiple = TRUE, choices = process$task$measures)
})


# render UI for the measure selection
output$measure_1_roc = renderUI({
  # measures need to be initialized
  req(process$task$measures)
  # only render when learner_1 is not NULL
  req(input$learner_1)
  # optional dependency: Only renders once plots
  # also render
  req(process$learners[["1"]])
  selectInput("measure_1_roc", "", choices = process$task$measures, selected = "fpr")
})


# render UI for the measure selection
output$measure_2_roc = renderUI({
  # measures need to be initialized
  req(process$task$measures)
  # only render when learner_1 is not NULL
  req(input$learner_1)
  # optional dependency: Only renders once plots
  # also render
  req(process$learners[["1"]])
  selectInput("measure_2_roc", "", choices = process$task$measures, selected = "tpr")
})


# create learner 1 based on selected learner
observe({
  learner = req(input$learner_1)
  prob    = modified_req(input$prob)
  process$initLearner(learner, 1, prob)
})


# update learner 1 based on selected parameters
observe({

  names    = req(process$params[["1"]])
  # check for and get input values if parameters exist
  par.vals = lapply(names, function(par) {
    id = paste0("parameter_", par, 1, isolate(process$task$type))
    modified_req(input[[id]])
  })
  process$updateHyperparam(par.vals, 1)
})


# create learner 2 based on selected learner
observe({
  learner = req(input$learner_2)
  prob    = modified_req(input$prob)
  process$initLearner(learner, 2, prob)
})


# update learner 2 based on selected parameters
observe({

  names    = req(process$params[["2"]])
  # check for and get input values if parameters exist
  par.vals = lapply(names, function(par) {
    id = paste0("parameter_", par, 2, isolate(process$task$type))
    modified_req(input[[id]])
  })

  process$updateHyperparam(par.vals, 2)

})

# this is required to reference the tasktype in the UI
# and thus hide the ROC stuff based on the tasktype
output$tasktype = reactive({
  req(input$tasktype)
})

# force loading even when hidden
outputOptions(output, "tasktype",   suspendWhenHidden = FALSE)
