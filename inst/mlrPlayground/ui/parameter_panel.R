parameter_panel = fluidRow(
  conditionalPanel(
    "output.showLearners == false",
    actionButton("parameterDone", "Back"),
    # separated for independent reactivity
    withSpinner(
      uiOutput("dynamicParameters_1")
    ),
    withSpinner(
      uiOutput("dynamicParameters_2")
    ),
    # separated for independent reactivity
    uiOutput("min_max_modals_1"),
    uiOutput("min_max_modals_2")
  )
)
