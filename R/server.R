require(mlr)
require(plotly)

server_files = list.files(path = "./servers", pattern="*.R")
server_files = paste0("servers/", server_files)

for (i in seq_along(server_files)) {
#  source(server_files[i], local = TRUE)
}

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output, session) {

  output$learnerSelection = renderUI({

    selectInput(
      "learner",
      label = "Select learner",
      choices = as.list(mlr::listLearners()$name[mlr::listLearners()$type == input$tasktype])
    )

  })

  output$taskselection = renderUI({

    #req(input$tasktype)
    #print(input$tasktype)

    #if (input$tasktype == "" || input$tasktype == "classif") {
      choices = list("Circle", "XOR","Gaussian","Spiral","Linear ascend (2D)","Spiral ascend (3D)")

    #} else if (input$tasktype == "regr") {
    #  choices = list("Linear ascend (2D)")

    #} else if (input$tasktype == "cluster") {
    #  choices = list()

    #} else if (input$tasktype == "multilabel") {
    #  choices = list()

    #} else if (input$tasktype == "surv") {
    #  choices = list()

    #}

    radioButtons("task", label = "Select task", choices = choices)
  })


  output$taskinfo = renderText(paste("Currently selected:", input$tasktype, "-", input$task))


  output$distPlot = renderPlot({

    x    = faithful[, 2]
    bins = seq(min(x), max(x), length.out = 11)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })


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
    ################################
  # add Gaussian data sets

    else if(input$task == "Gaussian"){
      x1 = c(rnorm(200,2,1),rnorm(200,-2,1))
      x2 = c(rnorm(200,2,1),rnorm(200,-2,1))
      class = c(rep("Class 1", 200), rep("Class 2", 200)) 
      data = data.frame(x1,x2,class)
    }


  #add Spiral data sets
  else if(input$task == "Spiral"){
    r = c(1:200) / 200 * 5
    t = 1.75 * c(1:200)  / 200 * 2 * pi
    x1 = c(r * sin(t), r * sin(t + pi))
    x2 = c(r * cos(t), r * cos(t + pi))
    class = c(rep("Class 1",200),rep("Class 2",200))
    data = data.frame(x1,x2,class)
  }

  #add Spiral ascend (3D) data sets
  else if(input$task == "Spiral ascend (3D)"){
    z = rexp(200,1)*4
    x = sin(z)
    y = cos(z)
    data = data.frame(x, y, z)
  }







    ################################
    if (input$tasktype == "classif") {
      plotly::plot_ly(
        data = data,
        x = ~x1,
        y = ~x2,
        color = ~class,
        colors = c("#2b8cbe", "#e34a33"),
        type = "scatter",
        mode = "markers"
      )

    } else if (input$tasktype == "regr") {
      plotly::plot_ly(
        data = data,
        x = ~x,
        y = ~y,
        type = "scatter",
        mode = "markers"
      )}else if(input$tasktype == "multilabel"){
      plotly::plot_ly(
          data = data,
          type = "scatter3d",
          x = ~x,
          y = ~y,
          z = ~z,
          marker = list(color = ~z, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE)
        )%>%
          add_markers()%>%
        layout(scene = list(xaxis = list(title = 'xaxis'),
                            yaxis = list(title = 'yaxis'),
                            zaxis = list(title = 'zaxis')))
    } else {
      plotly::plotly_empty()
    }

  })

  session$onSessionEnded(stopApp)
})
