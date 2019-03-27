context("startMlrPlayground")

test_that("can run app", {
  expect_message({
    R.utils::withTimeout(start(port = 445566), timeout = 4, onTimeout = "silent")
  }, "Listening on http://127.0.0.1:445566")
})
