# Importing data

In this post, I will demonstrate one way to import and collate a data set (using the R environment). This is a follow up to [a post](http://tomwallis.info/2014/01/09/a-workflow-principle-avoiding-humans-touching-data/) in which I argued that a good principle for reproducible research is to avoid humans touching data. That is, once the data from the experiment are saved we want them to be "read only" and never altered by a human in some undocumented way (such as editing in a spreadsheet). 

Using R is not the only way to do the following, and I would encourage you to replicate these steps in the environment of your choice. If your scientific computing environment makes following what I do here really hard, maybe you should consider switching...

## Data set

First, we need a data set. To make this more interesting let's build on a classic paper from vision science. 

Imagine we've conducted an experiment similar to the classic Campbell & Robson (1968)^1 study but with a few modifications. As a participant in our experiment, you're seated in front of a monitor showing a grey screen. You're going to be shown a sequence of trials, and for each trial you make a response with a button press. 
On each trial you are asked to keep your eyes on a small dot on the centre of the screen. On each trial, a pattern of dark-and-light stripes (a *grating*) is shown on one side of the screen (left or right of your eye position). The computer randomly decides whether to present the grating on the left or on the right (the other side just stays as the grey background). You have to respond either "grating on the left" or "grating on the right" -- you can't say "I don't know". The computer waits for your response before showing the next trial. 
We are going to vary both the *contrast* of the grating pattern (how different from grey the dark and light stripes are) and also the *spatial frequency* of the pattern (how wide the bars are) over trials.

If the contrast is so low that you can't see the grating, your responses across many trials will be near chance performance (here 50% correct). If the grating is really easy to see, your performance will be near 100%. We determine how your performance on the task changes as a function of contrast, for each spatial frequency tested.

We've tested 5 subjects in this experiment, showing them 7 contrasts at 5 spatial frequencies, with the targets equally on the left and right. They did 20 trials for each condition (so each subject did 7 * 5 * 20 * 2 = 1400 trials). Let's say that our experiment program saves the data as a `.csv` file in our project's `/data/` directory. We have one `.csv` file per subject, and one of them might look something like this when opened in a text editor:

```
TODO example image of text file.
```

A few things to notice here: each comma `,` in the file denotes a new column, and each new line denotes a row. Secondly, note that there's a header row: the first line of the file contains column names for our variables. 

Finally, notice how our `target_side` and `response` columns contain text strings (`left` and `right`). The reason I've done this is that it makes the data easily human-readable. It's obvious what the entries mean (imagine if instead `target_side` could be either 0 or 1). This can be used to great effect to avoid needing a data key later. 

## Installing R

This couldn't be simpler. Go [here](http://cran.r-project.org/) and get the right binary for your system, install it, then immediately go [here](http://www.rstudio.com/) and get RStudio, which is awesome. To follow along with my stuff here, you can install any packages I use (the `library()` calls in future posts) via RStudio's "Packages" tab.

While I'm going to demonstrate this stuff using R, I would encourage you to follow along in your package of choice. I'd be interested to know how easy / hard it is to duplicate this stuff in other environments (for example, last I used Matlab handling `.csv` files with mixed numeric and text was a massive pain).

## Reading each file into R and putting them together

Now we want to read each subject's data file into R, then stick the files together to create one big data file. 

### The paste0 command 
To do this, I'm going to make use of the `paste` command, which allows you to concatenate (stick together) strings. Actually, I'm going to use the `paste0` command, which is a shortcut for `paste`. By default `paste` adds a space between each pasted item, which we usually don't want. `paste0` just puts together the items you give it. For example:


```r
paste0("A text string", 42, ", another text string")
```

```
## [1] "A text string42, another text string"
```


What we get is that R automatically converts the number "42" to text, and sticks it together with the preceeding and subsequent stuff. Usefully, we can also include ranges of numbers, which produces a number of strings:


```r
paste0("A text string", 41:43, ", another text string")
```

```
## [1] "A text string41, another text string"
## [2] "A text string42, another text string"
## [3] "A text string43, another text string"
```


### Read in the damn files already

The file for subject one is labelled like this:

"data_S1.csv"

and subject 2's results are in the file "data_S2.csv", and so on. The following script uses a `for` loop to read in the data, then appends it to a data frame called `dat`. 


```r
dat <- data.frame()  # create an empty data frame.
setwd("..")  # TODO remove up level
for (i in 1:5) {
    file <- paste0(getwd(), "/data/data_S", i, ".csv")
    this_dat <- read.csv(file = file)  # read the subject's file, put in a data frame called this_dat
    dat <- rbind(dat, this_dat)  # append to larger data frame  
}
```


What this `for` loop gives us is a data frame object called `dat`. Let's examine it using the `str` ("structure") command:


```r
str(dat)
```

```
## 'data.frame':	7000 obs. of  6 variables:
##  $ subject    : Factor w/ 5 levels "S1","S2","S3",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ contrast   : num  0.0695 0.0131 0.0695 0.0695 0.3679 ...
##  $ sf         : num  0.5 40 4.47 40 13.37 ...
##  $ target_side: Factor w/ 2 levels "left","right": 2 2 1 1 1 1 2 2 1 2 ...
##  $ response   : Factor w/ 2 levels "left","right": 2 1 1 2 1 2 2 1 2 2 ...
##  $ unique_id  : Factor w/ 7000 levels "00004355-345d-403e-b244-79c8adb8f1f8",..: 451 983 595 395 277 387 132 809 711 582 ...
```


## Data frames
Data frames are the most important (or at least useful) data type in R, and what you're going to be using a lot. Many methods use data frames. The most awesome thing about a data frame is that it can store both numerical data and text. This allows us to read in that `csv` file no problem, where other basic data types would really struggle (I'm looking at you, Matlab). 

