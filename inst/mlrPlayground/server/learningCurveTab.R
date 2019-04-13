# render UI for the measure selection
output$measure_multi_lc = renderUI({
  # measures need to be initialized
  choices = req(process$task$measures)
  # only render when learner_1 is not NULL
  req(input$learner_1)
  # optional dependency: Only renders once plots
  # also render
  req(process$learners[["1"]])
  selectInput("measure_multi_lc", "", multiple = TRUE, choices = choices)
})

# learning curve plot output object
output$learningCurve = renderPlot({

  # required reactive inputs
  task     = req(process$task$object)
  split    = req(input$test_ration)
  measures = lapply(req(input$measure_multi_lc), get)

  learners = list(req(process$updated_learners[["1"]]))

  # if learner 2 exists, add it to the list of learners to
  # calculate
  if (!is.null(process$learners[["2"]]))
    learners[[2]] = req(process$updated_learners[["2"]])

  # make resampling description
  resampling = makeResampleDesc(method = "Holdout", split = split)

  # generate plot data
  lc = generateLearningCurveData(
    learners = learners,
    task = task,
    percs = seq(0.1, 1, by = 0.1),
    measures = measures,
    resampling = resampling
  )
  plotLearningCurve(lc) + theme_minimal()

})
