# only works for two learners atm
# make the list length reactive for arbitrary amount of learners
show = reactiveValues(learners = TRUE, param1 = FALSE, param2 = FALSE)

#
observe({
  req(input$parameter1)
  show$learners = FALSE
  show$param1 = TRUE
})

#
observe({
  req(input$parameter2)
  show$learners = FALSE
  show$param2 = TRUE
})

#
observe({
  req(input$parameterDone)
  show$learners = TRUE
  show$param1 = FALSE
  show$param2 = FALSE
})

output$showLearners = reactive(show$learners)
output$showParam1   = reactive(show$param1)
output$showParam2   = reactive(show$param2)

# force loading even when hidden
outputOptions(output, "showLearners", suspendWhenHidden = FALSE)
outputOptions(output, "showParam1",   suspendWhenHidden = FALSE)
outputOptions(output, "showParam2",   suspendWhenHidden = FALSE)
