---
layout: post
title:  Scraping HTML Tables
date: 2015-12-21
published: true
tags: [r, rvest, xml, web-scraping]
---

<STYLE TYPE="text/css"> 
<!-- 
        .indented { 
                padding-left: 25pt; 
                padding-right: 50pt; 
                } 
--> 
</STYLE>

<a href="http://bradleyboehmke.github.io//2015/12/scraping-html-tables.html"><img src="https://analystatlarge.files.wordpress.com/2014/05/result.png" alt="Scraping HTML Tables" style="float:left; margin:0px 8px 0px 0px; width: 10%; height: 10%;"></a>
With my previous two blog posts I implicitly started a series that covers common web scraping capabilities offered by R. In my first [post](http://bradleyboehmke.github.io//2015/12/scraping-tabular-and-excel-files-stored-online.html) I covered how to import tabular (i.e. .txt, .csv) or Excel files that are hosted online and in my last [post](http://bradleyboehmke.github.io//2015/12/scraping-html-text.html) I covered text scraping. In this post I cover how to scrape data from another common structure of data storage on the Web - HTML tables.<!--more--> 


## tl;dr
Time deficient? Here's the synopsis. This tutorial reiterates some of the information from my previous text scraping [post](http://bradleyboehmke.github.io//2015/12/scraping-html-text.html); however, I focus solely on scraping data from HTML tables. To demonstrate, I focus on the [BLS employment statistics webpage](http://www.bls.gov/web/empsit/cesbmart.htm) and illustrate: 

<P CLASS="indented">
        <a href="#rvest">&#9312;</a> How to use <code>rvest</code> to extract all tables or only specified ones along with correcting for split heading tables.
        <br>
        <a href="#xml">&#9313;</a> Similarly, how to use <code>xml</code> to extract all or only specified tables along with exhibiting some of its handy arguments such as specifying column names, classes, and skipping rows.
</P>

<br>

<a name="rvest"></a>

## &#9312; Scraping HTML Tables with rvest


<br>

<a name="xml"></a>

## &#9313; Scraping HTML Tables with XML

