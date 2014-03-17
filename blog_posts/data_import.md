Importing data
========================================================

In [this post](http://tomwallis.info/2014/01/09/a-workflow-principle-avoiding-humans-touching-data/) I argued that a good principle for reproducible research is to avoid humans touching data. That is, once the data from the experiment are saved we want them to be "read only" and never altered by a human in some undocumented way (such as editing in a spreadsheet). In this post I will show you one way to get a dataset into a useable format for further analysis while following this principle.

Data set
----------------
First, we need a data set. Let's pretend we've conducted an experiment similar to the classic Campbell & Robson (1968)^1 study but with a few modifications. As a participant in our experiment, you're seated in front of a monitor showing a grey screen. You're going to be shown a sequence of trials, and for each trial you make a response with a button press. 

On each trial you are asked to keep your eyes on a small dot on the centre of the screen. On every trial, a pattern of dark-and-light stripes (a *grating*) is shown on one side of the screen (left or right of your eye position). On each trial the computer randomly decides whether to present the grating on the left or on the right (the other side just stays as the grey background). You have to respond either "grating on the left" or "grating on the right" -- you can't say "I don't know". Then it waits for your response before showing the next trial. 

We are going to vary both the *contrast* of the grating pattern (how different from grey the dark and light stripes are) and also the *spatial frequency* of the pattern (how wide the bars are) over trials.

If the contrast is so low that you can't see the grating, your responses across many trials will be near chance performance (here 50%). If the grating is really easy to see, your performance will be near 100%. We determine how your performance on the task changes as a function of contrast, for each spatial frequency tested.

We've tested 5 subjects in this experiment, showing them 6 contrasts at 3 spatial frequencies and we made them do 30 trials for each condition (so each subject did 6 * 3 * 30 = 540 trials). Let's say that our experiment program saves the data as a `.csv` file in our project's `/data/` directory. We have one `.csv` file per subject, and one of them might look something like this when opened in a text editor:

```
TODO example image of text file.
```

A few things to notice here: each comma `,` in the file denotes a new column, and each new line denotes a row. Secondly, note that there's a header row: the first line of the file contains column names for our variables. Finally, notice how our `target_side` and `response` columns contain text strings (`left` and `right`). This will be important later.



```r
summary(cars)
```

```
##      speed           dist    
##  Min.   : 4.0   Min.   :  2  
##  1st Qu.:12.0   1st Qu.: 26  
##  Median :15.0   Median : 36  
##  Mean   :15.4   Mean   : 43  
##  3rd Qu.:19.0   3rd Qu.: 56  
##  Max.   :25.0   Max.   :120
```


PS
--------------------------------
This blog was written in R Markdown (in R Studio as a .Rmd file -> "knit HTML", then paste the .md code directly into wordpress... too easy!)

--------------------
[1] Campbell, F. W., & Robson, J. G. (1968). Application of Fourier analysis to the visibility of gratings. The Journal of Physiology, 197(3), 551–566.
