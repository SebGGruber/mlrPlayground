context("app-start")

test_that("app start works", {
  appDir = system.file("mlrPlayground", package = "mlrPlayground")
  # start app
  expect_silent(shinytest::ShinyDriver$new(appDir, loadTimeout = 30000))

})
