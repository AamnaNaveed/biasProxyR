test_that("sample_bias_aware_background returns an sf object correctly", {
  fake_raster <- terra::rast(
    nrows = 10, ncols = 10, xmin = 0, xmax = 10, ymin = 0, ymax = 10
  )
  terra::values(fake_raster) <- runif(100, 0, 1)

  result <- sample_bias_aware_background(fake_raster, n_points = 50)

  expect_s3_class(result, "sf")
  expect_identical(nrow(result), 50L)
})

test_that("diagnose_sampling_bias returns correct list structure", {
  fake_raster <- terra::rast(
    nrows = 10, ncols = 10, xmin = 0, xmax = 10, ymin = 0, ymax = 10
  )
  terra::values(fake_raster) <- runif(100, 0, 1)

  occ_points <- sf::st_as_sf(
    data.frame(x = runif(20, 0, 10), y = runif(20, 0, 10)),
    coords = c("x", "y"),
    crs = terra::crs(fake_raster)
  )

  expect_message(
    result <- diagnose_sampling_bias(occ_points, fake_raster),
    "DIAGNOSTIC"
  )

  expect_type(result, "list")
  expect_named(result, c("bias_score_percent", "message"))
})

test_that("generate_effort_surface throws an error for invalid countries", {
  expect_error(
    suppressMessages(generate_effort_surface("FakeCountry123")),
    "FakeCountry123"
  )
})

# --- NEW TESTS TO BOOST COVERAGE ---
test_that("sample_bias_aware_background validates input types", {
  expect_error(sample_bias_aware_background("not_a_raster"), "must be a SpatRaster")

  fake_raster <- terra::rast(nrows = 10, ncols = 10, xmin = 0, xmax = 10, ymin = 0, ymax = 10)
  expect_error(sample_bias_aware_background(fake_raster, n_points = -5), "must be a positive integer")
})

test_that("diagnose_sampling_bias validates input types", {
  expect_error(diagnose_sampling_bias("not_sf", "not_raster"), "must be an sf object")

  occ_points <- sf::st_as_sf(data.frame(x = 1, y = 1), coords = c("x", "y"))
  expect_error(diagnose_sampling_bias(occ_points, "not_raster"), "must be a SpatRaster")
})

test_that("generate_effort_surface checks for required package", {
  with_mocked_bindings(
    requireNamespace = function(...) FALSE,
    code = expect_error(generate_effort_surface("Luxembourg"), "required")
  )
})
