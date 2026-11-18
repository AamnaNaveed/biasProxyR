# Diagnose Sampling Bias in Occurrence Data

Plots occurrence points over a sampling effort proxy surface and
calculates a "Bias Correlation Score" to quantify how much the data is
skewed toward human infrastructure.

## Usage

``` r
diagnose_sampling_bias(occurrences, effort_surface)
```

## Arguments

- occurrences:

  An sf object containing occurrence points.

- effort_surface:

  A SpatRaster of sampling effort.

## Value

A list containing the bias score (percentage) and a diagnostic message.

## Examples

``` r
# \donttest{
  try({
    effort <- generate_effort_surface("Luxembourg", resolution = 10000)
    bg_points <- sample_bias_aware_background(effort, n_points = 10)
    diagnose_sampling_bias(bg_points, effort)
  })
#> Downloading border for Luxembourg...
#> Downloading major road network (this may take a minute)...
#> Waiting 14.9997432231903 seconds
#> Error in httr2::req_perform(req) : HTTP 502 Bad Gateway.
# }
```
