# load libraries
library(car)
library(ggplot2)
library(lmtest)
library(tidyverse)
library(psycho)
library(reshape2)
library(GGally)
library(corrplot)

# load data
setwd("~/Desktop/research/SC_inj_net_dynamics/scripts/cleaned.1.15.2020")
total_data_A3 <- read.csv("A3_conditions_ten_percent.csv")
observed_A3 <- read.csv("A3_observed.csv")

# double check removal of initial infections not in main component
total_data_A3 <- total_data_A3[!(total_data_A3$cumulative_incidence<=20),]

# double check removal of extra runs, leave 1000
total_data_A3 = total_data_A3[1:1000,]

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

# Summary of Simulated Network Statistics for Velocity Outcomes

summary(total_data_A3$totalnodecount)
sd(total_data_A3$totalnodecount)
summary(total_data_A3$totaledgecount)
sd(total_data_A3$totaledgecount)
summary(total_data_A3$CCedgescount)
sd(total_data_A3$CCedgescount)
summary(total_data_A3$cumulative_incidence)
sd(total_data_A3$cumulative_incidence)
summary(total_data_A3$year_max)
sd(total_data_A3$year_max)
summary(total_data_A3$ten_inf_ind)
sd(total_data_A3$ten_inf_ind)

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

# Velocity Data Cleaning, Addition of Velocity Outcomes to Main Data Set
#   No need to rerun this section, now saved/stored in "total_data_A3" data set. Remains for reference.

# edits to observed network structural measurements 
observed <- read.table("observed_SC_network_metrics_output.txt")
observed <- observed[1,]
observed <- observed[,2:10]
colnames(observed) <- c("betweenness_centrality", "random_walk_betweenness_centrality", "component_size", "component_density", "geodesic_dist", "centralization", "prop_2_cores", "transitivity", "diameter")

# load observed network outcomes 
observed.velocity <- read.table("~/Desktop/research/SC_inj_network_dynamics/scripts/incidence.tests/observed_incidence_velocity_outcomes.txt")
colnames(observed.velocity) <- c("cumulative_incidence", "one_max", "one_max_index", "six_max", "six_max_index_late", "six_max_index_early", "year_max", "year_max_index_late", "year_max_index_early", "first_year_count", "first_year_max", "last_year_count", "last_year_max")

# combine the two tables
observed <- cbind(observed, observed.velocity)

# store/save/export for future use
#write.csv(observed_A3, "A3_observed.csv")

# load time until ten infections data to main data set
ten_inf_ind <- read.table("~/Desktop/research/SC_inj_net_dynamics/scripts/incidence.tests/ten_inf_outcome.txt")
# remove first row
ten_inf_ind <- ten_inf_ind[2:1201,]
# remove uncessary columns
colnames(ten_inf_ind) <- c("run", "ten_inf_ind")
# add time until ten infections data to main data set
total_data_A3 <- merge(total_data_A3, ten_inf_ind, by = "run")

# remove initial infections not in main component
total_data_A3 <- total_data_A3[!(total_data_A3$cumulative_incidence<=20),]

# remove runs where main component size was outside ten percent of observed value
total_data_A3 <- total_data_A3[!(total_data_A3$totalnodecount<=378),]
total_data_A3 <- total_data_A3[!(total_data_A3$totalnodecount>=462),]

# remove runs where number of total ties was outside ten percent of observed value
total_data_A3 <- total_data_A3[!(total_data_A3$totaledgecount<=822),]
total_data_A3 <- total_data_A3[!(total_data_A3$totaledgecount>=1004),]

# store/save/export for future use
#write.csv(total_data_A3, "A3_conditions_ten_percent.csv")

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

# Define Outcome for Visualizations

# different outcomes, switch when building graphs of different outcomes
# options: cumulative_incidence, year_max, ten_inf_ind
sim.outcome.of.interest <- as.numeric(total_data_A3$cumulative_incidence)
observed.outcome.of.interest <- observed_A3$cumulative_incidence

# switch y-axis title
yy <- "Cumulative incident HIV infections"
#yy <- "Largest number of incident infections in twelve time-steps"
#yy <- "Number of months elapsed until ten incident infections"

# pairs plots for basic investigation of structural characteristics relationship to velocity outcomes
ggpairs(total_data_A3, columns=c("betweenness_centrality","component_size","component_density","geodesic_dist",
                                 "centralization", "prop_2_cores", "transitivity", "diameter", "cumulative_incidence", "year_max", "ten_inf_ind"),
        diag=list(continuous="density", discrete="bar"), axisLabels="show", size = 3)

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

## GGPlots w Scott County Comparison Available

