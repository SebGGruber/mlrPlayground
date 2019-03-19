# set to 0, because during first execution +1 will happen
learner_amount = 0

# update non reactive value
# (this has to be seperate because learner_amount is meant to be non-reactive)
# TODO: try isolate for learner_amount
#observe({
#  req(learner_amount_enum())
#  learner_amount <<- learner_amount + 1
#})

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
