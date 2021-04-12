context("learners")

# THIS MAY ACTUALLY FAIL ONCE CONFIG FILE IS CHANGED
# ADJUST TESTS BASED ON CONFIG FILE IN THIS CASE
test_that("test learners", {

  appDir = system.file("mlrPlayground", package = "mlrPlayground")
  # start app
  app = shinytest::ShinyDriver$new(appDir, loadTimeout = 30000)

  ### CLUSTER

  #app$setInputs(learner_1 = "kkmeans")
  #learner_1 = app$getValue(name = "learner_1")
  #plot = app$getAllValues()$output$predictionPlot_1
  #expect_equal(learner_1, "kkmeans")
  #expect(all(plot != plot_old), failure_message = "No plot generated!")
  #plot_old = plot

})
