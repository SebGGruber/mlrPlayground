parameter_panel = fluidRow(
  conditionalPanel(
    "output.showLearners == false",
    actionButton("parameterDone", "Back"),
    withSpinner(
      uiOutput("dynamicParameters")
    ),
    uiOutput("min_max_modals")
  )
)
