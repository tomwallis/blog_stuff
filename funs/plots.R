## Script to plot the data.

library(ggplot2)
library(mgcv)

load(paste0(getwd(),'/out/contrast_data.RData'))

dat$sf_factor <- factor(dat$sf)
levels(dat$sf_factor) <- round(sort(unique(dat$sf)), digits=1) # rename levels

# first plot -------------------
fig <- ggplot(data = dat, aes(x=contrast, y=correct)) + 
  facet_grid(sf_factor ~ subject) + 
  stat_summary(fun.data = "mean_cl_boot") + 
  stat_smooth(method = "gam", family=binomial(), formula=y ~ s(x,bs="cs",k=3)) +
  scale_x_log10(name="Contrast") + 
  scale_y_continuous(name="Proportion Correct", limits=c(0,1), breaks=c(0, 0.5, 1)) + 
  theme_minimal() + 
  theme(panel.margin=unit(0.15, "inches"))
fig # this line prints the figure, and isn't necessary if you only want to save to file.

# save to figs directory:
ggsave(filename=paste0(getwd(),'/figs/performance_by_subject.pdf'),width=6, height=5)

# Second plot -------------------------------
fig <- ggplot(data = dat, aes(x=contrast, y=correct, colour=target_side, shape=target_side)) + 
  facet_grid(sf_factor ~ subject) + 
  stat_summary(fun.data = "mean_cl_boot") + 
  stat_smooth(method = "gam", family=binomial(), formula=y ~ s(x,bs="cs",k=3)) +
  scale_x_log10(name="Contrast") + 
  scale_y_continuous(name="Proportion Correct", limits=c(0,1), breaks=c(0, 0.5, 1)) + 
  scale_colour_brewer(name="Target Side",type="qual", palette=2) +
  scale_shape_discrete(name="Target Side") +
  theme_minimal() + 
  theme(panel.margin=unit(0.15, "inches"), legend.position="top") + 

# save to figs directory:
ggsave(filename=paste0(getwd(),'/figs/performance_by_side.pdf'),width=6, height=6)
