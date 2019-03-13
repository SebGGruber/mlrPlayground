require(shiny)
#require(shinyjs)
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
    column(
      6,
      hr(),
      hr(),
      conditionalPanel(
        "output.showLearners == true",
        actionButton("taskBut", "Set task"),
        textOutput("taskinfo"),
        hr(),
        bsAlert("learner_error"),
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
        withSpinner(
          uiOutput("dynamicParameters")
        ),
        uiOutput("min_max_modals")
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
    ),
    column(
      6,
      tabsetPanel(
        type = "tabs",
        tabPanel(
          "Predictions",
          helpText("Learner 1:"),
          withSpinner(
            plotly::plotlyOutput("predictionPlot_1", width = "90%", height = "450px")
          ),
          conditionalPanel(
            "output.learner_amount > 1",
            helpText("Learner 2:"),
            withSpinner(
              plotly::plotlyOutput("predictionPlot_2", width = "90%", height = "450px")
            )
          )
        ),
        tabPanel(
          "Learning Curve",
          withSpinner(
            plotOutput("learningCurve", width = "90%", height = "450px")
          )
        ),
        tabPanel(
          "Benchmark",
          withSpinner(
            plotOutput("benchmarkPlot", width = "90%", height = "450px")
          )
        ),
        tabPanel(
          "ROC",
          withSpinner(
            plotOutput("ROCPlot", width = "90%", height = "450px")
          )
        )
      )
    )
  )
)
