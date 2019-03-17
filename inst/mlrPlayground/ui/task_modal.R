# only used locally
modal_body = fluidRow(
  column(
    5,
    selectInput(
      "tasktype",
      label = "Select task type",
      choices = list("Classification" = "classif", "Regression" = "regr", "Clustering" = "cluster")#, "Regression" = "regr", "Clustering" = "cluster", "Multilabel" = "multilabel", "Survival" = "surv")
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

# exported
task_modal = bsModal(
  "taskselection", "Task selection", "taskBut", size = "large", modal_body
)
