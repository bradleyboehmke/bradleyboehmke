---
layout: post
title:  Scraping Tabular and Excel Files Stored Online
date: 2015-12-04
published: true
tags: [r, gdata, xml, data importing, web scraping]
categories: [r, gdata, xml, data importing, web scraping]
---

<a href="http://bradleyboehmke.github.io/2015/12/scraping-tabular-data.html"><img src="http://www.rcsb.org/pdb/general_information/releases/1504_images/icons/BatchDownloadTool.png" alt="Importing Online Data" style="float:left; margin:0px 5px 5px 0px; width: 8%; height: 8%;"></a>
The most basic form of getting data from online is to import tabular (i.e. .txt, .csv) or Excel files that are being hosted online. This is often not considered *web scraping*<sup><a href="#fn1" id="ref1">1</a></sup>; however, I think its a good place to start introducing the user to interacting with the web for obtaining data. In this post I cover some of the common approaches applied for importing spreadsheet files via R.<!--more--> 

<br>

## tl;dr
Not enough time to peruse this whole post? That’s fine; here's what I cover in a nutshell. Feel free to jump to specific sections.

* [CSV](#CSV-Files): Downloading .csv files is no different than importing locally managed .csv files
* [Excel](#Excel-Files): Use `gdata` to easily download online Excel files
* [ZIP](#ZIP-Files): You can download and extract .zip files in a conventional manner; however, I also provide an efficient approach to temporarily download the .zip file, extract the desired data, and then discard the .zip file.
* [Multiple files](#Multiple-Files): Need to download multiple files from a website? Snag the HTML links with `XML`, perform a little string manipulation, and download with a `for` loop.

<br>

## CSV-Files




