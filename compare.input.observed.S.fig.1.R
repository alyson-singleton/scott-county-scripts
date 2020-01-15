# load libraries
library(ggplot2)

# load observed data and format to be plot
# (injection-specific degree distribution)
quants <- c(140, 54, 32, 24, 19, 16, 10, 8, 13, 8, 5, 4, 5, 3, 
            3, 3, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 
            0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0)
# make data frame called dist.df
dist_df <- data.frame(quants)
# add index (noting the degree value)
dist_df$Degree <- seq.int(nrow(dist_df))
# add column of proportion of total
dist_df$prop <- quants/360
# rename column as "Count"
dist_df$Count <- dist_df$quants

# build bins!
dist_df$bin_probs <- c(0.389, 
                       0.150, 
                       0.089, 
                       0.067, 
                       0.049, 0.049,
                       0.027, 0.027, 0.027, 0.027, 
                       0.0106, 0.0106, 0.0106, 0.0106, 0.0106, 0.0106,
                       0.00158, 0.00158, 0.00158, 0.00158, 0.00158, 0.00158, 0.00158, 0.00158, 0.00158, 0.00158, 0.00158, 0.00158, 0.00158, 0.00158,
                       0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045,
                       0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045, 0.00045)

# basic line plot of observed distribution
ggplot(dist_df) + geom_line(aes(x=Degree, y=Count), color="darkgrey") #+ geom_line(aes(x=deg, y=bin_probs), linetype = "dotted", color="black", size=1)
# basic histogram plot of observed distribution
ggplot(data=dist_df,aes(x=Degree, y=Count)) + geom_histogram(stat="identity", fill="slategrey")

# plot the simulation's input degree distribution and plot the observed for comparison
# SFig 1

ggplot(data=dist_df) + 
  geom_bar(aes(x=Degree, y=prop, fill= "#5DADE2"), stat="identity", size=0.7) +
  geom_step(aes(x=Degree-.5, y=bin_probs, col="black"), size=0.7, alpha=0.75) +
  labs(x = "Degree", y = "Proportion of PWID in observed risk network") +
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
        legend.position = c(.79, .747), 
        legend.title = element_blank(),
        legend.box.just = "left",
        legend.text = element_text(size = 14)) +
        scale_color_manual(values=c("black","white"), labels=c("Input Distribution", "Empirical Distribution")) +
        scale_fill_manual(values=c("#5DADE2","#5DADE2"), labels=c("Empirical Distribution", "Empirical Distribution"))
