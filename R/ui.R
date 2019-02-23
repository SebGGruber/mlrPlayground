require(shiny)
require(shinyjs)
require(shinythemes)
require(shinyBS)

ui_files = list.files(path = "./ui", pattern = "*.R")
ui_files = paste0("ui/", ui_files)

for (i in seq_along(ui_files)) {
  #  source(ui_files[i], local = TRUE)
}

shinyUI(
  basicPage(
    hr(),
    conditionalPanel(
      "output.shouldShow == true",
      actionButton("taskBut", "Set task"),
      textOutput("taskinfo"),
      hr(),
      uiOutput("Dynamic"),
      actionButton("addLearner", "Add Learner")
    ),
    conditionalPanel(
      "output.shouldShow == false",
      actionButton("parameterDone", "Done"),
      fluidRow(
        column(3, sliderInput("param1", "Set Parameter1", 0, 10, 5)),
        column(1, numericInput("minparam1", "Min", 0)),
        column(1, numericInput("maxparam1", "Max", 10))
      )
    ),
    hr(),
    plotly::plotlyOutput("evaluationPlot", width = "50%", height = "450px"),
    bsModal(
      "modalExample", "Task selection", "taskBut", size = "large",
      fluidRow(
        column(
          5,
          selectInput(
            "tasktype",
            label = "Select task type",
            choices = list("Classification" = "classif", "Regression" = "regr", "Clustering" = "cluster", "Multilabel" = "multilabel", "Survival" = "surv")
          ),
          uiOutput("taskSelection")
        ),
        column(
          7,
          plotly::plotlyOutput("datasetPlot")
        )
      )
    )
  )
)
