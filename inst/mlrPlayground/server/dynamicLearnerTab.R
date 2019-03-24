select_learner_ui = function(i, choices) {
  #' @description function defining the UI for learner with index i
  #' @param i Index of the learner for identification purposes
  #' @param choices Named list of valid learners to choose from
  #' @return UI element

  # can't do reactive value selections by indexing
  i = as.character(i)
  fluidRow(
    column(
      3,
      selectInput( #selectizeInput(
        inputId   = paste0("learner_", i),
        label     = paste("Learner", i),
        choices   = choices,
        selected  = isolate(process$learners[[i]]$short.name),
        selectize = TRUE
      )
    ),
    column(
      9,
      actionButton(paste0("parameter", i), paste("Set learner", i, "parameters"))
    )
  )
}


output$dynamicLearners = renderUI({

  req(learner_amount_enum())
  choices = req(process$learners$choices)
  # create learner selection based on the amount of learners and the given choices
  # (defined by tasktype)
  lapply(learner_amount_enum(), function(i) select_learner_ui(i, choices))
})
