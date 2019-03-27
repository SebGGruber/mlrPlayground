select_learner_ui = function(i, choices) {
  #' @description function defining the UI for learner with index i
  #' @param i Index of the learner for identification purposes
  #' @param choices Named list of valid learners to choose from
  #' @return UI element

  # can't do reactive value selections by indexing
  i = as.character(i)

  div(
    fluidRow(
      column(
        3,
        helpText(paste("Learner", i))
      ),
      column(
        6,
        div(
          selectInput( #selectizeInput(
            inputId   = paste0("learner_", i),
            label     = "",
            choices   = choices,
            selected  = isolate(process$learners[[i]]$short.name),
            selectize = TRUE,
            # box should fill its given space
            width = "inherit"
          )
        )
      ),
      column(
        3,
        div(
          conditionalPanel(
            paste0("output.showBtnParam", i, " == true"),
            actionButton(paste0("parameter", i), "Parameters", icon = icon("cog"))
          ),
          style = "min-width: 160px;"
        )
      )
    ),
    br(),
    br()
  )
}


output$dynamicLearners = renderUI({

  req(learner_amount_enum())
  choices = req(process$learners$choices)
  # create learner selection based on the amount of learners and the given choices
  # (defined by tasktype)
  lapply(learner_amount_enum(), function(i) select_learner_ui(i, choices))
})
