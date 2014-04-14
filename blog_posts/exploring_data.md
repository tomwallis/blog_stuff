# Graphically Exploring Data

Your second step after data import should always be to *look at the data*. That means plotting lots of things, and getting a sense of how everything fits together. *Never* run a statistical test until you've looked at your data in as many ways as you can. Doing so can give you good intuitions about what inferences make sense, or are tenuous, from a given data set. The best tool for reproducible data exploration that I have used is Hadley Wickham's ``ggplot2`` package.

## A brief introduction to the mindset of ggplot

The first thing to note about ``ggplot2`` is that its design philosophy is a bit different to a standard plotting library (like base graphics in Matlab, R, or Python). In those systems, you typically create an x variable and a y variable, then plot them as something like a line, then maybe add a new line in a different colour. GGplot tries to separate your data from how you display it by making links between the data and the visual representations explicit. There's a little introduction to this philosophy [here](http://tomhopper.me/2014/03/28/a-simple-introduction-to-the-graphing-philosophy-of-ggplot2/). 

What this means in practice is that you need to start thinking in terms of _long format data frames_ rather than separate x- and y vectors. A long format data frame is one where each value that we want on the y-axis in our plot is in a separate row ([see wiki article here](https://en.wikipedia.org/wiki/Wide_and_narrow_data)). The Cookbook for R has some good recipes for going between wide and long format data frames [here](http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/). For example, imagine we have measured something (say, reaction time) in a within-subjects design where the same people performed the task under two conditions. Basically, for ggplot we want a data frame with columns like 

subject   | condition | rt
--------  | --------  | ----
s1        | A         | 373
s1        | B         | 416
s2        | A         | 360
s2        | B         | 387

not like

subject   | rt conditionA | rt conditionB
--------  | --------  | ----
s1        | 373         | 416
s2        | 360         | 387

or like 

```
x = [s1, s2]
y_1 = [373, 360]
y_2 = [416, 387]
```

For the first few weeks of using ggplot2 I found this way of thinking about data, particularly when trying to do things as I'd done in Matlab using ggplot2. However, once you make the mental flip, the ggplot universe will open up to you. 

## Contrast detection data set

Now we will look at the data from [my data import](http://tomwallis.info/2014/03/26/data-import-in-r/) post. This consists of data from a psychophysical experiment where five subjects detected sine wave gratings at different contrasts and spatial frequencies. For each trial, we have a binary response (grating left or right) which is either correct or incorrect. 



```r
library(ggplot2)
fig <- ggplot(dat, aes(x = contrast, y = y)) + geom_line() + facet_grid(sf_factor ~ 
    subject) + coord_cartesian(ylim = c(0.45, 1.05)) + scale_x_log10() + scale_y_continuous(breaks = c(0.5, 
    0.75, 1))
```

```
## Error: object 'dat' not found
```

```r
fig
```

```
## Error: object 'fig' not found
```


This post was just a little taste of what you can do in ggplot2, with a focus on vision science data. There are many longer introductions for ``ggplot2`` available on the web, like [here](http://blog.echen.me/2012/01/17/quick-introduction-to-ggplot2/) and [here](http://www.noamross.net/blog/2012/10/5/ggplot-introduction.html). I find that [The Cookbook for R](http://www.cookbook-r.com/) has heaps of useful little tips and code snippets, as well as showing you lots of basic ggplot things.
