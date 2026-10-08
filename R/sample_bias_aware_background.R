#' Sample Bias-Aware Background Points
#'
#' Generates background points for Species Distribution Models (SDMs)
#' that are weighted by a sampling effort proxy surface. This cancels
#' out geographic sampling bias in data-poor regions.
#'
#' @param effort_surface A SpatRaster object representing sampling effort
#'   (e.g., from generate_effort_surface).
#' @param n_points Numeric. The number of background points to generate (default = 10000).
#'
#' @return An sf object containing the sampled background points.
#' @export
#'
#' @examples
#' \dontrun{
#'   effort <- generate_effort_surface("Luxembourg", resolution = 1000)
#'   bg_points <- sample_bias_aware_background(effort, n_points = 1000)
#' }

sample_bias_aware_background <- function(effort_surface, n_points = 10000) {

  # 1. Ensure effort surface is valid
  if (missing(effort_surface) || terra::nlyr(effort_surface) == 0) {
    stop("Please provide a valid effort_surface raster.")
  }

  # 2. Sample random points weighted by the effort surface
  # xy = TRUE ensures the matrix includes the coordinates
  message("Sampling ", n_points, " bias-aware background points...")
  bg_coords <- terra::spatSample(effort_surface, size = n_points, method = "random", prob = TRUE, na.rm = TRUE, xy = TRUE)

  # 3. Convert to sf object for easy mapping
  # spatSample returns a matrix. We convert to a data frame and force 'x' and 'y' names
  bg_df <- as.data.frame(bg_coords)
  colnames(bg_df)[1:2] <- c("x", "y")

  bg_sf <- sf::st_as_sf(bg_df, coords = c("x", "y"), crs = terra::crs(effort_surface))

  message("Done! Generated ", n_points, " background points.")
  return(bg_sf)
}
