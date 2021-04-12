context("datasets")

test_that("test datasets", {

  appDir = system.file("mlrPlayground", package = "mlrPlayground")
  # start app
  app = shinytest::ShinyDriver$new(appDir, loadTimeout = 30000)

  # test all the datasets and check if dataset plots exist

  ### CLASSIF TASKTYPE

  tasktype = app$getValue(name = "tasktype")
  expect_equal(tasktype, "classif")

  #task = app$getValue(name = "task")
  #plot = app$getAllValues()$output$datasetPlot
  #expect_equal(task, "Circle")
  #expect(length(plot) > 0, failure_message = "No plot generated!")
  # expect a change in the plot for the next check
  #plot_old = plot

  #app$setInputs(task = "Circle")
  #task = app$getValue(name = "task")
  #plot = app$getAllValues()$output$datasetPlot
  #expect_equal(task, "Two Circle")
  #expect(plot != plot_old, failure_message = "No plot generated!")
  #plot_old = plot



  ### REGR TASKTYPE

  #app$setInputs(tasktype = "regr")
  #tasktype = app$getValue(name = "tasktype")
  #expect_equal(tasktype, "regr")

  #task = app$getValue(name = "task")
  #plot = app$getAllValues()$output$datasetPlot
  #expect_equal(task, "Linear ascend")
  #expect(plot != plot_old, failure_message = "No plot generated!")
  #plot_old = plot

  #app$setInputs(task = "Log linear")
  #task = app$getValue(name = "task")
  #plot = app$getAllValues()$output$datasetPlot
  #expect_equal(task, "Log linear")
  #expect(plot != plot_old, failure_message = "No plot generated!")
  #plot_old = plot


})
