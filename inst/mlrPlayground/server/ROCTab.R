# this is required to reference the tasktype in the UI
# and thus hide the ROC stuff based on the tasktype
output$tasktype = reactive({
  req(input$tasktype)
})


# render UI for the measure selection
output$measure_1_roc = renderUI({
  # measures need to be initialized
  choices = req(process$task$measures)
  # only keep binary measures
  choices = choices[
    sapply(choices, function(x) !("classif.multi" %in% getMeasureProperties(get(x))))
  ]
  # only render when learner_1 is not NULL
  req(input$learner_1)
  # optional dependency: Only renders once plots
  # also render
  req(process$learners[["1"]])
  selectInput("measure_1_roc", "", choices = choices, selected = "fpr")
})


# render UI for the measure selection
output$measure_2_roc = renderUI({
  # measures need to be initialized
  choices = req(process$task$measures)
  # only keep binary measures
  choices = choices[
    sapply(choices, function(x) !("classif.multi" %in% getMeasureProperties(get(x))))
  ]
  # only render when learner_1 is not NULL
  req(input$learner_1)
  # optional dependency: Only renders once plots
  # also render
  req(process$learners[["1"]])
  selectInput("measure_2_roc", "", choices = choices, selected = "tpr")
})


# roc plot output
output$ROCPlot = renderPlot({

  # required reactive inputs
  task      = req(process$task$object)
  split     = req(input$test_ration)
  measure_1 = req(input$measure_1_roc)
  measure_2 = req(input$measure_2_roc)
  measures  = list(get(measure_1), get(measure_2))#list(fpr, tpr)

  # this is mandatory for ROC plots
  learner_1 = setPredictType(req(process$updated_learners[["1"]]), "prob")

  learners = list(learner_1)

  # this is also mandatory if learner 2 exists
  if (!is.null(process$learners[["2"]]))
    learners[[2]] = setPredictType(req(process$updated_learners[["2"]]), "prob")

  # make resampling description
  rdesc = makeResampleDesc(method = "Holdout", split = split)
  # generate benchmark data
  bmr = benchmark(learners, task, rdesc, measures = measures)
  # generate roc curve data
  roc_r = generateThreshVsPerfData(bmr, measures, aggregate = FALSE)
  # plot data
  plotROCCurves(roc_r) + theme_minimal()
})
