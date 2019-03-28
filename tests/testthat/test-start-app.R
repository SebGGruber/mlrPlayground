context("app-start")

test_that("app start works", {
  # start app
  expect_silent(shinytest::ShinyDriver$new('../../inst/mlrPlayground', loadTimeout = 15000))

})
