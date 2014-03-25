# Generating data

Generating data from a probabalistic model with known parameters is a great way to test that any analysis you have written is working correctly, and to understand statistical methods more generally. In this post I'm going to show you an example of generating (simulating) data from a probabalistic model. A probabalistic model is one that is *stochastic* in that it doesn't generate the same data set each time the simulation is run (unlike a deterministic model).

The following is actually the code that I used to generate the data in [my post on importing data](TODO_link), so if you've been following this blog then you're already familiar with the output of this post. This simulated data set consisted of 5 subjects, who were shown 20 trials at each combination of 7 contrasts and 5 spatial frequencies.

## The predictor variables

First we set up all the predictor variables (independent or experimental variables) we're interested in.

### Variable vectors


```r
(subjects <- paste0("S", 1:5))
```

```
## [1] "S1" "S2" "S3" "S4" "S5"
```


As we've discussed, the `paste0` command is for concatenating (sticking together) strings. The command above creates a character vector of five strings, starting with "S1".


```r
(contrasts <- exp(seq(-6, -1, l = 7)))
```

```
## [1] 0.002479 0.005704 0.013124 0.030197 0.069483 0.159880 0.367879
```


This creates a vector of length 6 containing log-spaced contrast values... and so on for other variables:


```r
(sfs <- exp(seq(log(0.5), log(40), l = 5)))
```

```
## [1]  0.500  1.495  4.472 13.375 40.000
```

```r
target_sides <- c("left", "right")
(n_trials <- 20)
```

```
## [1] 20
```


### Combining the variables

Now that we've set up the independent variables from the experiment, we want to create a data frame with one row for each combination of the variables for each subject. We can do this easily with R's `expand.grid` command.


```r
dat <- expand.grid(subject = subjects, contrast = contrasts, sf = sfs, target_side = target_sides, 
    trial = 1:n_trials)
head(dat)
```

```
##   subject contrast  sf target_side trial
## 1      S1 0.002479 0.5        left     1
## 2      S2 0.002479 0.5        left     1
## 3      S3 0.002479 0.5        left     1
## 4      S4 0.002479 0.5        left     1
## 5      S5 0.002479 0.5        left     1
## 6      S1 0.005704 0.5        left     1
```


You can see from the first few rows of `dat` what `expand.grid` has done: it has created a data frame (called `dat`) that contains each combination of the variables entered. A call to `summary` shows us how R has usefully made factors out of string variables (subject and target side):


```r
summary(dat)
```

```
##  subject      contrast            sf        target_side      trial      
##  S1:1400   Min.   :0.0025   Min.   : 0.50   left :3500   Min.   : 1.00  
##  S2:1400   1st Qu.:0.0057   1st Qu.: 1.50   right:3500   1st Qu.: 5.75  
##  S3:1400   Median :0.0302   Median : 4.47                Median :10.50  
##  S4:1400   Mean   :0.0927   Mean   :11.97                Mean   :10.50  
##  S5:1400   3rd Qu.:0.1599   3rd Qu.:13.37                3rd Qu.:15.25  
##            Max.   :0.3679   Max.   :40.00                Max.   :20.00
```


You can tell that something is a factor because instead of showing the summary statistics (mean, median) it just shows how many instances of each level there are.

To make the modelling a bit simpler, we're also going to create a factor of spatial frequency:


```r
dat$sf_factor <- factor(round(dat$sf, digits = 2))
summary(dat)
```

```
##  subject      contrast            sf        target_side      trial      
##  S1:1400   Min.   :0.0025   Min.   : 0.50   left :3500   Min.   : 1.00  
##  S2:1400   1st Qu.:0.0057   1st Qu.: 1.50   right:3500   1st Qu.: 5.75  
##  S3:1400   Median :0.0302   Median : 4.47                Median :10.50  
##  S4:1400   Mean   :0.0927   Mean   :11.97                Mean   :10.50  
##  S5:1400   3rd Qu.:0.1599   3rd Qu.:13.37                3rd Qu.:15.25  
##            Max.   :0.3679   Max.   :40.00                Max.   :20.00  
##  sf_factor   
##  0.5  :1400  
##  1.5  :1400  
##  4.47 :1400  
##  13.37:1400  
##  40   :1400  
## 
```


## The data model

Now that we have the data frame for the experimental variables, we want to think about how to generate a lawful (but probabalistic) relationship between the experimental variables and the outcome variable (in this case, getting a trial correct or incorrect). I am going to do this in the framework of a logistic Generalised Linear Model. 

