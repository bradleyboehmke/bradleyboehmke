---
layout: post
title:  learningCurve Package
author: Bradley Boehmke
date: 2016-10-18
published: true
tags: [programming, R, statistics]
---



<a href="http://bradleyboehmke.github.io"><img src="http://bradleyboehmke.github.io/figure/source/16-learningcurve-functions/2016-06-20-16-learningcurve-functions/unnamed-chunk-4-1.png" alt="Learning Curves" style="float:left; margin: 0px 10px -5px 0px; width: 20%; height: 20%;"></a>
Learning curves are steep in history and have several alternate names such as improvement curves, progress curves, startup functions, and efficiency curves. The "learning effect" was first noted in the 1920s in connection with aircraft production. Its use was amplified by experience in connection with aircraft production in WWII. Initially, it was thought to be solely due to the learning of the workers as they repeated their tasks. Later, it was observed that other factors probably entered in, such as improved tools and working conditions, and various management initiatives. Regardless of the exact, or more likely combined, phenomenon we can group these factors together under the general heading of “learning.” <!--more-->

The underlying notion behind learning curves is that when people individually or collectively repeat an activity, there tends to be a gain in efficiency. Generally, this takes the form of a decrease in the time needed to do the activity. Because cost is generally related to time or labor hours consumed, learning curves are very important in industrial cost analysis. A key idea underlying the theory is that every time the production quantity doubles, we can expected a more or less fixed percentage decrease in the effort required to build a single unit (the Crawford theory), or in the average time required to build a group of units (the Wright theory). These decreases occur not in big jumps, but more or less smoothly as production continues

Consequently, mathematical models are used to represent learning curves by computing the efficiencies gained when an activity is repeated. I've used learning curves in many life cycle forecasting models but we usually built them into our Excel spreadsheet models. With R becoming more accepted in the Air Force and other DoD services that heavily rely on learning curves in their acquisition cost modeling, I was surprised to see that no R package has been built to compute, simulate, fit, and plot unit and cumulative average learning curves.