## GGPlot Average Betweenness Centrality
p1 <- ggplot(total_data_A3, aes(x=betweenness_centrality, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  geom_point(aes(x = observed_A3$betweenness_centrality, y = observed.outcome.of.interest),  col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) + 
  labs(title="(d)", x = "Average betweenness centrality", y = "") +
  theme(plot.title=element_text(size=16, hjust = -0.05),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Component Size
p3 <- ggplot(total_data_A3, aes(x=component_size, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  geom_point(aes(x = observed_A3$component_size, y = observed.outcome.of.interest),  col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) + 
  labs(title="(b)", x = "Size of main component", y = "") +
  theme(plot.title=element_text(size=16, hjust = -0.05),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Number Connected Components
p4 <- ggplot(total_data_A3, aes(x=number_connected_components, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  geom_point(aes(x = 4, y = observed.outcome.of.interest),  col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) + 
  labs(title="(a)", x = "Number of connected components", y = yy) +
  theme(plot.title=element_text(size=16, hjust = -0.05),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Average Component Density
p5 <- ggplot(total_data_A3, aes(x=component_density, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  geom_point(aes(x = observed_A3$component_density, y = observed.outcome.of.interest),  col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) + 
  labs(title="(c)", x = "Density", y = yy) +
  theme(plot.title=element_text(size=16, hjust = -0.05),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Average Geodesic Distance
p6 <- ggplot(total_data_A3, aes(x=geodesic_dist, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  geom_point(aes(x = observed_A3$geodesic_dist, y = observed.outcome.of.interest),  col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) + 
  labs(title="(e)", x = "Average geodesic distance", y = yy) +
  theme(plot.title=element_text(size=16, hjust = -0.05),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Average Centralization
p7 <- ggplot(total_data_A3, aes(x=centralization, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey", fullrange = T) + 
  expand_limits(x = 0, y = 0) +
  geom_point(aes(x = observed_A3$centralization, y = observed.outcome.of.interest),  col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) + 
  labs(title="(a)", x = "Centralization", y = yy) +
  theme(plot.title=element_text(size=16, hjust = -0.05),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Proportion of 2-Cores
p8 <- ggplot(total_data_A3, aes(x=prop_2_cores, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  geom_point(aes(x = observed_A3$prop_2_cores, y = observed.outcome.of.interest),  col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) + 
  labs(title="(h)", x = "Proportion of agents in 2-cores", y = "") +
  theme(plot.title=element_text(size=16, hjust = -0.05),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Average Transitivity
p9 <- ggplot(total_data_A3, aes(x=transitivity, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey", fullrange = T) + 
  expand_limits(x = 0, y = 0) +
  #scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
  geom_point(aes(x = observed_A3$transitivity, y = observed.outcome.of.interest),  col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) + 
  labs(title="(b)", x = "Transitivity", y = yy) +
  theme(plot.title=element_text(size=16, hjust = -0.05),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Diameter
p10 <- ggplot(total_data_A3, aes(x=diameter, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  geom_point(aes(x = observed_A3$diameter, y = observed.outcome.of.interest),  col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) + 
  labs(title="(f)", x = "Diameter", y = "") +
  theme(plot.title=element_text(size=16, hjust = -0.05),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))


## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

## Scatterplots of Metrics Only on TITAN Sim Networks (empiric value unavailable)

## GGPlot Average Degree
p11 <- ggplot(total_data_A3, aes(x=average_degree, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="") +
  theme(plot.title=element_text(family="", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=8), 
        axis.text.y=element_text(size=8),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Maximum Degree
p12 <- ggplot(total_data_A3, aes(x=maximum_degree, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="(a)", x = "Degree centrality of the initial infection", y = yy) +
  theme(plot.title=element_text(size=16, hjust = -0.125),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot II Betweenness Centrality
p13 <- ggplot(total_data_A3, aes(x=ii_betweenness_centrality, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="(b)", x = "Betweenness centrality of the initial infection", y="") +
  theme(plot.title=element_text(size=16, hjust = -0.125),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot II Closeness Centrality
p14 <- ggplot(total_data_A3, aes(x=ii_closeness_centrality, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="", x = "II Closeness Centrality", y = yy) +
  theme(plot.title=element_text(family="Times New Roman", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=8), 
        axis.text.y=element_text(size=8),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot II Eigenvector Centrality
p15 <- ggplot(total_data_A3, aes(x=ii_eigenvector_centrality, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="", x = "II Eigenvector Centrality", y = yy) +
  theme(plot.title=element_text(family="Times New Roman", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=8), 
        axis.text.y=element_text(size=8),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Total Node Count
p16 <- ggplot(total_data_A3, aes(x=totalnodecount, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="", x = "Total Node Count", y = yy) +
  theme(plot.title=element_text(family="Times New Roman", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=8), 
        axis.text.y=element_text(size=8),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot Total Edge Count
p17 <- ggplot(total_data_A3, aes(x=totaledgecount, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="", x = "Total Edge Count", y = yy) +
  theme(plot.title=element_text(family="Times New Roman", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=8), 
        axis.text.y=element_text(size=8),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot CC Node Count
p18 <- ggplot(total_data_A3, aes(x=CCnodescount, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="", x = "CC Node Count", y = yy) +
  theme(plot.title=element_text(family="Times New Roman", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=8), 
        axis.text.y=element_text(size=8),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot CC Edge Count
p19 <- ggplot(total_data_A3, aes(x=CCedgescount, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="", x = "CC Edge Count", y = yy) +
  theme(plot.title=element_text(family="Times New Roman", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## GGPlot II Geodesic Distance
p20 <- ggplot(total_data_A3, aes(x=ii_geodesic_distance, y=sim.outcome.of.interest)) + 
  geom_point(color="grey") +
  geom_smooth(method ="lm", color="slategrey") + 
  #geom_point(aes(x = observed$diameter, y = 183),  col="black", fill="#608BF7", size=3.5, stroke = 0.8, shape=21, show.legend=TRUE) + 
  labs(title="(c)", x = "Geodesic distance of the initial infection", y="") +
  theme(plot.title=element_text(size=16, hjust = -0.125),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title=element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.8, 0.15))

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

# Build Multiplots for Main Manuscript

# load multiplot function found online
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

# plots of main outcome, main structural network charactersitics
# order plots to match general manuscript order, cumulative incidence
multiplot(p4, p5, p6, p7, p9, p3, p1, p10, p8, cols=2)

# plots for secondary, velocity outcomes, ten_inc_inf & year_max
# only initial infection characteristics
#   maximum_degree, ii_betweenness_centrality, ii_geodesic_distance
multiplot(p12, p13, p20, cols=3)
