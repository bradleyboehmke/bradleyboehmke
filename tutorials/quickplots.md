---
layout: page
title: NULL
---

[R Vocab Topics](index) &#187; [Visualizations](visualization) &#187; Quick plots

<br>

For quick data exploration, base R plotting functions can provide a quick and straightforward approach to understanding your data. These functions are installed by default with R and do not require additional visualization packages to be installed. This tutorial shows how to use these base functions for visualizations and I'll use data sets that come with R.  

In addition, I'll show how to make similar graphics with the `qplot()` function in `ggplot2`, which has a syntax similar to the base graphics functions. For each `qplot()` graph, there is also an equivalent using the more powerful `ggplot()` function which I illustrate in later visualization tutorials. This will, hopefully, help you transition to using `ggplot2` when you want to make more sophisticated graphics. 

- [Scatter plot](#scatter)
- [Line chart](#line)
- [Bar chart](#bar)
- [Histogram](#histogram)
- [Box plot](#box)
- [Stem & leaf plot](#stem)

<br>

## Scatter Plot {#scatter}
To make a scatter plot use `plot()` with a vector of x values and a vector of y values:


{% highlight r %}
# base R
plot(x = mtcars$wt, y = mtcars$mpg)
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-1-1.png" style="display: block; margin: auto;" />

You can get a similar result using `qplot()`:


{% highlight r %}
library(ggplot2)
qplot(x = mtcars$wt, y = mtcars$mpg)
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-2-1.png" style="display: block; margin: auto;" />

If the two vectors are already in the same data frame, note that the following functions produce the same outpt:


{% highlight r %}
# specifying only x and y vectors
qplot(x = mtcars$wt, y = mtcars$mpg)

# specifying x and y vectors from a data frame
qplot(x = wt, y = mpg, data = mtcars)

# using full ggplot syntax
ggplot(data = mtcars, aes(x = wt, y = mpg)) +
        geom_point()
{% endhighlight %}

<a href="#top">Go to top</a>

<br>

## Line Chart {#line}
To make a line graph using `plot()`, pass it the vector of x and y values, and specify type =" l" for *line*:


{% highlight r %}
plot(x = pressure$temperature, y = pressure$pressure, type = "l")
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

To include multiple lines or to plot the points, first call `plot()` for the first line, then add additional lines and points with `lines()` and `points()` respectively: 


{% highlight r %}
# base graphic
plot(x = pressure$temperature, y = pressure$pressure, type = "l")

# add points
points(x = pressure$temperature, y = pressure$pressure)

# add second line in red color
lines(x = pressure$temperature, y = pressure$pressure/2, col = "red")

# add points to second line
points(x = pressure$temperature, y = pressure$pressure/2, col = "red")
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

We can use `qplot()` to get similar results by using the `geom` argument. `geom` means adding a geometric object (line, points, etc.) to visually represent the data and in this case we want to represent the data using a line and then also points:


{% highlight r %}
# using qplot for a line chart
qplot(temperature, pressure, data = pressure, geom = "line")
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-6-1.png" style="display: block; margin: auto;" />

{% highlight r %}
# using qplot for a line chart with points
qplot(temperature, pressure, data = pressure, geom = c("line", "point"))
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-6-2.png" style="display: block; margin: auto;" />

We can get the same output using the full `ggplot()` syntax:

{% highlight r %}
# line chart
ggplot(pressure, aes(x = temperature, y = pressure)) +
        geom_line()

# line chart with points
ggplot(pressure, aes(x = temperature, y = pressure)) +
        geom_line() +
        geom_point()
{% endhighlight %}


<a href="#top">Go to top</a>

<br>

## Bar Chart {#bar}
To make a bar chart of values, use `barplot()` and pass it a vector of values for the height of each bar and (optionally) a vector of labels for each bar. If the vector has names for the elements, the names will automatically be used as labels:


{% highlight r %}
barplot(height = BOD$demand, names.arg = BOD$Time)
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-8-1.png" style="display: block; margin: auto;" />

When you want the bar chart to represent the *count* of cases in each category then you need to generate the count of unique values. For instance, in the `mtcars` dataset we may want to look at the cylinder variable and understand the distribtion. To do this we can use the `table()` function which will provide us the count of each unique value in this variable.  We can then pass this to the `barplot()` function to plot the counts of cylinders:


{% highlight r %}
# the cylinder variable in the mtcars dataset is made up of values of 4, 6 & 8
mtcars$cyl
##  [1] 6 6 4 6 8 6 8 4 4 6 6 8 8 8 8 8 8 4 4 4 4 8 8 8 8 4 4 4 8 6 8 4

# get the count of 4, 6 & 8 cylinder cars in the dataset
table(mtcars$cyl)
## 
##  4  6  8 
## 11  7 14

# plot the count of 4, 6 & 8 cylinder cars in the dataset
barplot(table(mtcars$cyl))
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-9-1.png" style="display: block; margin: auto;" />

To get the same result using `qplot()` we use `geom = "bar"`.


{% highlight r %}
# x defaults to a continuous variable
qplot(mtcars$cyl, geom = "bar")
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-10-1.png" style="display: block; margin: auto;" />

{% highlight r %}
# use factor(x) to make it discrete
qplot(factor(mtcars$cyl), geom = "bar")
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-10-2.png" style="display: block; margin: auto;" />

<a href="#top">Go to top</a>

<br>

## Histogram {#histogram}
To make a histogram, use `hist()` and pass it a single vector of values. You can also use the `breaks` argument to determine the size of the bins.


{% highlight r %}
# default bins
hist(mtcars$mpg)
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-11-1.png" style="display: block; margin: auto;" />

{% highlight r %}
# adjust binning
hist(mtcars$mpg, breaks = 10)
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-11-2.png" style="display: block; margin: auto;" />

To get the same result using `qplot()` we use don't need to specify a `geom` argument as when you feed `qplot()` with a single variable it will default to using a histogram. You can also control the binning by using the `binwidth` argument. Although not necessary I add the `color` argument to outline the bars.


{% highlight r %}
qplot(mtcars$mpg, binwidth = 3, color = I("white"))
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-12-1.png" style="display: block; margin: auto;" />

<a href="#top">Go to top</a>

<br>

## Box Plot {#box}
To make a box-whisker plot (aka box plot), use plot() and pass it a <u>factor</u> of x values and a vector of y values. When x is a factor (as opposed to a numeric vector), it will automatically create a box plot:


{% highlight r %}
# if x is not a factor it will produce a scatter plot
plot(mtcars$cyl, mtcars$mpg)
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-13-1.png" style="display: block; margin: auto;" />

{% highlight r %}
# if x is a factor it will produce a box plot
plot(factor(mtcars$cyl), mtcars$mpg)
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-13-2.png" style="display: block; margin: auto;" />

Alternatively, we can use the `boxplot()` function to get the same results. In this case we use the "~" to state that we want to assess *y* by *x*.  


{% highlight r %}
# boxplot of mpg by cyl
boxplot(mpg ~ cyl, data = mtcars)
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-14-1.png" style="display: block; margin: auto;" />

We can also assess interactions. In this case we look at the distribution of mpg by cylinders and V/S. Note on the y axis is mpg and on the x axis are the cylinder~V/S interaction. So the x-axis values of 4.0, 6.0, 8.0, 4.1, etc. represent 4 cylinder without V/S, 6 cylinder without V/S, 8 cylinder without V/S, 4 cylinder with V/S, etc. 


{% highlight r %}
# boxplot of mpg based on interaction of two variables
boxplot(mpg ~ cyl + am, data = mtcars)
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-15-1.png" style="display: block; margin: auto;" />

Similar results are attained with `qplot()` using `geom = "boxplot"`:


{% highlight r %}
qplot(x = factor(cyl), y = mpg, data = mtcars, geom = "boxplot")
{% endhighlight %}

<img src="/public/images/visual/quickplots/unnamed-chunk-16-1.png" style="display: block; margin: auto;" />

<a href="#top">Go to top</a>

<br>

## Stem & Leaf Plot {#stem}
To make a stem-and-leaf plot we can simply use the `stem()` function and pass it a vector of numeric values:


{% highlight r %}
stem(faithful$eruptions)

## 
##   The decimal point is 1 digit(s) to the left of the |
## 
##   16 | 070355555588
##   18 | 000022233333335577777777888822335777888
##   20 | 00002223378800035778
##   22 | 0002335578023578
##   24 | 00228
##   26 | 23
##   28 | 080
##   30 | 7
##   32 | 2337
##   34 | 250077
##   36 | 0000823577
##   38 | 2333335582225577
##   40 | 0000003357788888002233555577778
##   42 | 03335555778800233333555577778
##   44 | 02222335557780000000023333357778888
##   46 | 0000233357700000023578
##   48 | 00000022335800333
##   50 | 0370
{% endhighlight %}

<a href="#top">Go to top</a>
