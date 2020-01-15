# load libraries
library(car)
library(ggplot2)
library(lmtest)
library(tidyverse)
library(psycho)
library(reshape2)

# set directory
setwd("~/Desktop/research/SC_inj_net_dynamics/scripts")
# load data
degree_bins <- read.csv("degreebincounts.csv", header = FALSE)

# pull only the rows that correspond with the rows we selected based on our conditions 
# conditions : number of nodes in main component, number of edges, initial infection in main component
degree_bins$key <- 1:(nrow(degree_bins))
# call new data set trial
trial <- degree_bins[total_data_A3$key,]
# remove key column
trial$key <- NULL
# add new index column
trial$seed <- 1:nrow(trial)
# name columns
colnames(trial) <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, "seed")

# melt trial into long format
mm = melt(trial, id=c('seed'))
mm$variable=as.numeric(levels(mm$variable))[mm$variable]

# load observed data and format to be plot
observed.df <- data.frame(c(0, 180, 62, 33, 25, 20, 19,  12, 8, 14, 7, 4, 7, 6, 3, 2, 4, 0,
                            2, 0, 2, 0, 2, 0, 0, 2, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1,
                            0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1))
observed.df$variable <- c(0:56)
colnames(observed.df) <- c("value", "variable")

# plot each of the simulation degree distributions with observed over the top
# SFig 2
ggplot() + geom_line(data = mm, aes(x = variable, y = value, group=as.factor(as.numeric(seed)), color = "grey"), alpha = 0.05) +
  #geom_line(data = No_Intervention_Infections_Summary, aes(x = t, y = Mean), color = "darkslategrey", size = 0.75) +
  geom_line(data = observed.df, aes(x = variable, y = value, color = "#5DADE2"), size = 0.85) +
  theme(plot.title=element_text(family="", size=20, face="bold", hjust = 0.5),
        axis.text.x=element_text(size=14), 
        axis.text.y=element_text(size=14),
        axis.title.x=element_text(size=18),
        axis.title.y=element_text(size=18),
        axis.line=element_line(colour="black"),
        panel.background = element_blank(),
        panel.grid = element_line(colour="lightgrey", size=0.3),
        legend.key = element_blank(), 
        legend.background = element_rect(colour="slategrey", fill = 'white'), 
        legend.position = c(.69, .747), 
        legend.title = element_blank(),
        legend.box.just = "left",
        legend.text = element_text(size = 14)) +
  scale_color_manual(values=c("#5DADE2","grey"), labels=c("Empirical Distribution", "Realized Simulation Distributions")) +
  labs(x = "Realized degree", y = "Number of individuals") +
  xlim(0, 60) +
  ylim(0, 200)
