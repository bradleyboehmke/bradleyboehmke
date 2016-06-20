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

$$y_n = t_m * \frac{n}{m}^b$$

where

- $y_n$ = the time (or cost) required for the nth unit of production.
- $t_m$ = time (or cost) required for the mth unit of production
- m = mth unit of production (default set to 1st production unit)
- n = nth unit you wish to predict the time (or cost) for
- b = natural slope of the learning curve rate



**Example:** An estimator believes that the first unit of a product will require 100 labor hours. How many hours will the tenth unit require given the organization has historically experienced an 85% learning curve?


{% highlight r %}
unit_curve(t = 100, n = 100, r = .85)
{% endhighlight %}



{% highlight text %}
## [1] 33.96796
{% endhighlight %}

## unit_cum_exact( )
The `unit_cum_exact()` provides the exact cumulative relationship for the unit model.

$$y_{m,n} = t_m[m^b + (m+1)^b + (m+2)^b + ... + n^b]$$

where:

- $y_{m,n}$ = is the exact total hours required for units m through n (inclusive)
- $t_m$ = time (or cost) required for the mth unit of production
- m = mth unit of production
- n = nth unit you wish to predict the time (or cost) for
- b = natural slope of the learning curve rate 

**Example:** An estimator believes that the first unit of a product will require 100 labor hours. How many total hours will the first ten units require given the organization has historically experienced an 85% learning curve?




{% highlight r %}
unit_cum_exact(t = 100, n = 100, r = .85)
{% endhighlight %}



{% highlight text %}
## [1] 4375.387
{% endhighlight %}

