# load libraries
library(car)
library(ggplot2)
library(lmtest)
library(tidyverse)
library(psycho)
library(ggplot2)
library(reshape2)
library(dplyr)

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

setwd("~/Desktop/research/SC_inj_net_dynamics/scripts")

# load data
total_data_A3 <- read.csv("A3_conditions_ten_percent.csv")
observed_A3 <- read.csv("A3_observed.csv")

# reduce to only standardized data
all_sd_data <- total_data_A3[,26:34]
# add a key for merge
all_sd_data$run <- seq.int(nrow(all_sd_data))
# rename columns for nice visual
colnames(all_sd_data) <- c("Average\nbetweenness\ncentrality", "Size of\nmain\ncomponent", "Density", "Number of\nconnected\ncomponents", "Average\ngeodesic\ndistance", "Centralization", "Porportion of\nagents in\n2-cores", "Transitivity", "Diameter", "run")

# reduce to only standardized data
observed_sd <- observed_A3[,27:35]
# add a key for merge
observed_sd$run <- seq.int(nrow(observed_sd))
# rename columns for nice visual
colnames(observed_sd) <- c("Average\nbetweenness\ncentrality", "Size of\nmain\ncomponent", "Density", "Number of\nconnected\ncomponents", "Average\ngeodesic\ndistance", "Centralization", "Porportion of\nagents in\n2-cores", "Transitivity", "Diameter", "run")

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

# Build Figure 1

# remove Transitivity and Centralization for nicer visual (otherwise smushed)
all_sd_data$Transitivity <- NULL
observed_sd$Transitivity <- NULL
all_sd_data$Centralization <- NULL
observed_sd$Centralization <- NULL

# melt simulated data into long data format 
mm = melt(all_sd_data, id=c('run'))
# melt observed data into long data format 
mo = melt(observed_sd, id=c('run'))

# plot melted sets so all boxplots are on the same, standardized set of axis
ggplot()+geom_boxplot(aes(x=paste(mm$variable,sep="_"), y=mm$value), fill="lightgrey") + 
  geom_point(aes(x=paste(mo$variable,sep="_"), y=mo$value), col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) +
  labs(x= "Network Measures", y = "Standardized Value") +
  theme(plot.title=element_text(family="Times New Roman", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title= element_text(size=4),#element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.2, 0.87))

## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________
## _____________________________________________________________________________________________________________________________

# Transitivity and Centralization boxplots
# used for Epidemics7 poster

# reload with transitivity and centralization included

total_data_A3 <- read.csv("A3_conditions_ten_percent.csv")
observed_A3 <- read.csv("A3_observed.csv")

# reduce to only standardized data
all_sd_data <- total_data_A3[,26:34]
# add a key for merge
all_sd_data$run <- seq.int(nrow(all_sd_data))
# rename columns for nice visual
colnames(all_sd_data) <- c("Average\nbetweenness\ncentrality", "Size of\nmain\ncomponent", "Density", "Number of\nconnected\ncomponents", "Average\ngeodesic\ndistance", "Centralization", "Porportion of\nagents in\n2-cores", "Transitivity", "Diameter", "run")

# reduce to only standardized data
observed_sd <- observed_A3[,27:35]
# add a key for merge
observed_sd$run <- seq.int(nrow(observed_sd))
# rename columns for nice visual
colnames(observed_sd) <- c("Average\nbetweenness\ncentrality", "Size of\nmain\ncomponent", "Density", "Number of\nconnected\ncomponents", "Average\ngeodesic\ndistance", "Centralization", "Porportion of\nagents in\n2-cores", "Transitivity", "Diameter", "run")

# remove all values besides Transitivity and Centralization for seperate visual of those two
all_sd_data$`Average\nbetweenness\ncentrality` <- NULL
observed_sd$`Average\nbetweenness\ncentrality` <- NULL
all_sd_data$`Size of\nmain\ncomponent` <- NULL
observed_sd$`Size of\nmain\ncomponent` <- NULL
all_sd_data$Density <- NULL
observed_sd$Density <- NULL
all_sd_data$`Number of\nconnected\ncomponents` <- NULL
observed_sd$`Number of\nconnected\ncomponents` <- NULL
all_sd_data$`Average\ngeodesic\ndistance` <- NULL
observed_sd$`Average\ngeodesic\ndistance` <- NULL
all_sd_data$`Prop 2 Cores` <- NULL
observed_sd$`Prop 2 Cores` <- NULL
all_sd_data$Diameter <- NULL
observed_sd$Diameter <- NULL
all_sd_data$`Porportion of\nagents in\n2-cores` <- NULL
observed_sd$`Porportion of\nagents in\n2-cores` <- NULL

# melt just centralization and transitivity data
mm = melt(all_sd_data, id=c('run'))
mo = melt(observed_sd, id=c('run'))

# plot melted sets so all boxplots are on the same, standardized set of axis
ggplot()+geom_boxplot(aes(x=paste(mm$variable,sep="_"), y=mm$value), fill="lightgrey") + 
  geom_point(aes(x=paste(mo$variable,sep="_"), y=mo$value), col="black", fill="#5DADE2", size=5, stroke = 0.7, shape=21, show.legend=TRUE) +
  labs(x= "", y = "") +
  theme(plot.title=element_text(family="Times New Roman", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=18), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=15),
        axis.title.y=element_text(size=15),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.2),
        legend.title= element_text(size=4),#element_blank(),
        legend.text=element_text(size=8),
        legend.background = element_rect(fill="white", 
                                         size=0.5, linetype="solid", colour ="black"),
        legend.position=c(0.2, 0.87))
