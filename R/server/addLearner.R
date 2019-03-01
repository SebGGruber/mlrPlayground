# set to 0, because during first execution +1 will happen
learner_amount = 1

# update non reactive value
# (this has to be seperate because learner_amount is meant to be non-reactive)
observe({
  req(learner_amount_enum())
  #learner_amount_enum()
  learner_amount <<- learner_amount + 1 # sorry, bernd ;D
})

# make learner amount enumeration reactive
learner_amount_enum = reactive({
  input$addLearner
  #invalidateLater(1000, session) # delay
  #input$addLearner
#  learner_amount <<- learner_amount + 1 # sorry, bernd ;D

  return(1:learner_amount)
})

output$learner_amount = reactive({
  if (is.null(learner_amount_enum()))
    learner_amount
  else
    max(learner_amount_enum())
})

# limit amount of learners to 2
#output$addLearner = renderUI({
  #req(learner_amount_enum())
  # can't use "learner_amount" here because it's non-reactive
#  if (max(learner_amount_enum()) < 2)
#    actionButton("addLearner", "add Learner")
#  else
#    NULL
#})

# force loading even when hidden
outputOptions(output, "learner_amount", suspendWhenHidden = FALSE)
