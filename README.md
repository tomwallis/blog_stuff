tomwallis.info blog materials
==========

This holds files used or linked on my blog at tomwallis.info. Mostly right now it's R markdown that I use for the R-heavy wordpress posts (these are in the `/blog_posts` subdirectory). It also acts as an example for one way to set up a project directory:

  * `/data/` contains the raw data for my blog examples.
  * `/funs/` contains any scripts or functions that do stuff to the data, or output anything.
  * `/out/` contains processed data (e.g. an RData file).
  * `/figs/` contains any figures.

You can then set up a manuscript file that will pull in figures from the `/figs/` directory, ensuring that you always have the most recent figures placed in your manuscript file.