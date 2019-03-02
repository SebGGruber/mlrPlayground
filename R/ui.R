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
  fluidPage(
    fluidRow(
      actionButton("taskBut", "Set task"),
      textOutput("taskinfo"),
      uiOutput("learnerSelection"),
      actionButton("paramBut", "Change parameters"),
      plotOutput("distPlot"),
      bsModal(
        "modalExample", "Task selection", "taskBut", size = "large",
        fluidRow(
          column(
            5,
            selectInput(
              "tasktype",
              label = "Select task type",
              choices = list("Classification" = "classif", "Classification 3D" = "classif_3d","Regression" = "regr","Regression 3D" = "regr_3d", "Clustering" = "cluster", "Multilabel" = "multilabel", "Survival" = "surv")
            ),
            uiOutput("taskselection")
          ),
          column(
            7,
            plotly::plotlyOutput("datasetPlot")
          )
        )
      )
    )
  )
)
