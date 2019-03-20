# only used locally
modal_body = fluidRow(
  column(
    5,
    selectInput(
      "tasktype",
      label = "Select task type",
      choices = list("Classification" = "classif", "Regression" = "regr", "Clustering" = "cluster", "Regression 3D" = "regr3d", "Classification 3d" = "classif3d")
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
    sliderInput("test_ration", "Ratio of training data:", 
                min=0.1, max=1, value=0.5,step=0.1)
  ),
  column(
    3,
    sliderInput("noise", "Noise:",
                min=0.1, max=1, value=0.1,step=0.1)
  ),
  column(
    3,
    sliderInput("datasize", "Data Size:", 
                min=100, max=10000, value=400,step=100)
  )
)
# exported
task_modal = bsModal(
  "taskselection", "Task selection", "taskBut", size = "large", modal_body, modal_parameter
)
