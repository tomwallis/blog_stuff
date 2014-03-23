# Generating data

Generating data from a probabalistic model with known parameters is a great way to test that any analysis you have written is working correctly, and to understand statistical methods more generally. In this post I'm going to show you an example of generating (simulating) data from a probabalistic model. A probabalistic model is one that is *stochastic* in that it doesn't generate the same data set each time the simulation is run (unlike a deterministic model).

The following is actually the code that I used to generate the data in [my post on importing data](TODO_link), so if you've been following this blog then you're already familiar with the output of this post. This simulated data set consisted of 5 subjects, who were shown 15 trials at each combination of 6 contrasts and 5 spatial frequencies.

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
(contrasts <- exp(seq(-5, -1, l = 6)))
```

```
## [1] 0.006738 0.014996 0.033373 0.074274 0.165299 0.367879
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
(n_trials <- 15)
```

```
## [1] 15
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
## 1      S1 0.006738 0.5        left     1
## 2      S2 0.006738 0.5        left     1
## 3      S3 0.006738 0.5        left     1
## 4      S4 0.006738 0.5        left     1
## 5      S5 0.006738 0.5        left     1
## 6      S1 0.014996 0.5        left     1
```


You can see from the first few rows of `dat` what `expand.grid` has done: it has created a data frame (called `dat`) that contains each combination of the variables entered. A call to `summary` shows us how R has usefully made factors out of string variables (subject and target side):


```r
summary(dat)
```

```
##  subject     contrast            sf        target_side      trial   
##  S1:900   Min.   :0.0067   Min.   : 0.50   left :2250   Min.   : 1  
##  S2:900   1st Qu.:0.0150   1st Qu.: 1.50   right:2250   1st Qu.: 4  
##  S3:900   Median :0.0538   Median : 4.47                Median : 8  
##  S4:900   Mean   :0.1104   Mean   :11.97                Mean   : 8  
##  S5:900   3rd Qu.:0.1653   3rd Qu.:13.37                3rd Qu.:12  
##           Max.   :0.3679   Max.   :40.00                Max.   :15
```


You can tell that something is a factor because instead of showing the summary statistics (mean, median) it just shows how many instances of each level there are.

To make the modelling a bit simpler, we're also going to create a factor of spatial frequency:


```r
dat$sf_factor <- factor(round(dat$sf, digits = 2))
summary(dat)
```

```
##  subject     contrast            sf        target_side      trial   
##  S1:900   Min.   :0.0067   Min.   : 0.50   left :2250   Min.   : 1  
##  S2:900   1st Qu.:0.0150   1st Qu.: 1.50   right:2250   1st Qu.: 4  
##  S3:900   Median :0.0538   Median : 4.47                Median : 8  
##  S4:900   Mean   :0.1104   Mean   :11.97                Mean   : 8  
##  S5:900   3rd Qu.:0.1653   3rd Qu.:13.37                3rd Qu.:12  
##           Max.   :0.3679   Max.   :40.00                Max.   :15  
##  sf_factor  
##  0.5  :900  
##  1.5  :900  
##  4.47 :900  
##  13.37:900  
##  40   :900  
## 
```


## The data model

Now that we have the data frame for the experimental variables, we want to think about how to generate a lawful (but probabalistic) relationship between the experimental variables and the outcome variable (in this case, getting a trial correct or incorrect). I am going to do this in the framework of a logistic Generalised Linear Model. 

For this data set, let's say that each "subject's" chance of getting the trial correct is a function of the contrast and the spatial frequency on the trial. I'm going to treat contrast as a continuous predictor (aka a *covariate*) and spatial frequency as a factor. I could treat both as continuous, but visual sensitivity as a function of spatial frequency is non-monotonic, so I thought this blog post would be simpler if I just treat my five levels as discrete. In a simple GLM this means that each subject will have six coefficients: an intercept, the slope of contrast, and the offset for each level of spatial frequency. 

R is pretty amazing for doing stuff in a GLM framework. For this example, we can generate the design matrix for our data frame `dat` using the `model.matrix` function:


```r
X <- model.matrix(~contrast + sf_factor, data = dat)
head(X)
```

```
##   (Intercept) contrast sf_factor1.5 sf_factor4.47 sf_factor13.37
## 1           1 0.006738            0             0              0
## 2           1 0.006738            0             0              0
## 3           1 0.006738            0             0              0
## 4           1 0.006738            0             0              0
## 5           1 0.006738            0             0              0
## 6           1 0.014996            0             0              0
##   sf_factor40
## 1           0
## 2           0
## 3           0
## 4           0
## 5           0
## 6           0
```


The formula `~ contrast + sf_factor` tells R that we want to predict something using contrast (a covariate) and additive terms of the factor `sf_factor`. If we changed the `+` to a `*` this would give us all the interaction terms too (i.e. the slope would be allowed to vary with spatial frequency). Note how our first 6 rows have all zeros for the columns of `sf_factor`: this is because all the first rows in `dat` are from sf 0.5, which here is the reference level. R has automatically dummy coded `sf_factor`, dropping the reference level.

Next we need our "true" coefficients for each subject. I will generate these as samples from a normal distribution (this is where the first *stochastic* part of our data generation comes in). But first, I will set R's random number seed so that you can produce the results described here (i.e. this will make the result deterministic). If you want stochasticity again, just comment out this line:


```r
set.seed(424242)
```


Now the coefficients:

```r
b0 <- rnorm(length(subjects), mean = -2, sd = 0.1)  # intercept
b1 <- rnorm(length(subjects), mean = 2, sd = 0.1)  # slope of contrast
b2 <- rnorm(length(subjects), mean = 1.5, sd = 0.1)  # sf 1.5
b3 <- rnorm(length(subjects), mean = 1, sd = 0.1)  # sf 4.4
b4 <- rnorm(length(subjects), mean = 0, sd = 0.1)  # sf 13
b5 <- rnorm(length(subjects), mean = -3, sd = 0.1)  # sf 40

# stick these together as a matrix:
(betas <- matrix(c(b0, b1, b2, b3, b4, b5), nrow = 5))
```

```
##        [,1]  [,2]  [,3]   [,4]     [,5]   [,6]
## [1,] -1.956 2.222 1.551 1.0265 -0.13435 -3.069
## [2,] -1.903 1.987 1.640 1.1112  0.07295 -3.121
## [3,] -1.924 2.116 1.568 1.0051  0.11721 -3.095
## [4,] -1.983 2.035 1.621 0.9456  0.09572 -2.895
## [5,] -1.958 1.961 1.353 1.0204  0.15580 -2.935
```

