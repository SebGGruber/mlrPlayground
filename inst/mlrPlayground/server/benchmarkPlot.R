
output$benchmarkPlot = renderPlot({

  task     = req(process$task$train)
  split    = req(input$test_ration)
  measures = unlist(req(input$measure_multi_bm))

  learner_1 = setPredictType(req(process$learners[["1"]]), "prob")

  learners = list(learner_1)

  if (!is.null(process$learners[["2"]]))
    learners[[2]] = setPredictType(req(process$learners[["2"]]), "prob")

  rdesc = makeResampleDesc("Holdout", split = split)
  bmr = benchmark(learners, task, rdesc, measures = measures)
  plotBMRBoxplots(bmr, ber)
})
