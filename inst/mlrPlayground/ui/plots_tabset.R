# only locally used
prediction_tab = tabPanel(
  "Predictions",
  uiOutput("prob_sel"),
  bsCollapsePanel(
    #tags$span(
      #tags$a(
      #  class = "icon fa-arrow-down", style = "font-size: 17px"),
    tags$b("> Learner 1 <"),
    #),
    tableOutput("table_measures_1")
  ),
  withSpinner(
    plotly::plotlyOutput("predictionPlot_1", width = "90%", height = "450px")
  ),
  bsTooltip("predictionPlot_1", "Drag box to zoom. Double click to reset.", placement = "right"),
  conditionalPanel(
    "output.learner_amount > 1",
    bsCollapsePanel(
      tags$b("> Learner 2 <"),
      tableOutput("table_measures_2")
    ),
    withSpinner(
      plotly::plotlyOutput("predictionPlot_2", width = "90%", height = "450px")
    ),
    bsTooltip("predictionPlot_2", "Drag box to zoom. Double click to reset.", placement = "right")
  )
)

# only locally used
learning_curve_tab = tabPanel(
  "Learning Curve",
  br(),
  fluidRow(
    column(3, helpText("Select measures:")),
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
    br(),
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
