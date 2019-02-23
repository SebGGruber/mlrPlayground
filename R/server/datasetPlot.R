output$datasetPlot = renderPlotly({

  req(input$task)
  set.seed(123)

  if (input$task == "Circle") {

    angle = runif(400, 0, 360)
    radius_class1 = rexp(200, 1)
    radius_class2 = rnorm(200, 16, 3)

    data = data.frame(
      x1 = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
      x2 = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
      class = c(rep("Class 1", 200), rep("Class 2", 200))
    )

  } else if (input$task == "XOR") {

    x1 = runif(400, -5, 5)
    x2 = runif(400, -5, 5)
    xor = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
    class = ifelse(xor, "Class 1", "Class 2")

    data = data.frame(x1, x2, class)

  } else if (input$task == "Linear ascend (2D)") {

    x = rnorm(200, 0, 5)
    y = 0.5 * x + rnorm(200, 0, 1)

    data = data.frame(x, y)

  }

  if (input$tasktype == "classif") {
    plotly::plot_ly(
      data   = data,
      x      = ~x1,
      y      = ~x2,
      color  = ~class,
      colors = c("#2b8cbe", "#e34a33"),
      type   = "scatter",
      mode   = "markers"
    )

  } else if (input$tasktype == "regr") {
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
