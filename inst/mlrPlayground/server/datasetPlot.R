output$datasetPlot = renderPlotly({

  data = req(values$data)
  #req(input$task)
  # we only want execution when the data changed
  tasktype = isolate(input$tasktype)

  if (tasktype == "classif" && ncol(data) == 3) {
    plotly::plot_ly(
      data   = data,
      x      = ~x1,
      y      = ~x2,
      color  = ~class,
      colors = c("#2b8cbe", "#e34a33"),
      type   = "scatter",
      mode   = "markers"
    )

  } else if (tasktype == "classif" && ncol(data) == 4) {
      plotly::plot_ly(
        data = values$data,
        type = "scatter3d",
        x    = ~x,
        y    = ~y,
        z    = ~z,
        color = ~class,
        colors = c("#2b8cbe", "#e34a33")
      )%>%
      add_markers()%>%
      layout(scene = list(
        xaxis = list(title = 'xaxis'),
        yaxis = list(title = 'yaxis'),
        zaxis = list(title = 'zaxis'))
      )
  
  } else if (tasktype == "regr" && ncol(data) == 3) {
    plotly::plot_ly(
      data = values$data,
      x    = ~x,
      y    = ~y,
      type = "scatter",
      mode = "markers"
    )

  } else if (tasktype == "regr" && ncol(data) == 4) {
      plotly::plot_ly(
        data = values$data,
        type = "scatter3d",
        x    = ~x,
        y    = ~y,
        z    = ~z
      )%>%
      add_markers()%>%
      layout(scene = list(
        xaxis = list(title = 'xaxis'),
        yaxis = list(title = 'yaxis'),
        zaxis = list(title = 'zaxis'))
      )

  }else if (input$tasktype == "cluster") {
      plotly::plot_ly(
        data   = values$data,
        x      = ~x,
        y      = ~y,
        marker = list(
          size  = 10,
          color = 'rgba(255, 182, 193, .9)',
          line  = list(
            color = 'rgba(152, 0, 0, .8)',
            width = 1
          )
        ),
        type   = "scatter",
        mode   = "markers"
      )

  }else if(input$tasktype == "multilabel"){
    plotly::plot_ly(
      data   = values$data,
      type   = "scatter3d",
      x      = ~x,
      y      = ~y,
      z      = ~z,
      marker = list(
          color      = ~z, 
          colorscale = c('#FFE1A1', '#683531'), 
          showscale  = TRUE)
    )%>%
    add_markers()%>%
    layout(scene = list(
      xaxis = list(title = 'xaxis'),
      yaxis = list(title = 'yaxis'),
      zaxis = list(title = 'zaxis')))
    }
    else if (input$tasktype == "surv") {
      plot_ly(
        data = values$data, 
        x    = ~x, 
        y    = ~y1, 
        line = list(
          color = "blue", 
          shape = "hv"
        ), 
        mode = "lines", 
        type = "scatter"
      ) %>%   
      add_trace(
        y    = ~y2,
        name = 'trace 2',
        line = list(
          color = "red"
        ),
        mode ='lines'
      )        
  } else {
    plotly::plotly_empty()
  }

})

# small info text in the UI
output$taskinfo = renderText(paste("Currently selected:", input$tasktype, "-", input$task))

# force loading even when hidden
outputOptions(output, "datasetPlot",     suspendWhenHidden = FALSE)
