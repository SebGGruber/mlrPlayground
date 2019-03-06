selected_learners = reactive({

  req(learner_amount_enum())
  selection = lapply(learner_amount_enum(), function (i) {
    input[[paste0("learner_", i)]]
  })

  return(unlist(selection))
})

output$dynamicLearners = renderUI({

  req(learner_amount_enum())
  #req(selected_learners())
  lapply(learner_amount_enum(), function(i) {
    fluidRow(
      column(
        3,
        selectInput(
          inputId   = paste0("learner_", i),
          label     = paste("Learner", i),
          choices   = as.list(Choose = "", mlr::listLearners()$name[mlr::listLearners()$type == input$tasktype]),
          selected  = isolate(selected_learners()[i]),
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
