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


observe({
  tasktype   = req(input$tasktype)
  shortnames = listLearners()$short.name[
      listLearners()$type       ==   tasktype
    & listLearners()$short.name %in% valid_learners
  ]
  names = listLearners()$name[
      listLearners()$type       ==   tasktype
    & listLearners()$short.name %in% valid_learners
  ]

  choices                = as.list(c("", shortnames))
  names(choices)         = c("Choose", names)

  values$learner_choices = choices
})


output$dynamicLearners = renderUI({

  req(learner_amount_enum())
  choices = req(values$learner_choices)
  lapply(learner_amount_enum(), function(i) select_learner_ui(i, choices))
})

# force loading even when hidden
outputOptions(output, "dynamicLearners", suspendWhenHidden = FALSE)