Thus, [Jason Freels](https://github.com/Auburngrads) and I developed the [`learningCurve` package](https://CRAN.R-project.org/package=learningCurve), which performs basic learning curve computations. The package is now available on CRAN and the remainder of this post summarizes the 17 functions that `learningCurve` provides.

## Unit Learning Curve Models
The following models represent Crawford's unit model which focuses on the effect of learning unit by unit.

### unit_curve( )
The `unit_curve()` model predicts the time or cost of the nth unit given the time of the mth unit and the learning rate. Since most people think in terms of learning rates rather than natural slopes (*b* below), I built the functions to take in learning rates and convert them to the corresponding natural slope.

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


We can also plot this learning curve from unit *m* to unit *n* with `plot_unit_curve()`. This function defaults to plotting the unit model (argument `model = "u"`) at the unit rather than cumulative level (argument `level = "u"`).


{% highlight r %}
plot_unit_curve(t = 100, m = 1, n = 125, r = .85, model = "u", level = "u")
{% endhighlight %}

<img src="http://bradleyboehmke.github.iofigure/source/learningcurve-package/2017-01-01-learningcurve-package/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />


### unit_cum_exact( )
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

### unit_cum_appx( )
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
##   0.091   0.005   0.096
{% endhighlight %}



{% highlight r %}

system.time(unit_cum_appx(t = 100, n = 1000000, r = .85))
{% endhighlight %}



{% highlight text %}
##    user  system elapsed 
##       0       0       0
{% endhighlight %}


We can also plot the cumulative learning curve for the unit model by changing the `level` argument to "c" for cumulative.


{% highlight r %}
plot_unit_curve(t = 100, m = 1, n = 125, r = .85, model = "u", level = "c")
{% endhighlight %}

<img src="http://bradleyboehmke.github.iofigure/source/learningcurve-package/2017-01-01-learningcurve-package/unnamed-chunk-10-1.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" style="display: block; margin: auto;" />


### unit_midpoint( )
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


### unit_block_summary( )
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


You can also plot this block summary with the `plot_block_summary()` function:




{% highlight r %}
plot_block_summary(t = 125, m = 201, n = 500, r = .75)
{% endhighlight %}

<img src="http://bradleyboehmke.github.iofigure/source/learningcurve-package/2017-01-01-learningcurve-package/unnamed-chunk-16-1.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" style="display: block; margin: auto;" />

<br>

## Cumulative Average Learning Curve Models
The following models represent Wright's cumulative average model which considers the average effect of learning over a number of units.

### ca_unit( )
The `ca_unit()` function computes the time (or cost) required for a specific unit using the cumulative average model.

$$y_{n} <- t_{m} * \frac{n^{1+b} - (n-1)^{1+b}}{m^{1+b} - (m-1)^{1+b}}$$

where:

- $$y_{n}$$ = time (or cost) required for the nth unit
- $$t_{m}$$ = time (or cost) required to produce the mth unit
- m = mth unit for which you have time (or cost) information (default is m = 1)
- n = nth unit for which you want to estimate time (or cost)
- b = natural slope of the learning curve rate

Similar to the unit models I built the cumulative average functions to take in learning rates and convert them to the corresponding natural slope ($$b$$).



**Example:** In a production situation where the CA model is being used, introduction of new hires to replace retirees seems to be affecting the learning slope. The effects seem to coincide approximately with production of unit 2,200. To structure a new learning curve from unit 2,200 on, the estimator wants to know the unit hours for unit 2,200. The hours for unit 1 were 110, and the learning rate for the units from 1 to 2,200 was 88.5%.


{% highlight r %}
ca_unit(t = 110, m = 1, n = 2200, r = .885)
{% endhighlight %}



{% highlight text %}
## [1] 23.34001
{% endhighlight %}

We can also plot the learning curve for the cumulative average model by changing the `model` argument to "ca" for cumulative average.


{% highlight r %}
plot_unit_curve(t = 100, m = 1, n = 125, r = .85, model = "ca", level = "u")
{% endhighlight %}

<img src="http://bradleyboehmke.github.iofigure/source/learningcurve-package/2017-01-01-learningcurve-package/unnamed-chunk-19-1.png" title="plot of chunk unnamed-chunk-19" alt="plot of chunk unnamed-chunk-19" style="display: block; margin: auto;" />

### ca_block( )
The `ca_block()` function computes total hours for a production block using the cumulative average model assuming the block begins at unit m and ends at unit n. 

$$ y_{m,n} <- t_{1} * (n^{1+b} - (m-1)^{1+b}) $$

where:

- $$y_{m,n}$$ = time (or cost) required for the nth unit
- $$t_{1}$$ = time (or cost) required to produce the first unit
- m = mth unit is considered the first unit of the production block being assessed
- n = nth unit is considered the last unit of the production block being assessed
- b = natural slope of the learning curve rate



**Example:** Production of the first 200 units of a product is nearing its end. Your customer has said he is willing to buy an additional 50 units. There will be no break in production or in learning. The first unit required 75 hours and the first 200 units had an 85% learning curve.  How many hours will the second block of 50 units require?


{% highlight r %}
ca_block(t = 75, m = 201, n = 250, r = .85)
{% endhighlight %}



{% highlight text %}
## [1] 806.772
{% endhighlight %}


And we can plot the cumulative learning curve for the cumulative average model by changing the `model` argument to "ca" for cumulative average and `level` argument to "c" for plotting cumulative hours (or costs) by unit.


{% highlight r %}
plot_unit_curve(t = 100, m = 1, n = 125, r = .85, model = "ca", level = "c")
{% endhighlight %}

<img src="http://bradleyboehmke.github.iofigure/source/learningcurve-package/2017-01-01-learningcurve-package/unnamed-chunk-22-1.png" title="plot of chunk unnamed-chunk-22" alt="plot of chunk unnamed-chunk-22" style="display: block; margin: auto;" />

<br>

## Delta Models
While the U and CA models are both based on the underlying power law formula, they are quite different in the way they work. As previously stated, the unit model looks at the learning effect as a phenomenon affecting each individual unit. Under this model, every unit requires fewer hours than the unit just before it. The cumulative average model, on the other hand, regards learning as a phenomenon affecting the average hours required for a sequence of production units. As the sequence increases in length, the average decreases.  

Both models have their proponents, and both have been found useful. The purpose here is not to advocate one or the other, but we did want to provide functions that allow the analyst to make certain comparisons to better understand predicted outputs.

### delta( )
This function computes the difference between the `unit_curve()` and `ca_curve()` which predicts the hours (or costs) for a specified unit.

**Example:**  Let’s assume that you expect the first unit to require 50 hours for a
particular product. Further, you are told to assume that the historical learning rate for your organization is 88.5%; however, you are not sure whether the learning rate is based on the unit model or the cumulative average model. You need to predict the total time required for the first 25 units but you also want to show decision makers the difference between the potential outcomes.



You can show the projected deltas for each unit and plot the unit level deltas

{% highlight r %}
delta(t = 50, m = 1, n = 25, r = .885, level = "u")
{% endhighlight %}



{% highlight text %}
##  [1] 0.000000 5.750000 6.103821 6.110519 6.041146 5.953271 5.863560
##  [8] 5.777401 5.696436 5.620942 5.550687 5.485263 5.424223 5.367136
## [15] 5.313606 5.263280 5.215844 5.171025 5.128579 5.088293 5.049980
## [22] 5.013473 4.978624 4.945304 4.913395
{% endhighlight %}



{% highlight r %}

plot_delta(t = 50, m = 1, n = 25, r = .885, level = "u")
{% endhighlight %}

<img src="http://bradleyboehmke.github.iofigure/source/learningcurve-package/2017-01-01-learningcurve-package/unnamed-chunk-24-1.png" title="plot of chunk unnamed-chunk-24" alt="plot of chunk unnamed-chunk-24" style="display: block; margin: auto;" />

or show the projected cumulative deltas at each unit along with plot the cumulative deltas:

{% highlight r %}
delta(t = 50, m = 1, n = 25, r = .885, level = "c")
{% endhighlight %}



{% highlight text %}
##  [1]   0.00000   5.75000  11.85382  17.96434  24.00549  29.95876
##  [7]  35.82232  41.59972  47.29615  52.91710  58.46778  63.95305
## [13]  69.37727  74.74440  80.05801  85.32129  90.53713  95.70816
## [19] 100.83674 105.92503 110.97501 115.98848 120.96711 125.91241
## [25] 130.82581
{% endhighlight %}



{% highlight r %}

plot_delta(t = 50, m = 1, n = 25, r = .885, level = "c")
{% endhighlight %}

<img src="http://bradleyboehmke.github.iofigure/source/learningcurve-package/2017-01-01-learningcurve-package/unnamed-chunk-25-1.png" title="plot of chunk unnamed-chunk-25" alt="plot of chunk unnamed-chunk-25" style="display: block; margin: auto;" />

### cum_error( )
The `cum_error()` function computes the approximate percent error in cumulative hours (or cost) due to an incorrect choice of learning curve 

$$y <- n^(b2 - b1) - 1$$

where:

- y = measure of error when learning curve r1 is erroneously when r2 should have been chosen
- b1 = natural learning curve rate slope
- b2 = natural learning curve rate slope to compare to r1

As in all the other models, this functions asks for the learning rate (*r*) and converts it into the appropriate natural slope (*b*).



**Example:** Assume you are predicting hours for a block of 250 units on a particular product.  Historically, your organization has had learning rates as low as 85% and as high as 87% on similar products. What is the potential error in your prediction by one of these two rates?  If you go with a learning rate of 85% and your organization performs at a learning rate of 87% then your error would be 20%.


{% highlight r %}
cum_error(n = 250, r1 = .85, r2 = .87)
{% endhighlight %}



{% highlight text %}
## [1] 0.2035303
{% endhighlight %}

## Aggregate Learning Curve Models
It is common for a large factory to track learning rates by department. Learning rates typically differ in diverse operations. When these rates are individually tracked,
it is possible for each department to have its own learning curve for a given
product. Estimators then can create separate estimates for each department
based on that department’s learning profile.

Contract negotiators and certain other analysts, on the other hand, typically deal
more with the "big picture." If the customer wants to change the production
quantity, or perhaps make certain other changes, they may not want to or have
the time to revisit the learning for each department. They want an aggregated
learning curve for the entire factory that is reasonably accurate at any production
quantity of the product. Aggregated learning curves can also be useful when
learning is applied to both labor and material.

### agg_curve( )
The `agg_curve()` approximates aggregate cumulative learning curve using data from multiple departments.

$$y_{1,2,...,i} = H_{1}*n^{B}$$

where:

- y = sum of all contributing hours (costs) from departments 1 through *i* to produce *n* total units
- H = total hours for the first unit across all departments
- n = total units to be produced across all departments
- B = composite natural slope aggregated across departments

Furthermore, B can be computed with: 

$$B = \frac{log(H, n) - log(H)}{log(n)}$$

Therefore, this function requires the following arguments:

- t = vector of hours (or costs) for the first unit from departments 1 through m
- r = vector of historical learning rates for departments 1 through m
- n = total units to be produced across all departments

**Example:** At a certain company, a project is expected to get underway soon to produce 300 widgets. Three departments will be involved. Historically, with similar projects, the learning curves for these departments have had slopes 85%, 87% and 80%, based on the
CA model. The first unit hours for these departments for the widget have been estimated at 70, 45, and 25. Predict the composite learning curve hourse for the entire effort.




{% highlight r %}
t <- c(70, 45, 25)
r <- c(.85, .87, .80)

agg_curve(t = t, r = r, n = 300)
{% endhighlight %}



{% highlight text %}
## [1] 11000.96
{% endhighlight %}

## Slope & Rate Models
Lastly, we include some models to do conversions between natural slopes (*b*) and rates (*r*) and also predict the natural slopes and rates based on historical performance.

### natural_slope( )
Provides the natural slope for given learning rates.

$$b <- \frac{log(r)}{log(2)}$$

where:

r - learning curve rate

**Example:** calculate the natural slope for learning rates of 80%, 85%, 90%




{% highlight r %}
natural_slope(r = c(.80, .85, .90))
{% endhighlight %}



{% highlight text %}
## [1] -0.3219281 -0.2344653 -0.1520031
{% endhighlight %}

### lc_rate( )
Provides the learning rate for given natural slopes

$$r = \frac{10^{(b * log10(2) + 2)}}{100}$$

where:

- b = natural slope

**Example:** calculate the learning rates of natural slopes -.19, -.22, -.25




{% highlight r %}
lc_rate(b = c(-.19, -.22, -.25))
{% endhighlight %}



{% highlight text %}
## [1] 0.8766057 0.8585654 0.8408964
{% endhighlight %}

### natural_slope_est( )
The `natural_slope_est()` function computes the natural slope of a production block when the total units produced, total time of block production, and the time for the first unit are known.

$$b <- \frac{log(T) - log(t)}{log(n) - 1}$$

where: 

- T = total time (or cost) required to produce the first n units
- t = time (or cost) required to produce the first unit
- n = total n units produced

**Example:** Estimate the natural slope for 250 units when the time for unit 1 took 80 hours and the total time for all 250 units took 8,250 hours.




{% highlight r %}
natural_slope_est(T = 8250, t = 80, n = 250)
{% endhighlight %}



{% highlight text %}
## [1] -0.1603777
{% endhighlight %}


### lc_rate_est( )
The `lc_rate_est()` function computes the learning rate of a production block when the total units produced, total time of block production, and the time for the first unit are known. First, *b* is calculated per the `natural_slope_est()` function and then *b* is fed into the same function performed by `lc_rate()`

**Example:** Estimate the learning rate for 250 units when the time for unit 1 took 80 hours and the total time for all 250 units took 8,250 hours.





{% highlight r %}
lc_rate_est(T = 8250, t = 80, n = 250)
{% endhighlight %}



{% highlight text %}
## [1] 0.8947908
{% endhighlight %}


## Summary
And there you have it.  Between the unit, cumulative average, delta, aggregate, slope & learning curve, and plotting functions we have 17 functions to kick start the package. We acknowledge that there is much work to be done with this package; however, significant improvements can be made if more academic and practitioner contributors help in the package’s advancement.  We openly invite users of this package to provide feedback for advancements in algorithms and how the functions are executed.
