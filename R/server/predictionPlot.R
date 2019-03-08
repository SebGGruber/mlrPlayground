output_plot = function(i) {
  #input$startTraining
  learner = paste0("learner_", i)
  learner = req(values[[learner]])
  #data    = req(values$data)

  task    = req(values$task)
  model   = train(learner, task)


  pred = expand.grid(x1 = -50:50 / 10, x2 = -50:50 / 10)

  predictions = predictLearner(learner, model, pred)

  #pred = data.frame(x = unique(pred$x1), y = unique(pred$x2))
  pred$pred_matrix = as.numeric(factor(predictions))
  plotly::plot_ly(
    data = data,
    x = ~x1,
    y = ~x2,
    color = ~class,
    colors = c("#2b8cbe", "#e34a33", "#2b8cbe", "#e34a33"),
    type = "scatter",
    mode = "markers"
  ) %>%
    plotly::add_heatmap(
      x = ~unique(pred$x1),
      y = ~unique(pred$x2),
      z = ~matrix(pred$pred_matrix, nrow = sqrt(length(predictions)), byrow = TRUE),
      type = "heatmap",
      colors = colorRamp(c("red", "blue")),
      opacity = 0.2,
      showscale = FALSE
    ) %>%
    plotly::layout(xaxis = list(title = ""), yaxis = list(title = ""))
}

output$evaluationPlot_1 = renderPlotly({
  output_plot(1)
})


output$evaluationPlot_2 = renderPlotly({
  output_plot(2)
})
