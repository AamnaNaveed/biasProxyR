# biasProxyR

<!-- badges: start -->
<!-- badges: end -->

**Generating Sampling Effort Proxies for Species Distribution Modeling in Data-Poor Regions.**

## The Problem

When building Species Distribution Models (SDMs) like MaxNet or Random Forest, researchers need "background" points to represent the available environment. In the Global North, researchers often use "target-group backgrounds" (e.g., using all bird sightings to model a specific bird's habitat) to cancel out sampling bias.

But in the Global South (e.g., Pakistan, Brazil, Kenya), target-group backgrounds often **do not exist** because the baseline biodiversity data is too sparse. If you sample background points randomly across a country, your model doesn't learn where the species grows; it just learns "where the roads and cities are."

For example, in Pakistan, approximately 75% of GBIF plant records are concentrated in a single province (Punjab), leaving entire regions like Balochistan as "data deserts." Standard SDM workflows fail to account for this severe geographic bias.

## The Solution

`biasProxyR` uses freely available global remote sensing and infrastructure data to map the "probability of human sampling effort." Researchers can then use this proxy map to intelligently sample background points that match the *bias* of their occurrence data, which is the statistically correct way to handle sampling bias when target-group data is absent.

## Core Functions

*   `generate_effort_surface()`: Downloads road density and terrain data for a given country and combines them into a single raster representing the probability of human sampling effort.
*   *(Coming soon)* `sample_bias_aware_background()`: Samples background points for SDMs proportionally to the effort surface, effectively canceling out geographic bias.
*   *(Coming soon)* `diagnose_sampling_bias()`: A quick, publication-ready diagnostic tool that plots GBIF points over the effort surface and calculates a "Bias Correlation Score."

## Installation

You can install the development version of biasProxyR from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("AamnaNaveed/biasProxyR")
