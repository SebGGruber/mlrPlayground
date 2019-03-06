require(shiny)
require(shinyjs)
require(shinythemes)
require(shinyBS)
require(shinycssloaders)


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
      withSpinner(
        uiOutput("dynamicLearners")
      ),
      conditionalPanel(
        "output.learner_amount < 2",
        actionButton("addLearner", "add Learner")
      ),
      hr()
    ),
    conditionalPanel(
      "output.showLearners == false",
      actionButton("parameterDone", "Back"),
      uiOutput("min_max_modals"),
      withSpinner(
        uiOutput("dynamicParameters")
      )
    ),
    column(
      6,
      withSpinner(
        plotly::plotlyOutput("evaluationPlot_1", width = "100%", height = "450px")
      )
    ),
    column(
      6,
      withSpinner(
        plotly::plotlyOutput("evaluationPlot_2", width = "100%", height = "450px")
      )
    ),
    bsModal(
      "taskselection", "Task selection", "taskBut", size = "large",
      fluidRow(
        column(
          5,
          selectInput(
            "tasktype",
            label = "Select task type",
            choices = list("Classification" = "classif", "Regression" = "regr", "Clustering" = "cluster", "Multilabel" = "multilabel", "Survival" = "surv")
          ),
          withSpinner(
            uiOutput("taskSelection")
          )
        ),
        column(
          7,
          withSpinner(
            plotly::plotlyOutput("datasetPlot")
          )
        )
      )
    )
  )
)
