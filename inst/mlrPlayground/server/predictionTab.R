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
output$measure_2_sel = renderUI({
  req(process$task$measures)
  helpText(input$measure_sel)
})

output$measure_1_value = renderUI({
  # once predictions are loaded, calculate performance measure based on chosen measure
  pred    = req(process$pred[["1"]]$test.set)
  measure = req(input$measure_sel)
  task = req(process$task$train)
  if (isolate(process$task$type) == "cluster"){
    pred[["data"]][["response"]][is.na(pred[["data"]][["response"]])] = 3
    mod = train("cluster.dbscan",task)
    pred = predict(mod, task)
    perf = performance(pred, measures = get(measure),task = task)
  }
  else{
    perf = performance(pred, measures = get(measure)) # use "get" cause string gives error
  }
  helpText(sprintf("%1.3f", perf), style = "font: 16px arial, sans-serif !important; margin-top: 11px;")
})


output$measure_2_value = renderUI({
  # once predictions are loaded, calculate performance measure based on chosen measure
  pred = req(process$pred[["2"]]$test.set)
  measure = req(input$measure_sel)
  task = req(process$task$train)
  if (isolate(process$task$type) == "cluster"){
    pred[["data"]][["response"]][is.na(pred[["data"]][["response"]])] = 3
    mod = train("cluster.dbscan",task)
    pred = predict(mod, task)
    perf = performance(pred, measures = get(measure),task = task)
  }
  else{
    perf = performance(pred, measures = get(measure)) # use "get" cause string gives error
  }
  helpText(sprintf("%1.3f", perf), style = "font: 16px arial, sans-serif !important; margin-top: 11px;")
})


output$prob_sel = renderUI({
  req(input$learner_1)
  req(req(input$tasktype) == "classif")
  # don't change value once learner changes
  value = if (is.null(isolate(input$prob))) TRUE else isolate(input$prob)

  tags$p(
    column(4, custom_checkboxInput("prob", "Use probabilities", value = value)),
    br()
  )
})
