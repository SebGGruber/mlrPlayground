output$ROCPlot = renderPlot({

  task     = req(process$task$train)
  learner_1 = setPredictType(req(process$learners[["1"]]), "prob")


  learners = list(learner_1)

  if (!is.null(process$learners[["2"]]))
    learners[[2]] = setPredictType(req(process$learners[["2"]]), "prob")

  rdesc = makeResampleDesc("CV", iters = 2L)
  meas = list(acc, ber)
  bmr = benchmark(learners, task, rdesc, measures = meas)
  roc_r = generateThreshVsPerfData(bmr, list(fpr, tpr), aggregate = FALSE)
  plotROCCurves(roc_r)
})
