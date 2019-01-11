require(mlr)
require(plotly)
require(ada)

server_files = list.files(path = "./servers", pattern="*.R")
server_files = paste0("servers/", server_files)

for (i in seq_along(server_files)) {
#  source(server_files[i], local = TRUE)
}

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output, session) {

  values <- reactiveValues(shouldShow = TRUE)

  observe({
    input$parameter1
    input$parameterDone
#    if (!is.null(input$parameter1) && input$parameter1 == 0)
    values$shouldShow = !isolate(values$shouldShow)
    output$shouldShow <- reactive(isolate(values$shouldShow))
    browser()

  })

  #output$shouldShow <- reactive(values$shouldShow)


#  observe({
#    if (is.null(input$parameterDone) || input$parameterDone == 0)
#      values$shouldShow = "FALSE"
#  })

  learner_amount = 1

  output$taskselection = renderUI({

    #req(input$tasktype)
    #print(input$tasktype)

    if (input$tasktype == "" || input$tasktype == "classif") {
      choices = list("Circle", "XOR")

    } else if (input$tasktype == "regr") {
      choices = list("Linear ascend (2D)")

    } else if (input$tasktype == "cluster") {
      choices = list()

    } else if (input$tasktype == "multilabel") {
      choices = list()

    } else if (input$tasktype == "surv") {
      choices = list()

    }

    radioButtons("task", label = "Select task", choices = choices)
  })


  output$taskinfo = renderText(paste("Currently selected:", input$tasktype, "-", input$task))


  omega = reactive({
    #invalidateLater(1000, session)
    input$addLearner
    return(1:learner_amount)
  })

  # update non reactive value
  observe({
    omega()
    learner_amount <<- learner_amount + 1 # sorry, bernd ;D
  })


  selected = reactive({

    selection = lapply(omega(), function (i) {
      input[[paste0("learner", i)]]
    })

    return(unlist(selection))
  })


  output$Dynamic = renderUI({

    dynamic_selection_list = lapply(omega(), function(i) {
      fluidRow(
        column(
          3,
          selectInput(
            inputId  = paste0("learner", i),
            label    = paste("Learner", i),
            choices  = as.list(mlr::listLearners()$name[mlr::listLearners()$type == input$tasktype]),
            selected = isolate(selected()[i])
          )
        ),
        column(
          9,
          actionButton(paste0("parameter", i), paste("Set learner", i, "parameters"))
        )#,
#        bsModal(
#          paste0("parameterPopup", i), "Parameter selection", paste0("parameter", i), size = "small",
#          fluidRow(
#            numericInput(paste0("parameterNumeric", i), "Example Hyperparameter 1", 1),
#            sliderInput(paste0("parameterSlider", i), "Example Hyperparameter 2", 0, 10, 5)
#          )
#        )
      )
    })

    do.call(tagList, dynamic_selection_list)
  })


  output$evaluationPlot = renderPlotly({

    #input$startTraining
    input$learner1
    input$parameterSlider1

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
    learner_mlr = mlr::makeLearner(mlr::listLearners()$class[mlr::listLearners()$name == input$learner1])
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
