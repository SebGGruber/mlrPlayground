output$datasetPlot = renderPlotly({

  data = req(values$data)
  #req(input$task)
  # we only want execution when the data changed
  tasktype = isolate(input$tasktype)

  if (tasktype == "classif") {
    plotly::plot_ly(
      data   = data,
      x      = ~x1,
      y      = ~x2,
      color  = ~class,
      colors = c("#2b8cbe", "#e34a33"),
      type   = "scatter",
      mode   = "markers"
    )

  } else if (tasktype == "regr") {
    plotly::plot_ly(
      data = data,
      x    = ~x,
      y    = ~y,
      type = "scatter",
      mode = "markers"
    )

  } else {
    plotly::plotly_empty()
  }

})

# small info text in the UI
output$taskinfo = renderText(paste("Currently selected:", input$tasktype, "-", input$task))

# force loading even when hidden
outputOptions(output, "datasetPlot",     suspendWhenHidden = FALSE)
