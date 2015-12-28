---
layout: page
title: NULL
---

[R Vocab Topics](index) &#187; [Dates](dates) &#187; Getting the current date & time

To get current date and time information:


```r
Sys.timezone()
## [1] "America/New_York"

Sys.Date()
## [1] "2015-09-24"

Sys.time()
## [1] "2015-09-24 15:08:57 EDT"
```

<br>

If using the `lubridate` package:


```r
library(lubridate)

now()
## [1] "2015-09-24 15:08:57 EDT"
```

<br>

<small><a href="#">Go to top</a></small>
