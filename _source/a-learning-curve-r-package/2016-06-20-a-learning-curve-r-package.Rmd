---
layout: post
title:  A Learning Curve R Package
date: 2016-06-10
author: Bradley Boehmke
published: true
categories: [learningCurve]
tags: [programming]
---


Learning curves are steep in history and have several alternate names such as improvement
curves, progress curves, startup functions, and efficiency curves. The "learning effect" was first noted in the 1920s in connection with aircraft production. It use was amplified by experience in connection with aircraft production in WW II. Initially, it was thought to be solely due to the learning of the workers as they repeated their tasks. Later, it
was observed that other factors probably entered in, such as improved tools and working conditions, and various management initiatives. Regardless of the exact, or more likely combined, phenomenon we can group these factors together under the general heading of “learning.”

The underlying notion behind learning curves is that when people individually or collectively repeat an activity, there tends to be a gain in efficiency. Generally, this takes the form of a decrease in the time needed to do the activity. Because cost is generally related to time or labor hours consumed, learning curves are very important in industrial cost analysis. A key idea underlying the theory is that every time the production quantity doubles, we can expected a more or less fixed percentage decrease in the effort required to build a single unit (the Crawford theory), or in the average time required to build a group of units (the Wright theory). These decreases occur not in big jumps, but more or less smoothly as production continues

Consequently, mathematical models are used to represent learning curves by computing the efficiencies gained when an activity is repeated. I've used learning curves in many life cycle forecasting models but we usually built them into our Excel spreadsheet models. With R becoming more accepted in the Air Force and other DoD services that heavily rely on learning curves in their acquisition cost modeling, I was surprised to see that no R package has been built to compute, simulate, fit, and plot unit and cumulative average learning curves.

**The project:** [Jason Freels](https://github.com/Auburngrads) and I sat down to discuss building an R package that performs basic learning curve computations. We'll start with a simple package that captures the common unit and cumulative average models, a couple comparison models, and a few plotting capabilities. The idea is to get a quick turn-around to have a package ready for submission to [CRAN](https://cran.r-project.org/) by mid-to-late July. We created a skeleton package and GitHub [repository](https://github.com/bradleyboehmke/learningCurve) to initiate the project.



