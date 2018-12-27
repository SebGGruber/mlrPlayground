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
      choices = list("Circle", "XOR")

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
      class = ifelse((x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0), "Class 1", "Class 2")

      data = data.frame(x1, x2, class)

    } else if (input$task == "Linear ascend (2D)") {

      x = rnorm(200, 0, 5)
      y = 0.5 * x + rnorm(200, 0, 1)

      data = data.frame(x, y)

    }

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
      )

    } else {
      plotly::plotly_empty()
    }

  })

  session$onSessionEnded(stopApp)
})
