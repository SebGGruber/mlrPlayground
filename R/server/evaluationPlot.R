output$evaluationPlot = renderPlotly({

  #input$startTraining
  req(input$learner1)
  req(input$task)

  set.seed(123)

  if (isolate(input$task) == "Circle") {

    angle = runif(400, 0, 360)
    radius_class1 = rexp(200, 1)
    radius_class2 = rnorm(200, 16, 3)

    data = data.frame(
      x1 = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
      x2 = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
      class = c(rep("Class 1", 200), rep("Class 2", 200))
    )

  } else if (isolate(input$task) == "XOR") {

    x1 = runif(400, -5, 5)
    x2 = runif(400, -5, 5)
    xor = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
    class = ifelse(xor, "Class 1", "Class 2")

    data = data.frame(x1, x2, class)

  }

  task_mlr    = makeClassifTask(data = data, target = "class")
  learner_mlr = makeLearner(listLearners()$class[listLearners()$name == input$learner1])
  # get hyperparameter from input
  par.vals = {
    has_default = sapply(learner_mlr$par.set$pars, function(par) par$has.default)
    names = names(learner_mlr$par.set$pars)[has_default]
    values = lapply(names, function(par) input[[paste0("parameter_", par, 1)]])
    values = lapply(values, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
    names(values) = names

    values
  }
  #browser()
  learner_mlr = setHyperPars(learner_mlr, par.vals = par.vals)
  model       = train(learner_mlr, task_mlr)


  pred = expand.grid(x1 = -50:50/10, x2 = -50:50/10)

  predictions = predictLearner(learner_mlr, model, pred)

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
    )
})


output$evaluationPlot2 = renderPlotly({

  #input$startTraining
  req(input$learner2)
  req(input$task)

  set.seed(123)

  if (isolate(input$task) == "Circle") {

    angle = runif(400, 0, 360)
    radius_class1 = rexp(200, 1)
    radius_class2 = rnorm(200, 16, 3)

    data = data.frame(
      x1 = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
      x2 = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
      class = c(rep("Class 1", 200), rep("Class 2", 200))
    )

  } else if (isolate(input$task) == "XOR") {

    x1 = runif(400, -5, 5)
    x2 = runif(400, -5, 5)
    xor = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
    class = ifelse(xor, "Class 1", "Class 2")

    data = data.frame(x1, x2, class)

  }

  task_mlr    = mlr::makeClassifTask(data = data, target = "class")
  learner_mlr = mlr::makeLearner(mlr::listLearners()$class[mlr::listLearners()$name == input$learner2])
  # get hyperparameter from input
  par.vals = {
    has_default = sapply(learner_mlr$par.set$pars, function(par) par$has.default)
    names = names(learner_mlr$par.set$pars)[has_default]
    values = lapply(names, function(par) input[[paste0("parameter_", par, 2)]])
    values = lapply(values, function(val) if (is.character(val) & !is.na(as.integer(val))) as.integer(val) else val)
    names(values) = names
    values
  }
  learner_mlr = setHyperPars(learner_mlr, par.vals = par.vals)
  model       = mlr::train(learner_mlr, task_mlr)


  pred = expand.grid(x1 = -50:50/10, x2 = -50:50/10)

  predictions = predictLearner(learner_mlr, model, pred)

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
    )
})
