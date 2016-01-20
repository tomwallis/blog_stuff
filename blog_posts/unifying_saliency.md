# Unifying saliency metrics

How well can we predict where people will look in an image? A large variety of models have been proposed that try to predict where people look using only the information provided by the image itself. The [MIT Saliency Benchmark](http://saliency.mit.edu/results_mit300.html), for example, compares 47 models.

So which model is doing the best? Well, it depends which metric you use to compare them. That particular benchmark lists 7 metrics; ordering by a new one changes the model rankings. That's a bit confusing. Ideally we would find a metric that unambiguously tells us what we want to know.

Over a year ago, I wrote [this blog post](http://tomwallis.info/2014/09/29/how-close-are-we-to-understanding-image-based-saliency/) telling you about our preprint [How close are we to understanding image-based saliency?](http://arxiv.org/abs/1409.7686). After reflecting on the work, we realised that the most useful contribution of that paper was buried in the appendix (Figure 10). Specifically, putting the models onto a common probabalistic scale makes all the metrics* agree. It also allows the model performance *per se* to be separated from nuisance factors like centre bias and spatial precision, and for model predictions to be evaluated within individual images.

We re-wrote the paper to highlight this contribution, and it's now [available here](https://dx.doi.org/10.1073/pnas.1510393112). [The code is available here.](https://github.com/matthias-k/pysaliency)

Citation:

Kümmerer, M., Wallis, T.S.A. and Bethge, M. (2015). Information-theoretic model comparison unifies saliency metrics. *Proceedings of the National Academy of Sciences.*

* all the metrics we evaluated, at least.