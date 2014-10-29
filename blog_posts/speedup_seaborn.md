## High-level plotting in Python

If you have read my older blog posts, you know I'm a fan of R's `ggplot2` library for exploratory data analysis. It allows you to examine many views onto data, creating summaries over different variables right there as you plot. [I gave a short tutorial here](http://tomwallis.info/2014/04/21/graphically-exploring-data-using-ggplot2/). Once you understand how the library works, it's a very powerful way of quickly seeing patterns in large datasets.

## Moving over to Python

The past few months have seen me ramp up my Python useage ([as I preempted almost a year ago](http://tomwallis.info/2014/01/14/my-current-direction-in-scientific-computing/)). This is for a variety of reasons, but mostly (a) Python is a general programming language, so you can essentially do *anything* in it without it being a massive hack; (b) the scientific computing packages available for Python are generally super awesome; (c) it seems to me to be poised to replace Matlab as the *lingua franca* of neuroscience / vision research -- at least, much more so than R. See [Tal Yarkoni's blog for a related discussion](http://www.talyarkoni.org/blog/2013/11/18/the-homogenization-of-scientific-computing-or-why-python-is-steadily-eating-other-languages-lunch/). Of course, it's also free and open source.

What I'm still kind of missing in Python is a nice high-level plotting library like `ggplot2`. Certainly, there are many in the works, but in playing around I've found that none of them can match R's `ggplot2` yet. 

## Amphibious assault

Of the libraries I've tried (main competitor is [yhat's ggplot port](http://ggplot.yhathq.com/)), my go-to library for plotting in Python is hands-down [Seaborn](http://web.stanford.edu/~mwaskom/software/seaborn/index.html). Developed largely by Michael Waskom, a graduate student in Cog Neuro at Stanford, it [has the prettiest plots](http://web.stanford.edu/~mwaskom/software/seaborn/tutorial/aesthetics.html#removing-spines-with-despine), and also [the best ideas for high-level functionality](http://web.stanford.edu/~mwaskom/software/seaborn/tutorial/quantitative_linear_models.html).

## Speeding up Seaborn?

Unfortunately, compared to R's `ggplot2`, Seaborn data summary functions are *slow*. As an example, I'll show you a summary plot using the [simulated data](http://github.com/tomwallis/blog_stuff/blob/master/out/contrast_data.csv) from [my](http://tomwallis.info/2014/03/26/data-import-in-r/) [R](http://tomwallis.info/2014/04/21/graphically-exploring-data-using-ggplot2/) [tutorials](http://tomwallis.info/2014/05/06/simulating-data/). 

We want to summarise our (simulated) subjects' detection performance as a function of stimulus contrast, for each spatial frequency. In R, my code looks like this:

```
    library(ggplot2)
    setwd('~/Dropbox/Notebooks/')
    dat <- read.csv('contrast_data.csv')
    summary(dat)

    plot_fun <- function(){
      fig <- ggplot(data = dat, aes(x=contrast, y=correct, colour=factor(sf))) +
        stat_summary(fun.data = "mean_cl_boot") + 
        scale_x_log10() + scale_y_continuous(limits = c(0,1)) + 
        facet_wrap( ~ subject, ncol=3)  +  
        stat_smooth(method = "glm", family=binomial())
      print(fig)
    }
    
    system.time(plot_fun())
```

This takes about **3 seconds** (2.67) to return the following plot:

%%%%%%% INSERT FIGURE HERE %%%%%%%%%

Let's contrast this to Seaborn. First the code:

```
    # do imports
    import numpy as np
    import pandas as pd
    import seaborn as sns
    import matplotlib.pyplot as plt
    import ggplot

    dat = pd.read_csv('contrast_data.csv')
    
    # make a log contrast variable (because Seaborn can't auto-log an axis like ggplot):
    dat['log_contrast'] = np.log(dat['contrast'])
    
    # set some styles we like:
    sns.set_style("white")
    sns.set_style("ticks")
    pal = sns.cubehelix_palette(5, start=2, rot=0, dark=0.1, light=.8, reverse=True)
    
    %%timeit
    fig = sns.lmplot("log_contrast", "correct", dat, 
               x_estimator=np.mean, 
               col="subject",
               hue='sf',
               col_wrap=3,
               logistic=True,
               palette=pal,
               ci=True);
```

(note that the above lines were run in an ipython notebook, hence the `%%timeit` magic operator).

Seaborn takes... wait for it... **2 minutes and 11 seconds** to produce the following plot: 

%%%%%%% INSERT FIGURE HERE %%%%%%%%%

(I'm using Python 3.3.5, Anaconda distribution 2.1.0, Seaborn 0.4.0.)

Note also that both packages are doing 1000 bootstraps by default (as far as I'm aware), so I'm pretty sure they're doing equivalent things.

## What can be done?

This is obviously not a positive factor for my switch from R to Python, and I'm hoping it's just that I've done something wrong. However, another explanation is that whatever Seaborn is using to do the bootstrapping or logistic model fitting is just far less optimised than ggplot2's backend in R.

The nice thing about open source software is that we can help to make this better. So if you're a code guru who's reading this and wants to contribute to the scientific computing world moving ever faster to Python, go [fork the github repo](https://github.com/mwaskom/seaborn) now!
