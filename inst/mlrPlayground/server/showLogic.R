# only works for two learners
# make the list length reactive for arbitrary amount of learners
show = reactiveValues(learners = TRUE, param1 = FALSE, param2 = FALSE)

# if "Set learner 1 parameter"-button is pressed, show parameter 1 panel
observe({
  req(input$parameter1)
  show$learners = FALSE
  show$param1   = TRUE
})

# if "Set learner 2 parameter"-button is pressed, show parameter 2 panel
observe({
  req(input$parameter2)
  show$learners = FALSE
  show$param2   = TRUE
})

# if "back"-button is pressed, show learner panel
observe({
  req(input$parameterDone)
  show$learners = TRUE
  show$param1   = FALSE
  show$param2   = FALSE
})

# make the logic accessible for conditional panels
output$showLearners = reactive(show$learners)
output$showParam1   = reactive(show$param1)
output$showParam2   = reactive(show$param2)
