#' Generate a Sampling Effort Proxy Surface
#'
#' Downloads road data for a given country and calculates
#' distance to roads to create a proxy for human sampling effort.
#'
#' @param country Character. Name of the country (e.g., "Pakistan").
#' @param resolution Numeric. Output raster resolution in meters (default = 10000).
#'
#' @return A SpatRaster object where higher values indicate
#'   higher probability of human sampling effort (closer to roads).
#' @export
generate_effort_surface <- function(country = "Pakistan", resolution = 10000) {

  # 1. Get the country border
  message("Downloading border for ", country, "...")
  border <- rnaturalearth::ne_countries(country = country, scale = "medium", returnclass = "sf")

  # CRITICAL FIX: Reproject the border to a metric CRS (EPSG:3857)
  # so that our resolution is actually in meters, not degrees!
  border <- sf::st_transform(border, 3857)

  # 2. Download major roads (opq needs lat/lon for the bounding box)
  message("Downloading major road network (this may take a minute)...")
  bbox_latlon <- sf::st_bbox(sf::st_transform(border, 4326))

  roads <- osmdata::opq(bbox = bbox_latlon, timeout = 300) |>
    osmdata::add_osm_feature(key = "highway", value = c("motorway", "trunk", "primary", "secondary")) |>
    osmdata::osmdata_sf()

  road_lines <- roads$osm_lines

  # Reproject roads to the same metric CRS
  road_lines <- sf::st_transform(road_lines, 3857)

  # 3. Create a blank raster grid over the country (now in meters!)
  message("Creating raster grid...")
  template_raster <- terra::rast(
    terra::ext(terra::vect(border)),
    resolution = resolution,
    crs = "EPSG:3857"
  )

  # 4. Rasterize roads
  message("Rasterizing roads...")
  road_raster <- terra::rasterize(terra::vect(road_lines), template_raster, fun = "count", background = 0)

  # 5. Calculate distance to nearest road
  message("Calculating distance to nearest road...")
  road_presence <- road_raster > 0

  # Safety check: ensure roads were actually rasterized
  if (terra::global(road_presence, "sum", na.rm = TRUE)[1, 1] == 0) {
    stop("No roads were found for this country. Check the country name or try a larger resolution.")
  }

  dist_to_road <- terra::distance(road_presence, target = TRUE)

  # 6. Invert and normalize: closer to road = higher value (0 to 1)
  max_dist <- terra::global(dist_to_road, "max", na.rm = TRUE)[1, 1]
  road_proximity <- 1 - (dist_to_road / max_dist)

  # 7. Mask to country border and return
  effort_surface <- terra::mask(road_proximity, terra::vect(border))

  message("Done! Effort surface generated.")
  return(effort_surface)
}
