observe({
  # if learner 1 is loaded, calculate predictions
  req(process$learners[["1"]])
  process$calculatePred(1)
})

output$measure_1 = renderText({
  # once predictions are loaded, calculate performance measure based on chosen measure
  pred = req(process$pred[["1"]]$test.set)
  measure = req(input$measure_1)
  performance(pred, measures = measure)
})


output$predictionPlot_1 = renderPlotly({
  # once predictions are loaded, get the predictions plot
  req(process$pred[["1"]])
  process$getPredPlot(1)
})


output$predictionPlot_2 = renderPlotly({
  # if learner 2 is loaded, calculate prediction plot
#  req(process$learners[["2"]])
#  process$getPredPlot(2)
})
