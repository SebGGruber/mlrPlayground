output$taskSelection = renderUI({

  req(input$tasktype)

  if (input$tasktype == "" || input$tasktype == "classif") {
    choices = list(#"Circle", "XOR",
    #Classification
      "Circle",
      #"Two Circle",
      "Two Circle + Point",
      "XOR",
      "Gaussian",
      "Across Spiral",
      "Opposite Arc"#,
      #"Cross Sector"
    )

  } else if (input$tasktype == "classif3d") {
    choices = list(
      "Wavy surface",
      "Sphere"
    )

  } else if (input$tasktype == "regr") {
    choices = list(#"Linear ascend (2D)",
    #Regression
      "Linear ascend",
      "Log linear",
      #"Polyline",
      "Ascend Cosine",
      #"Tangent",
      #"Sigmoid",
      "Three Line",
      #"Amplification Sine",
      "Parabola To Right",
      "Precipice"
    )

  } else if (input$tasktype == "regr3d") {
    choices = list(
      "Spiral ascend"
    )

  } else if (input$tasktype == "cluster") {
    choices = list(
    #Cluster
      "Normal Points + Uniform Square",
      "Two Spiral",
      "Points + Sine",
      "Three Circle",
      "Three Slant",
      "Parabola + Two Points"
    )

  }

  custom_radioButtons("task", label = "Select task", choices = choices)
})


# plotly object in the UI showing the selected dataset
output$datasetPlot = renderPlotly({
  # check for process task and then call getPlot method
  req(process$task$object)
  process$getDataPlot()

})


# small info text in the UI
output$taskinfo = renderText(paste("Currently selected:", input$tasktype, "-", input$task))
