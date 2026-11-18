# Generate a Sampling Effort Proxy Surface

Downloads road data for a given country and calculates distance to roads
to create a proxy for human sampling effort.

## Usage

``` r
generate_effort_surface(country = "Pakistan", resolution = 10000)
```

## Arguments

- country:

  Character. Name of the country (e.g., "Pakistan").

- resolution:

  Numeric. Output raster resolution in meters.

## Value

A SpatRaster object where higher values indicate higher probability of
human sampling effort (closer to roads).

## Examples

``` r
# \donttest{
  try({
    effort <- generate_effort_surface("Luxembourg", resolution = 10000)
  })
#> Downloading border for Luxembourg...
#> Downloading major road network (this may take a minute)...
#> Waiting 14.9998700618744 seconds
#> Creating raster grid...
#> Rasterizing roads...
#> Calculating distance to nearest road...
#> Warning: GDAL Message 1: Pixels not square, distances will be inaccurate.
#> Done! Effort surface generated.
# }
```
