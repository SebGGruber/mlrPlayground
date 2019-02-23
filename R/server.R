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

  # rendering: output$taskSelection
  source("server/taskSelection.R", local = TRUE)

  output$taskinfo = renderText(paste("Currently selected:", input$tasktype, "-", input$task))

  learner_amount = 1

  omega = reactive({
    #invalidateLater(1000, session) #delay
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

  values = reactiveValues(shouldShow = TRUE)

  observe({
    input$parameter1
    input$parameterDone
    #    if (!is.null(input$parameter1) && input$parameter1 == 0)
    values$shouldShow = !isolate(values$shouldShow)
    #    output$shouldShow <- reactive(isolate(values$shouldShow))
    #    browser()

  })

  output$shouldShow = reactive(values$shouldShow)


  output$Dynamic = renderUI({

    dynamic_selection_list = lapply(omega(), function(i) {
      fluidRow(
        column(
          3,
          selectInput(
            inputId   = paste0("learner", i),
            label     = paste("Learner", i),
            choices   = as.list(Choose = "", mlr::listLearners()$name[mlr::listLearners()$type == input$tasktype]),
            selected  = isolate(selected()[i]),
            selectize = TRUE
          )
        ),
        column(
          9,
          actionButton(paste0("parameter", i), paste("Set learner", i, "parameters"))
        )
      )
    })

    do.call(tagList, dynamic_selection_list)
  })

  output$Parameters = renderUI({

  })

  # rendering: output$evaluationPlot
  source("server/evaluationPlot.R", local = TRUE)

  # rendering: output$datasetPlot
  source("server/datasetPlot.R", local = TRUE)

  # force loading even when hidden
  outputOptions(output, "shouldShow",    suspendWhenHidden = FALSE)
  outputOptions(output, "datasetPlot",   suspendWhenHidden = FALSE)
  outputOptions(output, "Dynamic",       suspendWhenHidden = FALSE)
  outputOptions(output, "taskSelection", suspendWhenHidden = FALSE)
  session$onSessionEnded(stopApp)
})
