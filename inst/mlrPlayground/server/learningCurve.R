output$learningCurve = renderPlot({

  task     = req(values$task)
  learners = list(req(values$learner_1))

  if (!is.null(values$learner_2))
    learners[[2]] = values$learner_2

  rin = makeResampleDesc(method = "CV", iters = 2)
  lc = generateLearningCurveData(
    learners = learners,
    task = task,
    percs = seq(0.1, 1, by = 0.1),
    measures = acc,
    resampling = rin
  )
  plotLearningCurve(lc)

})