Furthermore, data frames can explicitly treat text as a "factor", which means that when you fit a model, it won't try to use this numerically but will rather dummy code it. Note how in the `str` call above, several variables (in fact, all those that were strings in the `.csv` file) have been imported as factors. Let's look at some behaviour of factors now by looking at the summary of our data:


```r
summary(dat)
```

```
##  subject      contrast            sf        target_side   response   
##  S1:1400   Min.   :0.0025   Min.   : 0.50   left :3500   left :3488  
##  S2:1400   1st Qu.:0.0057   1st Qu.: 1.50   right:3500   right:3512  
##  S3:1400   Median :0.0302   Median : 4.47                            
##  S4:1400   Mean   :0.0927   Mean   :11.97                            
##  S5:1400   3rd Qu.:0.1599   3rd Qu.:13.37                            
##            Max.   :0.3679   Max.   :40.00                            
##                                                                      
##                                 unique_id   
##  00004355-345d-403e-b244-79c8adb8f1f8:   1  
##  000f3b09-9dde-4dd4-8a97-ad87cfcbc947:   1  
##  00448030-70e5-4010-b954-4a35c107841e:   1  
##  0086b264-17ed-4fbb-8e32-8c7814ae6b6a:   1  
##  00a070b7-f849-4727-a710-0453d6f27c50:   1  
##  00b414aa-3f65-4b4d-8d12-f0d41ec7ae42:   1  
##  (Other)                             :6994
```


See how we get some distribution summaries for the covariates (e.g. contrast), but only told how many instances of each factor level there are? Neat huh?

## Data munging
In our data file there is a "response" variable, that is a string of the side the subject responded to. What we really want however is to know whether they got the trial correct. That is, is the string in "target_side" the same as the string in "response"? Let's create this new variable now:


```r
dat$correct <- 0  # initialises the variable 'correct' with all zeros.
dat$correct[dat$target_side == dat$response] <- 1  # logical indexing; if target == response, returns TRUE
summary(dat$correct)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    0.00    1.00    1.00    0.77    1.00    1.00
```

```r
hist(dat$correct)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 


Now we have a variable in the data frame `dat` that gives a 1 where the subject was correct and a 0 elsewhere. In the next post, I will show some basic graphical exploration of this data set using the ggplot2 package.

## PS
This blog was written in R Markdown (in R Studio as a .Rmd file -> "knit HTML", then paste the .md code directly into wordpress... too easy!)

You can check out the repository for this and some upcoming posts in my Github repository (TODO).

--------------------
[1] Campbell, F. W., & Robson, J. G. (1968). Application of Fourier analysis to the visibility of gratings. The Journal of Physiology, 197(3), 551–566.
