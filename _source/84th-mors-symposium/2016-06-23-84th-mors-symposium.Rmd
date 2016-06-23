---
layout: post
title:  84th MORS Symposium
date: 2016-06-23
author: Bradley Boehmke
published: true
categories: [blog]
tags: [conferences]
---

This week I attended the 84<sup>th</sup> MORS Symposium at the Marine University, Quantico, VA.  The conference was well organized (as usually) and I had a few good take-aways from some interesting sessions.  I also presented my work on [Effectiveness vs. Efficiency of Air Force Installation Support Activities Using Data Envelopment Analysis](https://www.dropbox.com/s/3dlwmgvxmxe1ndg/Workshop_Presentation.pdf?dl=0), which went well and I got good feedback on.  The following are some mental notes taken in a few particularly interesting presentations that I may want to reference later on.


### Using Innovative Text Analytics on a Military Specific Corpus
Authors: Prof. Theodore Allen, Maj Nathan Parker, Zhenhuan Sui

Lead investigator (and presenter): Theodore Allen (allen.515@osu.edu)

Provided an interesting concept of injecting subject matter expert insights within text analysis.  Their modeling approach performed the typical text n-gram analysis but then allowed SMEs to input whether the words were relevant for the topic they were attributed to or whether they were not.  So, in essence, their model identified common topics/themes in the text, the words associated with those themes and then allowed SMEs to make “edits” whether particular words were relevant for those topics or not.  They called it SMERT (don’t remember what the acronym stands for).  

I see potential for the AFICA contract text analysis: identify the common topics (categories) identified in the contract description field, identify the words related to those categories, but also allow contracting SMEs to provide inputs on whether some words are relevant or not for those categories. We could then let these inputs influence future modeling

GitHub website referenced in work that may be worth looking at: http://chdoig.github.io/pytexas2015-topic-model



### Make America Great Again
Presenter: Ian Kloo

Ian presented an application that allows you to search for a specific phrase, the model then searches specific media news outlets for that phrase or similar phrases.  Basically breaks the phrase down to 1-5 grams, applies a [Jaro Winkler score](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) to measure the distance between the news phrase and the specified phrase, and then returns visualizations relating to the growth/usage of that phrase over time and the news articles where that phrase (or very similar ones) were used.

I definitely want to look into the Jaro Winkler score.  It allows you to identify non-exact matches to the input phrase.  If you put in “Make America Great Again” and the a media outlet used “Make America Strong Again” this would produce a high Jaro Winkler score suggesting high relevance between the terms.  This can significantly help with misspellings or slightly different semantics.   

I also need to look at [Wordnet](https://wordnet.princeton.edu/) for synonyms. Wordnet can be linked to R.



### History of Operations Research in the US Air Force
Authors: Dr. Gallagher & Dr. Allen

Presenter: Dr. Gallagher

Really interesting historical account of OR in the Air Force. They have a working paper that I need to reach out to Dr. Gallagher about.


### Text Analytics for Defense Applications
Presenter: Dr. James Wisnowski (james.wisnowski@adsurgo.com)

Did scraping in R and then did the text analytics in JMP. Built an add-in that automates their text analytics.  Illustrated with their app. Can identify the words most associated with others (i.e. words most associated with fatal to identify which attributes of accidents lead to fatalities).  Provided a demo of clustering words – so identifying words that are together the most in documents.



