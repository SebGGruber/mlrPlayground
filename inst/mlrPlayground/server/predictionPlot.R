observe({
  # if learner 1 is loaded, calculate predictions
  req(process$learners[["1"]])
  isolate(process$calculatePred(1))
})


observe({
  # if learner 2 is loaded, calculate predictions
  req(process$learners[["2"]])
  isolate(process$calculatePred(2))
})


output$measure_1_value = renderText({
  # once predictions are loaded, calculate performance measure based on chosen measure
  pred    = req(process$pred[["1"]]$test.set)
  measure = req(input$measure_sel)
  performance(pred, measures = get(measure)) # use "get" cause string gives error
})


output$measure_2_value = renderText({
  # once predictions are loaded, calculate performance measure based on chosen measure
  pred = req(process$pred[["2"]]$test.set)
  measure = req(input$measure_sel)
  performance(pred, measures = get(measure)) # use "get" cause string gives error
})


output$predictionPlot_1 = renderPlotly({
  # once predictions are loaded, get the predictions plot
  req(process$pred[["1"]])
  process$getPredPlot(1)
})


output$predictionPlot_2 = renderPlotly({
  # once predictions are loaded, get the prediction plot
  req(process$pred[["2"]])
  process$getPredPlot(2)
})
