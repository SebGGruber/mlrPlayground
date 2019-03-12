output$taskSelection = renderUI({

  #req(input$tasktype)
  #print(input$tasktype)

  if (input$tasktype == "" || input$tasktype == "classif") {
    choices = list("Circle", "XOR")

  } else if (input$tasktype == "regr") {
    choices = list("Linear ascend (2D)")

  } else if (input$tasktype == "cluster") {
    choices = list()

  } else if (input$tasktype == "multilabel") {
    choices = list()

  } else if (input$tasktype == "surv") {
    choices = list()

  }

  radioButtons("task", label = "Select task", choices = choices)
})

# force loading even when hidden
outputOptions(output, "taskSelection",   suspendWhenHidden = FALSE)
