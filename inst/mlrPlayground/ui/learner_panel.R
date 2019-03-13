learner_panel = fluidRow(
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
  )
)