For this data set, let's say that each "subject's" chance of getting the trial correct is a function of the contrast and the spatial frequency on the trial. I'm going to treat contrast as a continuous predictor (aka a *covariate*) and spatial frequency as a factor. I could treat both as continuous, but visual sensitivity as a function of spatial frequency is non-monotonic, so I thought this blog post would be simpler if I just treat my five levels as discrete. In a simple GLM this means that each subject will have six coefficients: an intercept, the slope of contrast, and the offset for each level of spatial frequency. 

### Design matrix

R is pretty amazing for doing stuff in a GLM framework. For this example, we can generate the design matrix for our data frame `dat` using the `model.matrix` function:


```r
X <- model.matrix(~log(contrast) + sf_factor, data = dat)
head(X)
```

```
##   (Intercept) log(contrast) sf_factor1.5 sf_factor4.47 sf_factor13.37
## 1           1        -6.000            0             0              0
## 2           1        -6.000            0             0              0
## 3           1        -6.000            0             0              0
## 4           1        -6.000            0             0              0
## 5           1        -6.000            0             0              0
## 6           1        -5.167            0             0              0
##   sf_factor40
## 1           0
## 2           0
## 3           0
## 4           0
## 5           0
## 6           0
```


The formula `~ log(contrast) + sf_factor` tells R that we want to predict something using contrast (a covariate) and additive terms of the factor `sf_factor`. If we changed the `+` to a `*` this would give us all the interaction terms too (i.e. the slope would be allowed to vary with spatial frequency). Note how our first 6 rows have all zeros for the columns of `sf_factor`: this is because all the first rows in `dat` are from sf 0.5, which here is the reference level. R has automatically dummy coded `sf_factor`, dropping the reference level.

### Coefficients (parameters)

Next we need our "true" coefficients for each subject. I will generate these as samples from a normal distribution (this is where the first *stochastic* part of our data generation comes in). But first, I will set R's random number seed so that you can produce the results described here (i.e. this will make the result deterministic). If you want stochasticity again, just comment out this line:


```r
set.seed(424242)
```


Now the coefficients:

```r
b0 <- rnorm(length(subjects), mean = 7, sd = 0.2)  # intercept
b1 <- rnorm(length(subjects), mean = 2, sd = 0.2)  # slope of contrast
b2 <- rnorm(length(subjects), mean = 2, sd = 0.2)  # sf 1.5
b3 <- rnorm(length(subjects), mean = 1.5, sd = 0.2)  # sf 4.4
b4 <- rnorm(length(subjects), mean = 0, sd = 0.2)  # sf 13
b5 <- rnorm(length(subjects), mean = -2, sd = 0.2)  # sf 40

# stick these together as a matrix, with each row a subject:
print(betas <- matrix(c(b0, b1, b2, b3, b4, b5), nrow = 5))
```

```
##       [,1]  [,2]  [,3]  [,4]    [,5]   [,6]
## [1,] 7.088 2.445 2.101 1.553 -0.2687 -2.138
## [2,] 7.194 1.974 2.279 1.722  0.1459 -2.243
## [3,] 7.152 2.232 2.136 1.510  0.2344 -2.189
## [4,] 7.034 2.070 2.242 1.391  0.1914 -1.790
## [5,] 7.085 1.922 1.705 1.541  0.3116 -1.871
```


## Generating predictions 

To generate predictions in the linear space of the GLM, we just take the dot product of the design matrix and the betas for each subject:


```r
eta <- rep(NA, length = nrow(dat))
for (i in 1:length(subjects)) {
    # for each subject
    this_subj <- levels(dat$subject)[i]  # which subject?
    subj_rows <- dat$subject == this_subj  # which rows belong to this subject?
    
    # create a design matrix, and pull out the betas for this subject:
    this_X <- model.matrix(~log(contrast) + sf_factor, data = dat[subj_rows, 
        ])
    this_betas <- betas[i, ]
    
    # mult, stick into eta:
    eta[subj_rows] <- this_X %*% this_betas
}

# stick eta into dat:
dat$eta <- eta
```


Now we want to turn the linear predictor `eta` into a probability that ranges from 0.5 (chance performance on the task) to 1. To do this we're going to use one of the custom link functions in the `psyphy` package (TODO REF) for fitting psychophysical data in R.


```r
library(psyphy)
links <- mafc.weib(2)

dat$p <- links$linkinv(dat$eta)
```


Test that parameters are in a decent range by plotting:


