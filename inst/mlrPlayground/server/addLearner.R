# set to 0, because during startup +1 will happen
learner_amount = 0

# make learner amount enumeration reactive
learner_amount_enum = reactive({
  # trigger on addLearner-Button or on change of tasktype
  input$tasktype
  input$addLearner
  learner_amount <<- learner_amount + 1
  return(1:learner_amount)
})

#whenever tasktype is changed, reset learner amount to 0
observe({
  req(input$tasktype)
  learner_amount <<- 0
})

output$learner_amount = reactive({
  if (is.null(learner_amount_enum()))
    learner_amount
  else
    max(learner_amount_enum())
})
