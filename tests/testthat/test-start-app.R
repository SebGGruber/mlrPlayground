context("app-start")

test_that("app start works", {
  # start app
  expect_silent(shinytest::ShinyDriver$new('../../mlrPlayground', loadTimeout = 15000))

})
