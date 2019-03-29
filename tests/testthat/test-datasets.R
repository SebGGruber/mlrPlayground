context("datasets")

test_that("test datasets", {

  appDir = system.file("mlrPlayground", package = "mlrPlayground")
  # start app
  app = shinytest::ShinyDriver$new(appDir, loadTimeout = 30000)

  # test all the datasets and check if dataset plots exist

  ### CLASSIF TASKTYPE

  tasktype = app$getValue(name = "tasktype")
  expect_equal(tasktype, "classif")

  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Circle")
  expect(length(plot) > 0, failure_message = "No plot generated!")
  # expect a change in the plot for the next check
  plot_old = plot

  app$setInputs(task = "Two Circle")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Two Circle")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "XOR")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "XOR")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Two Circle + Point")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Two Circle + Point")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Gaussian")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Gaussian")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Across Spiral")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Across Spiral")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Opposite Arc")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Opposite Arc")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Cross Sector")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Cross Sector")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot


  ### REGR TASKTYPE

  app$setInputs(tasktype = "regr")
  tasktype = app$getValue(name = "tasktype")
  expect_equal(tasktype, "regr")

  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Linear ascend")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Log linear")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Log linear")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Polyline")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Polyline")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Ascend Cosine")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Ascend Cosine")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Tangent")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Tangent")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Sigmoid")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Sigmoid")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Three Line")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Three Line")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Amplification Sine")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Amplification Sine")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Parabola To Right")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Parabola To Right")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

  app$setInputs(task = "Precipice")
  task = app$getValue(name = "task")
  plot = app$getAllValues()$output$datasetPlot
  expect_equal(task, "Precipice")
  expect(plot != plot_old, failure_message = "No plot generated!")
  plot_old = plot

})
