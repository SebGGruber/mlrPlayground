# only locally used
prediction_tab = tabPanel(
  "Predictions",
  fluidRow(
    column(3, helpText("Learner 1:")),
    column(2, uiOutput("measure_1_value")),
    column(3, uiOutput("measure_1_sel")),
    column(3, uiOutput("prob_sel"))
  ),
  withSpinner(
    plotly::plotlyOutput("predictionPlot_1", width = "90%", height = "450px")
  ),
  conditionalPanel(
    "output.learner_amount > 1",
    fluidRow(
      column(3, helpText("Learner 2:")),
      column(2, uiOutput("measure_2_value")),
      column(3, uiOutput("measure_2_sel"))
    ),
    withSpinner(
      plotly::plotlyOutput("predictionPlot_2", width = "90%", height = "450px")
    )
  )
)

# only locally used
learning_curve_tab = tabPanel(
  "Learning Curve",
  fluidRow(
    column(3, helpText("Measures:")),
    column(3, uiOutput("measure_multi_lc"))
  ),
  withSpinner(
    plotOutput("learningCurve", width = "90%", height = "450px")
  )
)

# only locally used
roc_tab = tabPanel(
  "ROC",
  conditionalPanel(
    "output.tasktype == 'classif'",
    fluidRow(
      column(3, helpText("Measures:")),
      column(3, uiOutput("measure_1_roc")),
      column(3, uiOutput("measure_2_roc"))
    ),
    withSpinner(
      plotOutput("ROCPlot", width = "90%", height = "450px")
    )
  ),
  conditionalPanel(
    "output.tasktype != 'classif'",
    helpText("ROC is only supported for classification tasks!")
  )
)

# exported
plots_tabset = tabsetPanel(
  type = "tabs",
  prediction_tab,
  learning_curve_tab,
  roc_tab
)
