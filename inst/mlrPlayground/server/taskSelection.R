output$taskSelection = renderUI({

  req(input$tasktype)
  #print(input$tasktype)

  if (input$tasktype == "" || input$tasktype == "classif") {
    choices = list(#"Circle", "XOR",
    #Classification
      "1.Circle",
      "2.Two Circle",
      "3.Two Circle + Point",
      "4.XOR",
      "5.Gaussian",
      "6.Across Spiral",
      "7.Opposite Arc",
      "8.Cross Sector"
    )

  } else if (input$tasktype == "classif3d") {
    choices = list(
      "1.Wavy surface",
      "2.Sphere"
    )

  } else if (input$tasktype == "regr") {
    choices = list(#"Linear ascend (2D)",
    #Regression
      "1.Linear ascend",
      "2.Log linear",
      "3.Polyline",
      "4.Ascend Cosine",
      "5.Tangent",
      "6.Sigmoid",
      "7.Three Line",
      "8.Amplification Sine",
      "9.Parabola To Right",
      "10.Precipice"
    )

  } else if (input$tasktype == "regr3d") {
    choices = list(
      "1.Spiral ascend"
    )

  } else if (input$tasktype == "cluster") {
    choices = list(
    #Cluster
      "1.Normal Points + Uniform Square",
      "2.Two Spiral",
      "3.Points + Sine",
      "4.Three Circle",
      "5.Three Slant",
      "6.Parabola + Two Points"
    )

  }

  radioButtons("task", label = "Select task", choices = choices)
})

# force loading even when hidden
outputOptions(output, "taskSelection",   suspendWhenHidden = FALSE)
