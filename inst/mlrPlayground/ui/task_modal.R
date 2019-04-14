# only used locally
modal_body = fluidRow(
  column(
    5,
    selectInput(
      "tasktype",
      label = "Select task type",
      choices = list("Classification" = "classif", "Regression" = "regr") #,"Clustering" = "cluster")
      #choices = list("Classification" = "classif", "Regression" = "regr", "Clustering" = "cluster", "Regression 3D" = "regr3d", "Classification 3D" = "classif3d")
    ),
    br(),
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
    4,
    sliderInput("test_ration", "Ratio of training data:",
                min=0.1, max=0.9, value=0.5,step=0.1)
  ),
  column(
    4,
    sliderInput("noise", "Noise:",
                min=0, max=1, value=0.1,step=0.01)
  ),
  column(
    4,
    sliderInput("datasize", "Data Size:",
                min=20, max=1000, value=200,step=20)
  )
)
# exported
task_modal = bsModal(
  "taskselection", "Task selection", "taskBut", size = "large", modal_body, br(), modal_parameter
)
