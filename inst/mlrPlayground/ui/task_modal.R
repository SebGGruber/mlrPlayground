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

modal_parameter = fluidRow(
  
  column(
    3,
    sliderInput("test_ration", "Ratio of training to test data:", 
                min=0, max=1, value=0.5,step=0.1)
  ),
  column(
    3,
    sliderInput("scope", "Rescope:", 
                min=0, max=10, value=3,step=1)
  ),
  column(
    3,
    sliderInput("outlier", "Outlier:", 
                min=0, max=1, value=0.5,step=0.1)
  )
)
# exported
task_modal = bsModal(
  "taskselection", "Task selection", "taskBut", size = "large", modal_body, modal_parameter
)
