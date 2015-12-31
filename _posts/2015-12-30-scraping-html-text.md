---
layout: post
title:  Scraping HTML Text
date: 2015-12-14
published: true
tags: [r, rvest, web-scraping]
categories: [r, rvest, web-scraping]
---

<a href="http://bradleyboehmke.github.io/2015/12/scraping-tabular-and-excel-files-stored-online.html"><img src="http://d1u2s20mo6at4b.cloudfront.net/wp-content/uploads/HTML.jpg" alt="Scraping HTML Text" style="float:left; margin:0px 8px 0px 0px; width: 17%; height: 17%;"></a>
Vast amount of information exists across the interminable webpages that exist online.  Much of this information are "unstructured" text that may be useful in our analyses.  This post covers the basics of scraping these texts from online sources.<!--more-->  Throughout this section I will illustrate how to extract different text components of webpages by dissecting the [Wikipedia page on web scraping](https://en.wikipedia.org/wiki/Web_scraping).  However, its important to first cover one of the basic components of HTML elements as we will leverage this information to pull desired information. I offer only enough insight required to begin scraping; I highly recommend [*XML and Web Technologies for Data Sciences with R*](http://www.amazon.com/XML-Web-Technologies-Data-Sciences/dp/1461478995) and [*Automated Data Collection with R*](http://www.amazon.com/Automated-Data-Collection-Practical-Scraping/dp/111883481X/ref=pd_sim_14_1?ie=UTF8&dpID=51Tm7FHxWBL&dpSrc=sims&preST=_AC_UL160_SR108%2C160_&refRID=1VJ1GQEY0VCPZW7VKANX) to learn more about HTML and XML element structures.
