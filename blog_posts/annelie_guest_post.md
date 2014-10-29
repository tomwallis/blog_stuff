# Guest Post: Matlab versus Pandas for data analysis

*Annelie Muehler is an undergraduate student who is about to finish a 2 month internship in our group. She has been working with me conducting psychophysical experiments, and we have been creating stimuli using python. As part of getting used to scientific python Annelie learned to use  [Pandas](http://pandas.pydata.org/), a package that essentially gives you R's data frames in Python. The following compares the code to do a simple analysis in Matlab and Python. While it's possible there are ways to improve the Matlab implementation (perhaps using the statistics toolbox?), it's noteworthy that these weren't taught in Annelie's course.*

## A comparison of Matlab and Pandas for a simple data analysis

As part of my undergraduate studies in cognitive psychology and neuroscience, I did a water maze experiment in an advanced biology/neuroscience lab course using mice. For this experiment, I had ten mice that did four trials of the experiment over a six day period. The point of this experiment is for the mice to be able to find the platform in the water with increasing speed as they complete more trials. This is because they learn where the platform is. The water maze experiment is one of the behavioural experiments used in mice and rats to test for the ability to learn. Later we used this data while we were learning Matlab in another lab class as a basis for learning data analysis.

During my internship at the Centre for Integrative Neuroscience in Tuebingen, Germany, I reanalyzed this data using pandas in python as a way to learn pandas, giving me a direct comparison of Matlab and pandas. There are definitely some very nice things about pandas. First, you are able to define your own index and column names that are shown surrounding the matrix in a format similar to a table in a word processing document or excel file. This was one of the most frustrating things for me in Matlab because in Matlab you have a dataset and then another variable which contains a list of strings that corresponded to the column names so that you can look them up there.

![][1]

 *An example of the format in which tables are seen in pandas using the mice data. The table is stored in a variable called `rdata`.*
 
 
In pandas, reading data in and out in is easy with the `pd.read_csv()` and `rdata.to_csv` function. As you can see in the image above, the mice data is structured so that the indices represent the row number, the other columns are: 
* Trials which represents the trial number and is numbered from one to four for each trial in each day 
* Animal is the animal number which is in the range one to ten
* Day stands for the day number and is numbered from one to six 
* Swimming Time represents the amount of time it took the mouse to find the platform in the water maze experiment. 

I find it easier to work with the table labeled in this way as opposed to having a different variable with the labels of the columns, as we had done in Matlab. Also pandas has great functions
such as:

-   `rdata.head()` which shows the top rows of the dataframe

-   `rdata.describe()` which gives the count, mean, standard deviation and other statistics of the dataframe (not the most useful for this specific dataframe)

-   `rdata.sort(columns = 'Animal')` which sorts the data by a specific column, in this case the column Animal.

As you can see above, pandas (and python in general) has object-oriented functions. These work by using the name of the object, in this case rdata, adding a period and then typing the function. This will show you the result of the function but generally not change the actual object unless the object is equated with the function (as in `rdata = rdata.sort(columns = 'Animal')`.

The idea of the analysis was the find the average swimming time per day across animals to see if there was any improvement as the mice learned the task. In Matlab we did this by:

1. 

```    
for i=1:nday
    rows_day(:,i)=find(rdata(:,3)==i);
end
```

    This created a dataset in which the rows for each day were identified.

2.  

```
for i=1:nday
    time_day(:,i)=rdata(rows_day(:,i),5);
end
```

    Using the data set from step 1, we are able to get a new data set where the swimming time of each trial is listed for each day across animals.

3.  

```
m_day=mean(time_day);
f=figure;
a=axes;
plot(m_day);
ylabel('Swimming Time (s)')
xlabel('Experimental Day')
set(a,'xtick',1:nday)
title('Average swimming time (s) per day across animals')
```


This results in this simple line graph:

![][2]

 *Graph output from Matlab*


Here's the same thing in pandas.

1.  

```
import pandas as pd
```


    The usual importing at the beginning of each python script.

2.  

```
m_day = rdata.groupby('Day')['Swimming Time'].mean()
m_day = pd.DataFrame({'Swimming Time (s)':day_mean, 'Experimental Day': range(1,7)})
```

Groupby is a useful command that will group the data by day (parentheses) according to Swimming Time (square brackets). This eliminates sorting out the rows by day using a `for` loop as is done in the Matlab code above and allows you to group your data according to different variables in your data frame. The `.mean()` operator at the end tells pandas that you want to compute the means on the grouped data.

3. 

```
m_day.plot(style='b-', x='Experimental Day', y='Swimming Time (s)', title='Average swimming time (s) per day across animals')
```

There are other python plot functions that may be a bit more elaborate but in the spirit of doing everything in pandas I decided to show the pandas version. This results in this simple line graph, identical to the one above:

![][3]

 *Graph output from Pandas*

Figures can be easily saved in pandas using:

`fig = plot.get_figure()`

`fig.savefig()`


Of course this is a very simple example of data analysis, but I think it does outline some of the benefits of pandas. The nicest thing in my opinion is the ease with which you can manipulate the data frame and the ability to select columns by their name. The groupby function is very useful and can be used to groupby multiple columns or to group multiple columns.

In my opinion, pandas is a much simpler and convenient way to work with and manipulate data.

  [1]: Table_example_blog.jpg
  [2]: mean_day_mat.jpg
  [3]: mean_day_py.jpg
