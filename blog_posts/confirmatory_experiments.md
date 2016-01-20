# Confirmatory experiments and researcher degrees of freedom

A few months ago I attended a talk given by a professor of cognitive neuroscience / psychology. The professor presented several experiments to support a particular hypothesis, including both behavioural studies and fMRI. The final minutes of the presentation were used to tell us about some exciting new findings that could suggest an interesting new effect. In presenting these results, the professor stated "we've only run 10 subjects so far and this difference is not quite significant yet, but we're collecting a few more people and we expect it to drop under .05".

This is an example of a ["researcher degree of freedom"](http://people.psych.cornell.edu/~jec7/pcd%20pubs/simmonsetal11.pdf), ["questionable research practice"](https://www.cmu.edu/dietrich/sds/docs/loewenstein/MeasPrevalQuestTruthTelling.pdf), or "p-hacking" (specifically, we could call this example "data-peeking"). In my experience it is very common in experimental psychology, and recent publications show it's a problem much more broadly (see e.g. [here](http://www.nimh.nih.gov/about/director/2014/p-hacking.shtml), [here](http://www.ncbi.nlm.nih.gov/pubmed/25204545) and [this article by Chris Chambers](http://www.theguardian.com/science/head-quarters/2014/jun/10/physics-envy-do-hard-sciences-hold-the-solution-to-the-replication-crisis-in-psychology)). 

Why does data-peeking happen? I believe that in almost all cases there is no malicious intent to mislead, but rather that it arises from a faulty intuition.

Researchers intuit that having more data should lead to a better estimate of the true effect. The intuition is correct, but where people go wrong is assuming it applies to *statistical testing* too. Unfortunately, many researchers (including my former self) don't understand this, and erroneously rely on their intuition. 

## The Garden of Forking Paths \*

It essentially boils down to this: if your data depend on your analyses *or* your analyses depend on your data, you could be on thin inferential ice. [Daniel Lakens has a nice post on the former](http://daniellakens.blogspot.de/2014/06/data-peeking-without-p-hacking.html), while [Gelman and Loken have an article on the latter that's well worth your time](http://www.stat.columbia.edu/~gelman/research/unpublished/p_hacking.pdf) (now published in revised form [here](http://www.americanscientist.org/issues/pub/2014/6/the-statistical-crisis-in-science/1)).

### Data depend on analyses

An example of this is if you test a few subjects, check the result, and maybe collect some more data because it's "trending towards significance" (as for our anonymous professor, above).  If you just apply a p-value as normal, it means that your false positive rate is no longer equal to the nominal alpha level (e.g., 0.05), but is actually higher. You're more likely to reject the null hypothesis and call something significant if you data peek – unless you apply statistical corrections for your stopping rules (called "sequential testing" in the clinical trials literature; see [this post by Daniel Lakens has some info on how to correct for this](http://daniellakens.blogspot.de/2014/06/data-peeking-without-p-hacking.html)).

### Analyses depend on data

An example of this is if you collect 20 subjects, then realise two of them show some "outlier-like" behavior that you hadn't anticipated: reaction times that are too fast to be task-related. You decide to exclude the trials with "too-fast" reaction times, defining "too-fast" based on the observed RT distribution\*\*. This neatens up your dataset -- but given different data (say, those two subjects behaved like the others), your analysis would have looked different. In this case, your analyses are dependent on the data. 

I believe this happens all the time in experimental psychology / neuroscience. Other examples include grouping levels of a categorical variable differently, defining which "multiple comparisons" to correct for, defining cutoffs for "regions of interest"... When your analyses depend on the data, you're doing *exploratory data analysis*. Why is that a problem? By making data-dependent decisions you've likely managed to fit *noise* in your data, and this won't hold for new, noisy data: you're increasing the chance that your findings for this dataset won't generalise to a new dataset.

Exploratory analyses are often very informative -- but they should be labelled as such. As above, your actual false positive rate will be higher than your nominal false positive rate (alpha level) when you use a p-value.  

## We should be doing more confirmatory research studies

For experimental scientists, the best way to ensure that your findings are robust is to run a confirmatory study. This means 

1. Collect the data with a pre-specified plan: how many participants, then stop. If you plan on having contingent stopping rules (doing sequential testing) then follow the appropriate corrections for any test statistics you use to make inferential decisions.
2. Analyse the data with an analysis pipeline (from data cleaning to model fitting and inference) that has been prespecified, without seeing the data. 
3. Report the results of those analyses.

If you started out with a data-dependent (exploratory) analysis, report it as such in the paper, then add a confirmatory experiment \*\*\*. There's a great example of this approach from experimental psychology (in this case, a negative example). [Nosek, Spies and Motyl](http://pps.sagepub.com/content/7/6/615) report finding that political moderates were better at matching the contrast (shade of grey) of a word than those with more extreme (left or right) political ideologies (p = 0.01, N = 1,979 --- it was an online study). Punch line: "Political extremists perceive the world in black and white -- literally and figuratively". However, the authors were aware that they had made several data-dependent analysis decisions, so before rushing off to publish their finding, they decided to run a direct confirmatory study. New N = 1,300, new p-value = 0.59. 

The best way to show the community that your analysis is confirmatory is to *pre-register* your study. One option is to go on something like the [Open Science Framework](https://osf.io/), submit a document with your methods and detailed analysis plan, then [register it](https://osf.io/getting-started/#registrations). The project can stay private (so nobody else can see it), but now there's a record of your analyis plan registered before data collection. A better option is to submit a [fully registered report](http://www.theguardian.com/science/blog/2013/jun/05/trust-in-science-study-pre-registration). In this case, you can send your introduction, method and analysis plan to a journal, where it is peer reviewed and feedback given --- all before the data are collected. Taking amendments into account, you then run off and collect the data, analyse it as agreed, and report the results. In a registered report format, the journal agrees to publish it no matter the result. If the study is truly confirmatory, a null result can be informative too.

Of course, there's still trust involved in both of these options – and that's ok. It's hard to stop people from outright lying. I don't think that's a big problem, because the vast majority of scientists really want to do the right thing. It's more that people just don't realise that contingent analyses can be a problem, or they convince themselves that *their* analysis is fine. Pre-registration can help you convince *yourself* that you've really run a confirmatory study.

## Conclusion 

I hope the considerations above are familiar to you already -- but if you're like many people in experimental psychology, neuroscience, and beyond, maybe this is the first you've heard of it. In practice, most people I know (including myself) are doing exploratory studies *all the time*. Full disclosure: I've never reported a truly confirmatory study, ever. In a follow-up post, I'm going to speculate about how the recommendations above might be practically implemented for someone like me. 


\* the title refers to the [short story by Jorge Luis Borges](https://en.wikipedia.org/wiki/The_Garden_of_Forking_Paths), and was used by [Gelman and Loken](http://www.stat.columbia.edu/~gelman/research/unpublished/p_hacking.pdf) to refer to data-dependent analyses.

\*\* Note: this is a very bad idea, because it ignores any theoretical justification for what "too fast to be task-related" is. I use it only for example here. I have a more general problem with outlier removal, too: unless the data is wrong (e.g. equipment broke), then change the model, not the data. For example, if your data have a few outliers, run a robust regression (i.e. don't assume Gaussian noise). Of course, this is another example of a data-dependent analysis. Run a confirmatory experiment...

\*\*\* An equivalent method is to keep a holdout set of data that's only analysed at the end -- if your conclusions hold, you're probably ok. 
