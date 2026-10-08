test_that("biasProxyR loads and functions exist", {
  expect_true(requireNamespace("biasProxyR", quietly = TRUE))
  expect_true(exists("generate_effort_surface"))
  expect_true(exists("diagnose_sampling_bias"))
})
