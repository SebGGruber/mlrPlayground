output$benchmarkPlot = renderPlot({

  task     = req(values$task)
  learners = list(req(values$learner_1))

  if (!is.null(values$learner_2))
    learners[[2]] = values$learner_2

  rdesc = makeResampleDesc("CV", iters = 2L)
  meas = list(acc, ber)
  bmr = benchmark(learners, task, rdesc, measures = meas)
  plotBMRBoxplots(bmr, ber)
})
