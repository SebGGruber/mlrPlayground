output$datasetPlot = renderPlotly({

  req(process$data$train.set)
  process$getDataPlot()

})

# small info text in the UI
output$taskinfo = renderText(paste("Currently selected:", input$tasktype, "-", input$task))

# force loading even when hidden
outputOptions(output, "datasetPlot",     suspendWhenHidden = FALSE)
