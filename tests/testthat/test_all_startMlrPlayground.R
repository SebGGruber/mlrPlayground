context("startMlrPlayground")

#test_that("can run app", {
#  expect_message({
#    R.utils::evalWithTimeout(start(port = 445566), timeout = 10, onTimeout = "silent")
#  }, "Listening on http://127.0.0.1:445566")
#})

# dummy test
test_that("nchar is number of characters", {
  expect_equal(nchar("a"), 1)
  expect_equal(nchar("ab"), 2)
  expect_equal(nchar("abc"), 3)
})
