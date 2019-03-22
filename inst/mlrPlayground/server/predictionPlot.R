observe({
  # whenever learner 1 or test set is updated, calculate predictions
  req(process$data$test.set)
  learner = req(process$updated_learners[["1"]])
  process$calculatePred(1)
  print("Preds 1 successfully calculated")
})


observe({
  # whenever learner 2 or test set is updated, calculate predictions
  req(process$data$test.set)
  learner = req(process$updated_learners[["2"]])
  process$calculatePred(2)
  print("Preds 2 successfully calculated")
})


output$predictionPlot_1 = renderPlotly({
  # once predictions are loaded, get the predictions plot
  req(process$pred[["1"]]$grid)
  print("Calculating pred plot 1...")
  process$getPredPlot(1)
})


output$predictionPlot_2 = renderPlotly({
  # once predictions are loaded, get the prediction plot
  req(process$pred[["2"]]$grid)
  print("Calculating pred plot 2...")
  process$getPredPlot(2)
})


# render UI for the measure selection
output$measure_1_sel = renderUI({
  # measures need to be initialized
  req(process$task$measures)
  # only render when learner_1 is not NULL
  req(input$learner_1)
  # optional dependency: Only renders once prediction plots
  # also render
  req(process$learners[["1"]])
  selectInput("measure_sel", "", choices = process$task$measures)
})

# render helptext
output$measure_2_sel = renderText({
  req(process$task$measures)
  input$measure_sel
})

output$measure_1_value = renderText({
  # once predictions are loaded, calculate performance measure based on chosen measure
  pred    = req(process$pred[["1"]]$test.set)
  measure = req(input$measure_sel)
  performance(pred, measures = get(measure)) # use "get" cause string gives error
})


output$measure_2_value = renderText({
  # once predictions are loaded, calculate performance measure based on chosen measure
  pred = req(process$pred[["2"]]$test.set)
  measure = req(input$measure_sel)
  performance(pred, measures = get(measure)) # use "get" cause string gives error
})


output$prob_sel = renderUI({
  req(input$learner_1)
  req(req(input$tasktype) == "classif")
  # don't change value once learner changes
  value = if (is.null(isolate(input$prob))) FALSE else isolate(input$prob)

  checkboxInput("prob", "Use probabilities", value = value)
})
