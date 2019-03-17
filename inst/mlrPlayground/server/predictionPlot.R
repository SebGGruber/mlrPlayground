output$predictionPlot_1 = renderPlotly({
  # if learner 1 is loaded, calculate prediction plot
  req(process$learners[["1"]])
  process$getPredPlot(1)
})


output$predictionPlot_2 = renderPlotly({
  # if learner 2 is loaded, calculate prediction plot
  req(process$learners[["2"]])
  process$getPredPlot(2)
})
