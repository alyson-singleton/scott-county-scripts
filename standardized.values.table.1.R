# load libraries
library(car)
library(ggplot2)
library(lmtest)
library(tidyverse)
library(psycho)
library(ggplot2)
library(reshape2)
library(dplyr)
library(reshape2)

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

setwd("~/Desktop/research/SC_inj_net_dynamics/scripts")
# load simulated measures
all_data <- read.table("TITAN_network_metrics_output_A2.txt")
# update column names
colnames(all_data) <- c("run", "average_degree", "maximum_degree", "betweenness_centrality", "ii_betweenness_centrality", "ii_closeness_centrality", "ii_eigenvector_centrality", "component_size", "number_connected_components", "component_density", "totalnodecount", "totaledgecount", "CCnodescount", "CCedgescount", "geodesic_dist", "ii_geodesic_distance", "centralization", "prop_2_cores", "transitivity", "diameter")

# load observed measures
observed <- read.table("observed_SC_network_metrics_output.txt")
observed <- observed[1,]
observed <- observed[,2:10]
# update column names
colnames(observed) <- c("betweenness_centrality", "random_walk_betweenness_centrality", "component_size", "component_density", "geodesic_dist", "centralization", "prop_2_cores", "transitivity", "diameter")

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

# Build standardized set and
# To find summary statistics of 1000 randomly generated networks (for Table 1)

# summary
summary(total_data_A3$betweenness_centrality)
# standard deviation
sd(total_data_A3$betweenness_centrality)
# empirical cumulative distribution function
ecdf(total_data_A3$betweenness_centrality)(observed_A3$betweenness_centrality)
# store standardized simulated values in new column
total_data_A3$sd_bc <- (total_data_A3$betweenness_centrality - mean(total_data_A3$betweenness_centrality)) / sd(total_data_A3$betweenness_centrality)
# store standardized observed value in new column
observed_A3$sd_bc <- (observed_A3$betweenness_centrality - mean(total_data_A3$betweenness_centrality)) / sd(total_data_A3$betweenness_centrality)
# calculate number of standard deviations in between observed value and simulated mean
(observed_A3$betweenness_centrality - mean(total_data_A3$betweenness_centrality)) / sd(total_data_A3$betweenness_centrality)

summary(total_data_A3$random_walk_betweenness_centrality)
sd(total_data_A3$random_walk_betweenness_centrality)
ecdf(total_data_A3$random_walk_betweenness_centrality)(observed_A3$random_walk_betweenness_centrality)
total_data_A3$sd_rwbc <- (total_data_A3$random_walk_betweenness_centrality - mean(total_data_A3$random_walk_betweenness_centrality)) / sd(total_data_A3$random_walk_betweenness_centrality)
observed_A3$sd_rwbc <- (observed_A3$random_walk_betweenness_centrality - mean(total_data_A3$random_walk_betweenness_centrality)) / sd(total_data_A3$random_walk_betweenness_centrality)

summary(total_data_A3$component_size)
sd(total_data_A3$component_size)
ecdf(total_data_A3$component_size)(observed_A3$component_size)
total_data_A3$sd_cs <- (total_data_A3$component_size - mean(total_data_A3$component_size)) / sd(total_data_A3$component_size)
observed_A3$sd_cs <- (observed_A3$component_size - mean(total_data_A3$component_size)) / sd(total_data_A3$component_size)
(observed_A3$component_size - mean(total_data_A3$component_size)) / sd(total_data_A3$component_size)

summary(total_data_A3$component_density)
sd(total_data_A3$component_density)
ecdf(total_data_A3$component_density)(observed_A3$component_density)
total_data_A3$sd_cd <- (total_data_A3$component_density - mean(total_data_A3$component_density)) / sd(total_data_A3$component_density)
observed_A3$sd_cd <- (observed_A3$component_density - mean(total_data_A3$component_density)) / sd(total_data_A3$component_density)
(observed_A3$component_density - mean(total_data_A3$component_density)) / sd(total_data_A3$component_density)

summary(total_data_A3$number_connected_components)
sd(total_data_A3$number_connected_components)
ecdf(total_data_A3$number_connected_components)(4)
total_data_A3$sd_ncc <- (total_data_A3$number_connected_components - mean(total_data_A3$number_connected_components)) / sd(total_data_A3$number_connected_components)
observed_A3$sd_ncc <- (4 - mean(total_data_A3$number_connected_components)) / sd(total_data_A3$number_connected_components)
(4 - mean(total_data_A3$number_connected_components)) / sd(total_data_A3$number_connected_components)

summary(total_data_A3$geodesic_dist)
sd(total_data_A3$geodesic_dist)
ecdf(total_data_A3$geodesic_dist)(observed_A3$geodesic_dist)
total_data_A3$sd_gd <- (total_data_A3$geodesic_dist - mean(total_data_A3$geodesic_dist)) / sd(total_data_A3$geodesic_dist)
observed_A3$sd_gd <- (observed_A3$geodesic_dist - mean(total_data_A3$geodesic_dist)) / sd(total_data_A3$geodesic_dist)
(observed_A3$geodesic_dist - mean(total_data_A3$geodesic_dist)) / sd(total_data_A3$geodesic_dist)

summary(total_data_A3$centralization)
sd(total_data_A3$centralization)
ecdf(total_data_A3$centralization)(observed_A3$centralization)
total_data_A3$sd_cent <- (total_data_A3$centralization - mean(total_data_A3$centralization)) / sd(total_data_A3$centralization)
observed_A3$sd_cent <- (observed_A3$centralization - mean(total_data_A3$centralization)) / sd(total_data_A3$centralization)
(observed_A3$centralization - mean(total_data_A3$centralization)) / sd(total_data_A3$centralization)

summary(total_data_A3$prop_2_cores)
sd(total_data_A3$prop_2_cores)
ecdf(total_data_A3$prop_2_cores)(observed_A3$prop_2_cores)
total_data_A3$sd_p2c <- (total_data_A3$prop_2_cores - mean(total_data_A3$prop_2_cores)) / sd(total_data_A3$prop_2_cores)
observed_A3$sd_p2c <- (observed_A3$prop_2_cores - mean(total_data_A3$prop_2_cores)) / sd(total_data_A3$prop_2_cores)
(observed_A3$prop_2_cores - mean(total_data_A3$prop_2_cores)) / sd(total_data_A3$prop_2_cores)

summary(total_data_A3$transitivity)
sd(total_data_A3$transitivity)
ecdf(total_data_A3$transitivity)(observed_A3$transitivity)
total_data_A3$sd_trans <- (total_data_A3$transitivity - mean(total_data_A3$transitivity)) / sd(total_data_A3$transitivity)
observed_A3$sd_trans <- (observed_A3$transitivity - mean(total_data_A3$transitivity)) / sd(total_data_A3$transitivity)
(observed_A3$transitivity - mean(total_data_A3$transitivity)) / sd(total_data_A3$transitivity)

summary(total_data_A3$diameter)
sd(total_data_A3$diameter)
ecdf(total_data_A3$diameter)(observed_A3$diameter)
total_data_A3$sd_diam <- (total_data_A3$diameter - mean(total_data_A3$diameter)) / sd(total_data_A3$diameter)
observed_A3$sd_diam <- (observed_A3$diameter - mean(total_data_A3$diameter)) / sd(total_data_A3$diameter)
(observed_A3$diameter - mean(total_data_A3$diameter)) / sd(total_data_A3$diameter)