---
layout: post
title:  17 learningCurve Functions
author: Bradley Boehmke
date: 2016-06-18
published: true
categories: [learningCurve]
tags: [programming]
---

<script type="text/javascript" async
  src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

I completed 17 functions for the learningCurve package this week:

## Unit Learning Curve Models

### unit_curve()
The `unit_curve()` model predicts the time or cost of the nth unit given the time of the mth unit and the learning rate. Since most people think in terms of learning rates rather than natural slopes ($b$ below), I built the functions to take in learning rates and conver them to the corresponding natural slope.

$$y = t * (n/m)^b$$

where

- y = the time (or cost) required for the nth unit of production.
- t = time (or cost) required for the mth unit of production
- m = mth unit of production (default set to 1st production unit)
- n = nth unit you wish to predict the time (or cost) for
- r = learning curve rate in decimal form



**Example:** An estimator believes that the first unit of a product will require 100 labor hours. How many hours will the tenth unit require given the organization has historically experienced an 85% learning curve?


{% highlight r %}
unit_curve(t = 100, n = 100, r = .85)
{% endhighlight %}



{% highlight text %}
## [1] 33.96796
{% endhighlight %}

