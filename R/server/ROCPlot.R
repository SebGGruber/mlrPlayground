output$ROCPlot = renderPlot({

  task     = req(values$task)
  learner_1 = setPredictType(req(values$learner_1), "prob")


  learners = list(learner_1)

  if (!is.null(values$learner_2))
    learners[[2]] = setPredictType(req(values$learner_2), "prob")

  rdesc = makeResampleDesc("CV", iters = 2L)
  meas = list(acc, ber)
  bmr = benchmark(learners, task, rdesc, measures = meas)
  roc_r = generateThreshVsPerfData(bmr, list(fpr, tpr), aggregate = FALSE)
  plotROCCurves(roc_r)
})
