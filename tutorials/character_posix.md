---
layout: page
title: NULL
---

[R Vocab Topics](index) &#187; [Character Strings](characters) &#187; [Regular Expressions](regex) &#187; [Regex Syntax](regex_syntax) &#187; POSIX

Closely related to regex [character classes](character_class) are POSIX character classes which are expressed in double brackets [[ ]].


<center>
<img src="/public/images/r_vocab/posix.png" alt="POSIX Character Classes">
</center>    


The following provides examples to show how to use the anchor syntax to match POSIX character classes:


```r
x <- "I like beer! #beer, @wheres_my_beer, I like R (v3.2.2) #rrrrrrr2015"

gsub(pattern = "[[:blank:]]", replacement = "", x)
## [1] "Ilikebeer!#beer,@wheres_my_beer,IlikeR(v3.2.2)#rrrrrrr2015"

gsub(pattern = "[[:punct:]]", replacement = " ", x)
## [1] "I like beer   beer   wheres my beer  I like R  v3 2 2   rrrrrrr2015"

gsub(pattern = "[[:alnum:]]", replacement = "", x)
## [1] "  ! #, @__,    (..) #"
```
&#9755; *For information on the `gsub` function visit the [main regex functions page](main_regex_functions).*




