## this is a script version to do the data import from the blog post.

dat <- data.frame() # create an empty data frame.
for (i in 1 : 5){
  file <- paste0(getwd(),"/data/data_S", i, ".csv")
  this_dat <- read.csv(file = file) # read the subject's file, put in a data frame called this_dat
  dat <- rbind(dat, this_dat) # append to larger data frame  
}

dat$correct <- 0 # initialises the variable "correct" with all zeros.
dat$correct[dat$target_side == dat$response] <- 1 # logical indexing; if target == response, returns TRUE
summary(dat)

# save data to an output file:
save(dat, file = paste0(getwd(), "/out/contrast_data.RData"))
