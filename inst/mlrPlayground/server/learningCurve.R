output$learningCurve = renderPlot({

  task     = req(process$task$train)
  split    = req(input$test_ration)
  measures = lapply(req(input$measure_multi_lc), get)

  learners = list(req(process$learners[["1"]]))

  if (!is.null(process$learners[["2"]]))
    learners[[2]] = process$learners[["2"]]

  resampling = makeResampleDesc(method = "Holdout", split = split)

  lc = generateLearningCurveData(
    learners = learners,
    task = task,
    percs = seq(0.1, 1, by = 0.1),
    measures = measures,
    resampling = resampling
  )
  plotLearningCurve(lc)

})
