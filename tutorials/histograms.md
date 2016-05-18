---
layout: page
title: NULL
---

[R Vocab Topics](index) &#187; [Visualizations](visualization) &#187; Histograms & density plots

<br>

Histograms are a useful way to look at the shape of a distribution of numerical data and are, typically, our first step in assessing normality. They are used by displaying the numeric values on the x-axis where the continuous variable is broken into intervals (aka bins) and the the y-axis represents the frequency or percent of observations that fall into that bin. Density plots provide a similar plot; however, the y-axis displays the probability of getting an x value.

- [Replication requirements](#replication)
- [Basic histogram & density plot](#basics)
- [Comparing groups](#groups)
- [Adding value markers](#markers)

<br>

## Relication Requirements {#replication}
We'll illustrate with the following data:


{% highlight r %}
set.seed(1234)

df <- data.frame(group = factor(rep(c("A", "B"), each = 200)),
                 rating = c(rnorm(200), rnorm(200, mean = .8)))
{% endhighlight %}

Although histograms can be produced quickly with base R functions and `ggplot2`'s `qplot()` function, for this tutorial I will demonstrate how to generate more refined histograms with `ggplot2`s full syntax.


{% highlight r %}
library(ggplot2)
{% endhighlight %}

<br>

## Basic Histogram & Density Plot {#basics}
The basic histogram assesses the frequency or count of individual x intervals. 


{% highlight r %}
# default histogram
ggplot(df, aes(x = rating)) +
        geom_histogram()

## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-3-1.png" style="display: block; margin: auto;" />

{% highlight r %}
# Change colors for better distinction and adjust bin width
ggplot(df, aes(x = rating)) +
        geom_histogram(binwidth = .3, color = "grey30", fill = "white")
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-3-2.png" style="display: block; margin: auto;" />

To visualize the density of the distribution instead of the count:


{% highlight r %}
# default density plot
ggplot(df, aes(x = rating)) +
        geom_density()
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

{% highlight r %}
# get the density histogram
ggplot(df, aes(x = rating)) +
        geom_histogram(aes(y = ..density..), 
                     binwidth = .3, color = "grey30", fill = "white")
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-4-2.png" style="display: block; margin: auto;" />

{% highlight r %}
# overlay the histogram & density plot
ggplot(df, aes(x = rating)) +
        geom_histogram(aes(y = ..density..), 
                     binwidth = .3, color = "grey30", fill = "white") +
        geom_density()
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-4-3.png" style="display: block; margin: auto;" />

{% highlight r %}
# fill density overlay with transparent color
ggplot(df, aes(x = rating)) +
        geom_histogram(aes(y = ..density..), 
                     binwidth = .3, color = "grey30", fill = "white") +
        geom_density(alpha = .2, fill = "antiquewhite3")
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-4-4.png" style="display: block; margin: auto;" />

<a href="#top">Go to top</a>

<br>

## Comparing Groups {#groups}
Often, we want to compare the distributions of different groups within our data.  To compare the histograms and density plots of multiple groups we can do the following:


{% highlight r %}
# Overlaying histograms
ggplot(df, aes(x = rating, fill = group)) +
        geom_histogram(binwidth = .3, alpha = .5, position = "identity")
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

{% highlight r %}
# Interweaving histograms
ggplot(df, aes(x = rating, fill = group)) +
        geom_histogram(binwidth = .3, position = "dodge")
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-5-2.png" style="display: block; margin: auto;" />

{% highlight r %}
# Overlaying density plots
ggplot(df, aes(x = rating, fill = group)) +
        geom_density(alpha = .5)
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-5-3.png" style="display: block; margin: auto;" />


We can also separate the histograms by using facets:


{% highlight r %}
# vertical faceting
ggplot(df, aes(x = rating)) +
        geom_histogram(binwidth = .3, color = "grey30", fill = "white") +
        facet_grid(group ~ .)
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-6-1.png" style="display: block; margin: auto;" />


{% highlight r %}
# horizontal faceting
ggplot(df, aes(x = rating)) +
        geom_histogram(binwidth = .3, color = "grey30", fill = "white") +
        facet_grid(. ~ group)
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-7-1.png" style="display: block; margin: auto;" />


<a href="#top">Go to top</a>

<br>

## Add Value Markers {#markers}
We can also add markers to indicate important values such as the mean or median:


{% highlight r %}
# Add mean line to single histogram
ggplot(df, aes(x = rating)) +
        geom_histogram(binwidth = .3, color = "grey30", fill = "white") +
        geom_vline(aes(xintercept = mean(rating, na.rm = TRUE)),
                    color = "red", linetype = "dashed", size = 1)
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-8-1.png" style="display: block; margin: auto;" />

To add lines for grouped data we need to do a little computation prior to graphing.  Here we simple create a new data frame with the mean values for each group and use that data to plot the mean lines:


{% highlight r %}
library(dplyr)

# calculate mean for each group
df_mean <- df %>%
        group_by(group) %>%
        summarise(Avg = mean(rating, na.rm = TRUE))

# Add mean line to overlaid histograms
ggplot(df, aes(x = rating, fill = group)) +
        geom_histogram(binwidth = .3, alpha = .5, position = "identity") +
        geom_vline(data = df_mean, aes(xintercept = Avg, color = group),
                   linetype = "dashed", size = 1)
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-9-1.png" style="display: block; margin: auto;" />


{% highlight r %}
# Add mean line to faceted histograms
ggplot(df, aes(x = rating)) +
        geom_histogram(binwidth = .3, color = "grey30", fill = "white") +
        facet_grid(. ~ group) +
        geom_vline(data = df_mean, aes(xintercept = Avg), 
                   linetype = "dashed", size = 1, color = "red")
{% endhighlight %}

<img src="Histogram_files/figure-html/unnamed-chunk-10-1.png" style="display: block; margin: auto;" />

<a href="#top">Go to top</a>

<br>
