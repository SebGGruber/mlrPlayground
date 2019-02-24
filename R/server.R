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

  learner_amount_enum = reactive({
    #invalidateLater(1000, session) #delay
    input$addLearner
    return(1:learner_amount)
  })

  # update non reactive value
  observe({
    learner_amount_enum()
    learner_amount <<- learner_amount + 1 # sorry, bernd ;D
  })


  selected_learners = reactive({

    selection = lapply(learner_amount_enum(), function (i) {
      input[[paste0("learner", i)]]
    })

    return(unlist(selection))
  })

  # reactive: output$showLearners, output$showParam1, output$showParam2
  source("server/showLogic.R", local = TRUE)

  # rendering: output$dynamicLearners
  source("server/dynamicLearners.R", local = TRUE)

  output$dynamicParameters = renderUI({

    lapply(learner_amount_enum(), function(i) {
      conditionalPanel(
        paste0("output.showParam", i, " == false"),

        fluidRow(
          column(3, sliderInput("param1", "Set Parameter1", 0, 10, 5)),
          column(1, numericInput("minparam1", "Min", 0)),
          column(1, numericInput("maxparam1", "Max", 10))
        )
      )
    })
  })

  # rendering: output$evaluationPlot
  source("server/evaluationPlot.R", local = TRUE)

  # rendering: output$datasetPlot
  source("server/datasetPlot.R", local = TRUE)

  # force loading even when hidden
  outputOptions(output, "datasetPlot",     suspendWhenHidden = FALSE)
  outputOptions(output, "taskSelection",   suspendWhenHidden = FALSE)
  session$onSessionEnded(stopApp)
})
