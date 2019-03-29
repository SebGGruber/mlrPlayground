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


output$table_measures_1 = renderUI({
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
  
  len = length(perf)
  i1 = 1                  : ceiling(len/3)
  i2 = ceiling(len/3+1)   : ceiling(len*2/3)
  i3 = ceiling(len*2/3+1) : len

  splitLayout(
    renderTable({
      data.frame(Measure = names(perf)[i1], Value = perf[i1])
    }),
    renderTable({
      data.frame(Measure = names(perf)[i2], Value = perf[i2])
    }),
    renderTable({
      data.frame(Measure = names(perf)[i3], Value = perf[i3])
    })
  )

})


output$table_measures_2 = renderUI({
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
  len = length(perf)
  i1 = 1                  : ceiling(len/3)
  i2 = ceiling(len/3+1)   : ceiling(len*2/3)
  i3 = ceiling(len*2/3+1) : len

  splitLayout(
    renderTable({
      data.frame(Measure = names(perf)[i1], Value = perf[i1])
    }),
    renderTable({
      data.frame(Measure = names(perf)[i2], Value = perf[i2])
    }),
    renderTable({
      data.frame(Measure = names(perf)[i3], Value = perf[i3])
    })
  )

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
