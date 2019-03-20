# set to 0, because during startup +1 will happen
learner_amount = 0

# make learner amount enumeration reactive
learner_amount_enum = reactive({
  input$addLearner
  learner_amount <<- learner_amount + 1
  return(1:learner_amount)
})

output$learner_amount = reactive({
  if (is.null(learner_amount_enum()))
    learner_amount
  else
    max(learner_amount_enum())
})

# force loading even when hidden
outputOptions(output, "learner_amount", suspendWhenHidden = FALSE)
