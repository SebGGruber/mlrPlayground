context("learners")

# THIS MAY ACTUALLY FAIL ONCE CONFIG FILE IS CHANGED
# ADJUST TESTS BASED ON CONFIG FILE IN THIS CASE
test_that("test learners", {

  # start app
  app = shinytest::ShinyDriver$new('inst/mlrPlayground', loadTimeout = 15000)

  learner_init = app$getValue(name = "learner_1")
  expect_equal(learner_init, "")

  # test all the learners and check if prediction plot exists


  ### CLASSIF

  app$setInputs(learner_1 = "ranger")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "ranger")
  expect(length(plot) > 0, failure_message = "No plot generated!")
  # expect a change in the plot for the next check
  plot_old = plot

  app$setInputs(learner_1 = "logreg")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "logreg")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "xgboost")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "xgboost")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "rpart")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "rpart")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "kknn")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "kknn")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "nbayes")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "nbayes")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "featureless")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "featureless")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "svm")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "svm")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "extraTrees")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "extraTrees")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot


  ### REGR

  app$setInputs(tasktype = "regr")
  app$setInputs(learner_1 = "ranger")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "ranger")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "xgboost")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "xgboost")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "rpart")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "rpart")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "kknn")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "kknn")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "featureless")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "featureless")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "svm")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "svm")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(learner_1 = "extraTrees")
  learner_1 = app$getValue(name = "learner_1")
  plot = app$getAllValues()$output$predictionPlot_1
  expect_equal(learner_1, "extraTrees")
  expect(all(plot != plot_old), failure_message = "No plot generated!")
  plot_old = plot


  ### CLUSTER

  #app$setInputs(learner_1 = "kkmeans")
  #learner_1 = app$getValue(name = "learner_1")
  #plot = app$getAllValues()$output$predictionPlot_1
  #expect_equal(learner_1, "kkmeans")
  #expect(all(plot != plot_old), failure_message = "No plot generated!")
  #plot_old = plot

})
