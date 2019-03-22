output$ROCPlot = renderPlot({

  task      = req(process$task$train)#
  split     = req(input$test_ration)
  measure_1 = req(input$measure_1_roc)
  measure_2 = req(input$measure_2_roc)
  measures  = list(get(measure_1), get(measure_2))#list(fpr, tpr)

  learner_1 = setPredictType(req(process$learners[["1"]]), "prob")

#browser()
  learners = list(learner_1)

  if (!is.null(process$learners[["2"]]))
    learners[[2]] = setPredictType(req(process$learners[["2"]]), "prob")

  rdesc = makeResampleDesc(method = "Holdout", split = split)
  bmr = benchmark(learners, task, rdesc, measures = measures)
  roc_r = generateThreshVsPerfData(bmr, measures, aggregate = FALSE)
  plotROCCurves(roc_r)
})
