---
layout: post
title:  17 learningCurve Functions
author: Bradley Boehmke
date: 2016-06-18
published: true
categories: [learningCurve]
tags: [programming]
---

I completed 17 functions for the learningCurve package this week:

## Unit Learning Curve Models

### unit_curve( )
The `unit_curve()` model predicts the time or cost of the nth unit given the time of the mth unit and the learning rate. Since most people think in terms of learning rates rather than natural slopes (*b* below), I built the functions to take in learning rates and conver them to the corresponding natural slope.

$$y_n = t_m * \left(\frac{n}{m}\right)^b$$

where

- $$y_n$$ = the time (or cost) required for the nth unit of production.
- $$t_{m}$$ = time (or cost) required for the mth unit of production
- m = mth unit of production (default set to 1st production unit)
- n = nth unit you wish to predict the time (or cost) for
- b = natural slope of the learning curve rate



**Example:** An estimator believes that the first unit of a product will require 100 labor hours. How many hours will the 125th unit require given the organization has historically experienced an 85% learning curve?


{% highlight r %}
unit_curve(t = 100, n = 125, r = .85)
{% endhighlight %}



{% highlight text %}
## [1] 32.23647
{% endhighlight %}

## unit_cum_exact( )
The `unit_cum_exact()` provides the exact cumulative relationship for the unit model.

$$y_{m,n} = t_m[m^b + (m+1)^b + (m+2)^b + ... + n^b]$$

where:

- $$y_{m,n}$$ = is the exact total hours required for units m through n (inclusive)
- $$t_m$$ = time (or cost) required for the mth unit of production
- m = mth unit of production
- n = nth unit you wish to predict the time (or cost) for
- b = natural slope of the learning curve rate 

**Example:** An estimator believes that the first unit of a product will require 100 labor hours. How many total hours will the first 125 units require given the organization has historically experienced an 85% learning curve?




{% highlight r %}
unit_cum_exact(t = 100, n = 125, r = .85)
{% endhighlight %}



{% highlight text %}
## [1] 5201.085
{% endhighlight %}

## unit_cum_appx( )
The `unit_cum_appx()` function provides the approximate cumulative relationship for the unit model.  Provides nearly the exact output as `unit_cum_exact()`, usually only off by 1-2 units but reduces computational time drastically if trying to calculate cumulative hours (costs) for over a million units.

$$y_{m,n} = \frac{t_{1}}{(1+b)} * [(n+0.5)^{1+b} – (m-0.5)^{1+b}]$$

where:

- $$y_{m,n}$$ = is the approximate total hours required for units m through n (inclusive)
- $$t_{1}$$ = time (or cost) required for the first unit of production
- m = mth unit of production to be the first unit in the block
- n = nth unit of production to be the last unit in the block
- b = natural slope of the learning curve rate  

This model computes the time for the first unit of production ($$t_{1}$$) based on the mth unit of production time. So the $$t$$ argument in the functions is really asking for $$t_m$$.



**Example:** An estimator believes that the first unit of a product will require 100 labor hours. How many total hours will the first 125 units require given the organization has historically experienced an 85% learning curve?


{% highlight r %}
unit_cum_appx(t = 100, n = 125, r = .85)
{% endhighlight %}



{% highlight text %}
## [1] 5202.988
{% endhighlight %}

**Example:** Computational difference between `unit_cum_exact()` and `unit_cum_appx()` for 1 million units.


{% highlight r %}
system.time(unit_cum_exact(t = 100, n = 1000000, r = .85))
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##   0.083   0.003   0.087
{% endhighlight %}



{% highlight r %}

system.time(unit_cum_appx(t = 100, n = 1000000, r = .85))
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##       0       0       0
{% endhighlight %}

## unit_midpoint( )
The unit_midpoint() function provides the so-called "midpoint" or average unit between units m and n, where ($$n > m$$).

$$k = \left[\frac{(n+0.5)^{1+b} – (m-.5)^{1+b}}{(1+b)(n-m+1)}\right]^{1/b}$$

where:

- k = midpoint or average unit
- m = lower bound unit of production
- n = upper bound unit of production
- b = natural slope of the learning curve rate

**Example:** If a production block runs from unit 201 to unit 500 inclusive, with a
slope of 75%, what is the midpoint unit?




{% highlight r %}
unit_midpoint(m = 201, n = 500, r = .75)
{% endhighlight %}



{% highlight text %}
## [1] 334.6103
{% endhighlight %}


## unit_block_summary( )
Provides the summary for the block containing units m through n ($$n > m$$). This function simply combines the previous functions to provide the total number of units and hours in the block and the midpoint unit and hours associated with the midpoint.


The arguments requested include:

- t = time for the mth unit
- m = lower bound unit of production block
- n = upper bound unit of production block
- r = learning curve rate



**Example:** A production block runs from unit 201 to unit 500 inclusive. The 201st unit had a required time of 125 hours. With an expected learning rate of 75%, what is the block summary.


{% highlight r %}
unit_block_summary(t = 125, m = 201, n = 500, r = .75)
{% endhighlight %}



{% highlight text %}
## $`block units`
## [1] 300
## 
## $`block hours`
## [1] 30350.48
## 
## $`midpoint unit`
## [1] 334.6103
## 
## $`midpoint hours`
## [1] 101.1683
{% endhighlight %}



