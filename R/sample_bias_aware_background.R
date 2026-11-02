#' Sample Bias-Aware Background Points
#'
#' Draws background points from a sampling effort proxy surface,
#' ensuring that background points are sampled in proportion to
#' the estimated sampling effort.
#'
#' @param effort_surface A SpatRaster object representing sampling effort.
#' @param n_points An integer specifying the number of background points to sample.
#'
#' @return An sf object containing the sampled background points.
#' @export
#' @importFrom terra spatSample crs
#' @importFrom sf st_as_sf
#'
#' @examples
#' \dontrun{
#'   effort <- generate_effort_surface("Luxembourg", resolution = 1000)
#'   bg_points <- sample_bias_aware_background(effort, n_points = 100)
#' }
sample_bias_aware_background <- function(effort_surface, n_points = 100) {
  # 1. Validate inputs
  if (!inherits(effort_surface, "SpatRaster")) stop("effort_surface must be a SpatRaster.", call. = FALSE)
  if (!is.numeric(n_points) || n_points <= 0) stop("n_points must be a positive integer.", call. = FALSE)

  # 2. Sample points weighted by effort
  message(sprintf("Sampling %d bias-aware background points...", n_points))
  sampled_pts <- terra::spatSample(effort_surface, size = n_points, prob = TRUE, na.rm = TRUE, xy = TRUE)

  # 3. Convert to sf
  bg_sf <- sf::st_as_sf(sampled_pts, coords = c("x", "y"), crs = terra::crs(effort_surface))

  message("Sampling complete.")
  return(bg_sf)
}
