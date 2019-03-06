output$taskSelection = renderUI({

  #req(input$tasktype)
  #print(input$tasktype)

  if (input$tasktype == "" || input$tasktype == "classif") {
    choices = list("Circle", "XOR"
    #Classification
      "1.Circle", 
      "2.Two-Circle",
      "3.Two-Circle-2",
      "4.XOR",
      "5.Gaussian",
      "6.Across Spiral",
      "7.Opposite Arc",
      "8.Cross Sector"
    )

  } else if (input$tasktype == "classif_3d") {
    choices = list(
    #Classification 3D
      "9.Wavy surface (3D)",
      "10.Sphere (3D)"
    )

  }else if (input$tasktype == "regr") {
    choices = list("Linear ascend (2D)",
    #Regression
      "1.Linear ascend",
      "2.Log linear",
      "3.Sine",
      "4.Ascend Cosine",
      "5.Tangent",
      "6.Sigmoid",
      "7.Circle",
      "8.Spiral",
      "9.Parabola To Right"
    )

  } else if (input$tasktype == "regr_3d") {
    choices = list(
    #Regression 3D
      "10.Spiral ascend (3D)"
    )

  } else if (input$tasktype == "cluster") {
    choices = list(
    #Cluster
      "1.Clustering Dataset 1",
      "2.Clustering Dataset 2",
      "3.Clustering Dataset 3",
      "4.Clustering Dataset 4",
      "5.Clustering Dataset 5",
      "6.Clustering Dataset 6"
    )

  } else if (input$tasktype == "multilabel") {
    choices = list(
    #Multilabel
      "1.Spiral ascend (3D)",
      "2.Wavy surface (3D)",
      "3.Sphere (3D)"
    )

  } else if (input$tasktype == "surv") {
    choices = list(
    #Survival
      "1.Exponential Decrement",
      "2.Mountain Peak",
      "3.Wave"
    )

  }

  radioButtons("task", label = "Select task", choices = choices)
})

# force loading even when hidden
outputOptions(output, "taskSelection",   suspendWhenHidden = FALSE)
