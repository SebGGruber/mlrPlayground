shinyServer(function(input, output, session) {

  # Triggers/Observers for:
  # process init, data init, learner init, learner updates, pred calculations
  source("server/processPipe.R", local = TRUE)

  # rendering: output$taskSelection, output$taskinfo, output$datasetPlot
  source("server/taskModal.R", local = TRUE)

  # rendering: output$learer_amount
  source("server/addLearner.R", local = TRUE)

  # reactive: output$showLearners, output$showParam1, output$showParam2
  source("server/showLogic.R", local = TRUE)

  # rendering: output$dynamicLearners
  source("server/dynamicLearnerTab.R", local = TRUE)

  # trigger functionality of min/max buttons +
  # rendering: output$dynamicParameters_1, output$dynamicParameters_2,
  # ... output$min_max_modals_1, output$min_max_modals_2
  source("server/dynamicParameterTab.R", local = TRUE)

  # rendering: output$predictionPlot_1, output$predictionPlot_2,
  # ... output$measure_1_sel, output$measure_2_sel,
  # ... output$measure_1_val, output§measure_2_val, output$prob_sel
  source("server/predictionTab.R", local = TRUE)

  # rendering: output$learningCurve, output$measure_multi_lc
  source("server/learningCurveTab.R", local = TRUE)

  # rendering: output$ROCPlot, output$measure_1_roc, output$measure_2_roc,
  # ... output$tasktype
  source("server/ROCTab.R", local = TRUE)

  # all "outputOptions" settings
  source("server/outputOptions.R", local = TRUE)

  session$onSessionEnded(stopApp)
})
