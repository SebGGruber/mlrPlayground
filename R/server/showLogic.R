# only works for two learners - make this reactive for arbitrary amount of learners
values = reactiveValues(showLearners = TRUE, showParam1 = FALSE, showParam2 = FALSE)

# invert showLearners whenever any "set parameter" or "done" button is pressed
observe({
  lapply(learner_amount_enum(), function (i) {
    input[[paste0("parameter", i)]]
  })
  input$parameterDone
  values$showLearners = !isolate(values$showLearners)
})

output$showLearners = reactive(values$showLearners)

# invert showParam1 whenever "set learner 1 parameter" or "done" button is pressed
observe({
  input$parameter1
  input$parameterDone
  values$showParam1 = !isolate(values$showParam1)
})

output$showParam1 = reactive(values$showParam1)

# invert showParam2 whenever "set learner 2 parameter" or "done" button is pressed
observe({
  input$parameter2
  input$parameterDone
  values$showParam2 = !isolate(values$showParam2)
})

output$showParam2 = reactive(values$showParam2)

# force loading even when hidden
outputOptions(output, "showLearners", suspendWhenHidden = FALSE)
outputOptions(output, "showParam1",   suspendWhenHidden = FALSE)
outputOptions(output, "showParam2",   suspendWhenHidden = FALSE)
