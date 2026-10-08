#' Diagnose Sampling Bias in Occurrence Data
#'
#' Plots occurrence points over a sampling effort proxy surface
#' and calculates a "Bias Correlation Score" to quantify how much
#' the data is skewed toward human infrastructure.
#'
#' @param occurrences An sf object containing occurrence points.
#' @param effort_surface A SpatRaster object representing sampling effort.
#'
#' @return A list containing the bias score (percentage) and a diagnostic message.
#' @export
#'
#' @examples
#' \dontrun{
#'   effort <- generate_effort_surface("Luxembourg", resolution = 1000)
#'   bg_points <- sample_bias_aware_background(effort, n_points = 100)
#'   diagnose_sampling_bias(bg_points, effort)
#' }

diagnose_sampling_bias <- function(occurrences, effort_surface) {

  # 1. Validate inputs
  if (!inherits(occurrences, "sf")) stop("occurrences must be an sf object.")
  if (!inherits(effort_surface, "SpatRaster")) stop("effort_surface must be a SpatRaster.")

  # 2. Extract effort values at occurrence points
  message("Extracting effort values at occurrence points...")
  occ_vect <- terra::vect(occurrences)
  effort_values <- terra::extract(effort_surface, occ_vect)[, 2] # 2nd column is the value

  # 3. Calculate Bias Score (% of points in the top 25% of effort)
  threshold <- quantile(effort_values, 0.75, na.rm = TRUE)
  high_effort_count <- sum(effort_values >= threshold, na.rm = TRUE)
  total_count <- sum(!is.na(effort_values))
  bias_score <- (high_effort_count / total_count) * 100

  # 4. Print Diagnostic Message
  message(sprintf("DIAGNOSTIC: %.1f%% of your points fall in the top 25%% most accessible areas.", bias_score))
  if (bias_score > 75) {
    message("WARNING: Your data is highly biased toward human infrastructure. Use bias-aware background sampling!")
  } else {
    message("NOTE: Your data shows relatively balanced spatial coverage.")
  }

  # 5. Create Diagnostic Plot
  message("Generating diagnostic plot...")
  terra::plot(effort_surface, main = "Sampling Bias Diagnostic", col = terrain.colors(50))
  plot(occurrences, add = TRUE, col = "red", pch = 16, cex = 0.8)

  # 6. Return results
  return(list(
    bias_score_percent = bias_score,
    message = sprintf("%.1f%% of points in top 25%% effort areas", bias_score)
  ))
}
