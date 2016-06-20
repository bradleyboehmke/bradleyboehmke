---
layout: post
title:  Potential for an EVM package
date: 2016-06-15
published: true
tags: [example1, example2]
---

Earned Value Management (EVM) is one of DoD's and industry's most popular program planning and management tools. The purpose of EVM is to ensure sound planning and resourcing of all tasks required for contract performance. It promotes an environment where contract execution data is shared between project personnel and government oversight staff and in which emerging problems are identified, pinpointed, and acted upon as early as possible. EVM provides a disciplined, structured, objective, and quantitative method to integrate technical work scope, cost, and schedule objectives into a single cohesive contract baseline plan called a Performance Measurement Baseline for tracking contract performance.[^acq]

With the Air Force and DoD quickly accepting the R programming language, I think there's a lot of fruit to be had by developing an EVM R package that can be used by acquisition analysts.

**The project:** Develop an R package that performs basic EVM computations. We’ll (Jason Freels will likely contribute) start with a simple package that captures the [common EVM formulas](http://edward-designer.com/web/pmp-earned-value-questions-explanined/) and a few plotting capabilities. The goal is to have a package ready for submission to CRAN by late August. We created a skeleton package and GitHub [repository](https://github.com/bradleyboehmke/evmR) to initiate the project.




[^acq]: http://www.acq.osd.mil/evm/
