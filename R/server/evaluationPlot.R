output$evaluationPlot = renderPlotly({

  #input$startTraining
  learner = req(input$learner1)
  data = req(values$data)


  task_mlr    = makeClassifTask(data = data, target = "class")
  learner_mlr = makeLearner(listLearners()$class[listLearners()$name == learner])
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
  learner = req(input$learner2)
  data = req(values$data)


  task_mlr    = mlr::makeClassifTask(data = data, target = "class")
  learner_mlr = mlr::makeLearner(mlr::listLearners()$class[mlr::listLearners()$name == learner])
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
