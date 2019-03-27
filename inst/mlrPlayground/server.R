shinyServer(function(input, output, session) {

  # reactive:
  source("server/reactiveValues.R", local = TRUE)

  # rendering: output$taskSelection, output$taskinfo
  source("server/taskSelection.R", local = TRUE)

  # rendering: output$addLearner
  source("server/addLearner.R", local = TRUE)

  # reactive: output$showLearners, output$showParam1, output$showParam2
  source("server/showLogic.R", local = TRUE)

  # rendering: output$dynamicLearners
  source("server/dynamicLearners.R", local = TRUE)

  # rendering: output$dynamicParameters
  source("server/dynamicParameters.R", local = TRUE)

  # rendering: output$evaluationPlot
  source("server/predictionPlot.R", local = TRUE)

  # rendering: output$datasetPlot
  source("server/datasetPlot.R", local = TRUE)

  # rendering: output$learningCurve
  source("server/learningCurve.R", local = TRUE)

  # rendering: output$benchmarkPlot
  source("server/benchmarkPlot.R", local = TRUE)

  # rendering: output$ROCPlot
  source("server/ROCPlot.R", local = TRUE)

  session$onSessionEnded(stopApp)
})
