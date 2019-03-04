# only works for two learners
# make the list length reactive for arbitrary amount of learners
values = reactiveValues(showLearners = TRUE, showParam1 = FALSE, showParam2 = FALSE)

#
observe({
  req(input$parameter1)
  values$showLearners = FALSE
  values$showParam1 = TRUE
})

#
observe({
  req(input$parameter2)
  values$showLearners = FALSE
  values$showParam2 = TRUE
})

# invert showParam1 whenever "set learner 1 parameter" or "done" button is pressed
observe({
  req(input$parameterDone)
  values$showLearners = TRUE
  values$showParam1 = FALSE
  values$showParam2 = FALSE
})

output$showLearners = reactive(values$showLearners)
output$showParam1 = reactive(values$showParam1)
output$showParam2 = reactive(values$showParam2)

# force loading even when hidden
outputOptions(output, "showLearners", suspendWhenHidden = FALSE)
outputOptions(output, "showParam1",   suspendWhenHidden = FALSE)
outputOptions(output, "showParam2",   suspendWhenHidden = FALSE)
