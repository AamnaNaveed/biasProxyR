# Sample Bias-Aware Background Points

Draws background points from a sampling effort proxy surface, ensuring
that background points are sampled in proportion to the estimated
sampling effort.

## Usage

``` r
sample_bias_aware_background(effort_surface, n_points = 100)
```

## Arguments

- effort_surface:

  A SpatRaster of sampling effort.

- n_points:

  Integer. Number of background points to sample.

## Value

An sf object containing the sampled background points.

## Examples

``` r
# \donttest{
  try({
    effort <- generate_effort_surface("Luxembourg", resolution = 10000)
    bg_points <- sample_bias_aware_background(effort, n_points = 10)
  })
#> Downloading border for Luxembourg...
#> Downloading major road network (this may take a minute)...
#> Waiting 14.9998407363892 seconds
#> Error in httr2::req_perform(req) : HTTP 502 Bad Gateway.
# }
```
