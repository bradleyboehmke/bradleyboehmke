---
layout: page
title: NULL
---

[R Vocab Topics](index) &#187; [Importing, Scraping, and exporting data](data_inputs_outputs) &#187; [Scraping data](scraping_data) &#187; Working with APIs

<br>

In this tutorial I cover how to scrape data from another common structure of data storage on the Web - HTML tables. This tutorial reiterates some of the information from the [previous tutorial](scraping_data_html_text); however, we focus solely on scraping data from HTML tables. The simplest approach to scraping HTML table data directly into R is by using either the <a href="#rvest">`rvest` package</a> or the <a href="#xml">`XML` package</a>.    To illustrate, I will focus on the [BLS employment statistics webpage](http://www.bls.gov/web/empsit/cesbmart.htm) which contains multiple HTML tables from which we can scrape data. 

<br>

<a name="rvest"></a>

## Scraping HTML tables with rvest