```r
library(ggplot2)
fig <- ggplot(dat, aes(x = contrast, y = p)) + geom_line() + facet_grid(sf_factor ~ 
    subject) + coord_cartesian(ylim = c(0.45, 1.05)) + scale_x_log10() + scale_y_continuous(breaks = c(0.5, 
    0.75, 1)) + theme_minimal()
fig
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 


Finally, we want to generate a binary outcome (success or failure, usually denoted 1 and 0) with probability `p` for each trial. We do this using R's `rbinom` function, which generates random samples from the binomial distribution:


```r
dat$y <- rbinom(nrow(dat), 1, prob = dat$p)
summary(dat)
```

```
##  subject      contrast            sf        target_side      trial      
##  S1:1400   Min.   :0.0025   Min.   : 0.50   left :3500   Min.   : 1.00  
##  S2:1400   1st Qu.:0.0057   1st Qu.: 1.50   right:3500   1st Qu.: 5.75  
##  S3:1400   Median :0.0302   Median : 4.47                Median :10.50  
##  S4:1400   Mean   :0.0927   Mean   :11.97                Mean   :10.50  
##  S5:1400   3rd Qu.:0.1599   3rd Qu.:13.37                3rd Qu.:15.25  
##            Max.   :0.3679   Max.   :40.00                Max.   :20.00  
##  sf_factor         eta               p               y       
##  0.5  :1400   Min.   :-9.717   Min.   :0.500   Min.   :0.00  
##  1.5  :1400   1st Qu.:-2.925   1st Qu.:0.526   1st Qu.:1.00  
##  4.47 :1400   Median : 0.286   Median :0.868   Median :1.00  
##  13.37:1400   Mean   : 0.004   Mean   :0.776   Mean   :0.77  
##  40   :1400   3rd Qu.: 3.240   3rd Qu.:1.000   3rd Qu.:1.00  
##               Max.   : 7.500   Max.   :1.000   Max.   :1.00
```


### Converting from "y" (correct / incorrect) to "response"

Here I convert the binary correct / incorrect response above into a "left" or "right" response by the simulated subject on each trial. Note that you wouldn't normally do this, I'm just doing it for demo purposes for the data import post.


```r
dat$response <- "left"
dat$response[dat$target_side == "right" & dat$y == 1] <- "right"  # correct on right
dat$response[dat$target_side == "left" & dat$y == 0] <- "right"  # wrong on left
dat$response <- factor(dat$response)
```


## Saving the data 

Now I'm going to save a subset of the data here to a series of .csv files. These are the files we imported in [my post on importing data](TODO_link). First, to make the data set look a little more realistic I'm going to shuffle the row order (as if I randomly interleaved trials in an experiment). 


```r
new_rows <- sample.int(nrow(dat))
dat <- dat[new_rows, ]
```


### Create a unique id for each trial
I'm going to add a unique identifier (UUID) to each trial. **This is a good thing to do in your experiment script**. It makes it easier to, for example, check that some data set stored in a different table (e.g. eye tracking or brain imaging data) synchs up with the correct psychophysical trial.


```r
library(uuid)
ids <- rep(NA, length = nrow(dat))
for (i in 1:length(ids)) ids[i] <- UUIDgenerate()

dat$unique_id <- ids
```


### Writing to a file
To do this I'm going to use the `paste0` command, which you should already be familiar with from the data import post. This allows you to stick strings (text) together.
On the line with `paste0`, the first part gives us the project working directory, then we go into the `data` directory and finally we create the filename from the subject name.


```r
for (i in 1:length(subjects)) {
    # for each subject
    this_subj <- levels(dat$subject)[i]  # which subject?
    
    # use the subset command to subset the full data frame and remove some
    # variables:
    this_dat <- subset(dat, subject == this_subj, select = c(-trial:-y))
    
    output_file <- paste0(getwd(), "/data/data_", this_subj, ".csv")
    write.table(this_dat, file = output_file, row.names = FALSE, sep = ",")
}
```

```
## Warning: cannot open file
## '/Users/tomwallis/Dropbox/Projects/blog_example/blog_posts/data/data_S1.csv':
## No such file or directory
```

```
## Error: cannot open the connection
```


## Summing up

That's one way to generate data from an underlying probability model. I've used it to generate some data for my previous blog post, but this is a really great thing to know how to do. It's useful for testing your analysis code (if you don't get back the parameters you put in, you know something is wrong). I also found I learned a lot about statistics more generally by simulating various tests and models.
