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
      "output.showLearners == true",
      actionButton("taskBut", "Set task"),
      textOutput("taskinfo"),
      hr(),
      uiOutput("dynamicLearners"),
      actionButton("addLearner", "Add Learner")
    ),
    conditionalPanel(
      "output.showLearners == false",
      actionButton("parameterDone", "Done"),
      uiOutput("dynamicParameters")
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
