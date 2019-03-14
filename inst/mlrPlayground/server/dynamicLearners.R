selected_learners = reactive({

  req(learner_amount_enum())
  selection = lapply(learner_amount_enum(), function (i) {
    input[[paste0("learner_", i)]]
  })

  return(unlist(selection))
})

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
  #req(selected_learners())
  lapply(learner_amount_enum(), function(i) {
    fluidRow(
      column(
        3,
        selectInput( #selectizeInput(
          inputId   = paste0("learner_", i),
          label     = paste("Learner", i),
          choices   = choices,
          selected  = isolate(selected_learners()[i]),
          #options = list(
          #  placeholder = 'Please select an option below',
          #  onInitialize = I('function() { this.setValue(""); }')
          #)#,
          selectize = TRUE
        )
      ),
      column(
        9,
        actionButton(paste0("parameter", i), paste("Set learner", i, "parameters"))
      )
    )
  })
})

# force loading even when hidden
outputOptions(output, "dynamicLearners", suspendWhenHidden = FALSE)
