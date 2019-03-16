# TODO testthat
#create_predictions = function(i) {
#  #' @description Function to generate the predictions based on learner and task
#  #' @param i Index of the learner to generate the predictions for
#  #' @return List of three elements describing the predictions in a grid-like style:
  #'     $x1: Values of first axis
  #'     $x2: Values of second axis
  #'     $pred_matrix: Matrix containing predictions

#  learner = paste0("learner_", i)
#  learner = req(values[[learner]])

#  task    = req(values$task)
#  model   = train(learner, task)


#  pred = expand.grid(x1 = -50:50 / 10, x2 = -50:50 / 10)

#  predictions = predictLearner(learner, model, pred)

  #pred = data.frame(x = unique(pred$x1), y = unique(pred$x2))
#  pred$pred_matrix = as.numeric(factor(predictions))

#  return(pred)
#}


#classif_plot = function(i) {
#  #' @description Function to generate the prediction plot
#  #' @param i Index of the learner to generate the plot for
#  #' @return Plotly plot object

#  data = req(values$data)
#  pred = create_predictions(i)
#
#  plotly::plot_ly(
#    x = ~unique(pred$x1),
#    y = ~unique(pred$x2),
#    z = ~matrix(pred$pred_matrix, nrow = sqrt(length(pred$pred_matrix)), byrow = TRUE),
#    type = "heatmap",
#    colors = colorRamp(c("red", "blue")),
#    opacity = 0.2,
#    showscale = FALSE
#  ) %>%
#  plotly::add_trace(
#    data = data,
#    x = ~x1,
#    y = ~x2,
#    color = ~class,
#    colors = c("#2b8cbe", "#e34a33", "#2b8cbe", "#e34a33"),
#    type = "scatter",
#    mode = "markers"
#  ) %>%
#  plotly::layout(xaxis = list(title = ""), yaxis = list(title = ""))
#}


#regr_plot = function(i) {
#  #' @description Function to generate the prediction plot
#  #' @param i Index of the learner to generate the plot for
#  #' @return Plotly plot object

#  data = req(values$data)
#  pred = create_predictions(i)

#  plotly::plot_ly(
#    x = ~unique(pred$x1),
#    y = ~unique(pred$x2),
#    z = ~matrix(pred$pred_matrix, nrow = sqrt(length(pred$pred_matrix)), byrow = TRUE),
#    type = "heatmap",
    #colors = ,
#    opacity = 0.2,
#    showscale = FALSE
#  ) %>%
#    plotly::add_trace(
#      data = data,
#      x = ~x,
#      y = ~y,
#      color = ~class,
#      colors = c("#2b8cbe", "#e34a33", "#2b8cbe", "#e34a33"),
#      type = "scatter",
#      mode = "markers"
#    ) %>%
#    plotly::layout(xaxis = list(title = ""), yaxis = list(title = ""))
#}


#cluster_plot = function(i) {
#  #' @description Function to generate the prediction plot
#  #' @param i Index of the learner to generate the plot for
#  #' @return Plotly plot object
#
#  data = req(values$data)
#  pred = create_predictions(i)
#
#  plotly::plot_ly(
#    x = ~unique(pred$x1),
#    y = ~unique(pred$x2),
#    z = ~matrix(pred$pred_matrix, nrow = sqrt(length(pred$pred_matrix)), byrow = TRUE),
#    type = "heatmap",
#    #colors = ,
#    opacity = 0.2,
#    showscale = FALSE
#  ) %>%
#    plotly::add_trace(
#      data = data,
#      x = ~x,
#      y = ~y,
      #      color = ~class,
      #      colors = c("#2b8cbe", "#e34a33", "#2b8cbe", "#e34a33"),
#      type = "scatter",
#      mode = "markers"
#    ) %>%
#    plotly::layout(xaxis = list(title = ""), yaxis = list(title = ""))
#}

# delete all above once class system works

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
