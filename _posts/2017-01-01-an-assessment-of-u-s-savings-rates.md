---
layout: post
title:  An Assessment of U.S. Savings Rates
date: "2016-09-14"
published: true
tags: [r, analytics, economics]
---

<a href="http://bradleyboehmke.github.io"><img src="http://bradleyboehmke.github.io/figure/source/an-assessment-of-u-s-savings-rates/2017-01-01-an-assessment-of-u-s-savings-rates/header.png" alt="U.S." style="float:left; margin: 0px 10px -5px 0px; width: 20%; height: 20%;"></a>
Per capita income and expenditures provide crucial insight into the average standard of living in specified areas. Disposable per capita income measures the average income earned after taxes per person in a given area (city, state, country, etc.) in a specified year. It is calculated by dividing the area's total income after tax by its total population. Per capita expenditures, on the other hand, measures the average outlay for goods and services by person and provides insight into spending patterns across a given area.  Together, the assessment of per capita income versus expenditures can provide better understanding of regional economies, differences in standard of living, and approximate savings rates. <!--more-->

This post involves exploring [Bureau of Economic Analysis](http://www.bea.gov/index.htm) data regarding [per capita disposable income](http://www.bea.gov/iTable/iTableHtml.cfm?reqid=70&step=30&isuri=1&7022=21&7023=0&7024=non-industry&7033=-1&7025=0&7026=00000,01000,02000,04000,05000,06000,08000,09000,10000,11000,12000,13000,15000,16000,17000,18000,19000,20000,21000,22000,23000,24000,25000,26000,27000,28000,29000,30000,31000,32000,33000,34000,35000,36000,37000,38000,39000,40000,41000,42000,44000,45000,46000,47000,48000,49000,50000,51000,53000,54000,55000,56000&7027=-1&7001=421&7028=53&7031=0&7040=-1&7083=levels&7029=23&7090=70) (hereafter referred to as PCI) and [per capita personal expenditures](http://www.bea.gov/iTable/iTableHtml.cfm?reqid=70&step=10&isuri=1&7003=2&7035=-1&7004=x&7005=1&7006=00000,01000,02000,04000,05000,06000,08000,09000,10000,11000,12000,13000,15000,16000,17000,18000,19000,20000,21000,22000,23000,24000,25000,26000,27000,28000,29000,30000,31000,32000,33000,34000,35000,36000,37000,38000,39000,40000,41000,42000,44000,45000,46000,47000,48000,49000,50000,51000,53000,54000,55000,56000&7036=-1&7001=62&7002=6&7090=70&7007=-1&7093=levels) (hereafter referred to as PCE). The PCI data provides annual (non-inflation adjusted) per capita disposable income at the national and state-level from 1948-2015 and the PCE data provides annual (non-inflation adjusted) per capita personal consumption expenditures at the national and state-level from 1997-2014. Consequently, this research seeks to identify how the national and state-level savings rates defined as $$Savings = PCI - PCE$$ has changed over time and by geographic location.

The analysis finds that the national-level and average state-level savings rates have remained around 7-8% since 1997. Furthermore, we find that American's are not making fundamental shifts in their earnings and expenditure rates. However, the analysis does uncover a noticable shift in the disparity of savings rates across the states in recent years with much of the growth in savings rates being concentrated in the central U.S. states - from the Dakotas down to Oklahoma, Texas and Louisiana. Consequently, it appears that the often neglected fly-over states offer Americans greater opportunities to save than the eastern and western states.


## Packages Required

To reproduce the code and results throughout this project you will need to load the following packages.


```r
library(rvest)        # scraping data
library(tidyr)        # creating tidy data
library(dplyr)        # transforming (joining, summarizing, etc.) data
library(tibble)       # coercing data to tibbles
library(magrittr)     # for piping capabilities
library(DT)           # for printing nice HTML output tables
library(ggplot2)      # visualizing data
library(ggrepel)      # Repel overlapping text labels in plots
```


## Data Preparation

Prior to assessing how PCI, PCE, and savings rates have behaved over time and by geographic location we must acquire and clean the data.

### Loading Data

The data for this project originated from the following sources:

- PCI data: [http://bit.ly/2dpEPY1](http://bit.ly/2dpEPY1) 
- PCE data: [http://bit.ly/2dhC89U](http://bit.ly/2dhC89U)

To identify the HTML link to scrape this data follow these steps:

1. Using the links above go to the page displaying either the PCI or PCE data
2. Right click the **Download** icon and select **Copy Link Address**
3. Paste copied link into browser window
4. Right click the **Download CSV File** icon and select **Copy Link Address**
5. Use the copied link address as the URL to scrape



```r
#####################
# download PCI data #
#####################
# url for PCI HTML table
url_pci <- read_html("http://www.bea.gov/iTable/iTableHtml.cfm?reqid=70&step=30&isuri=1&7022=21&7023=0&7024=non-industry&7033=-1&7025=0&7026=00000,01000,02000,04000,05000,06000,08000,09000,10000,11000,12000,13000,15000,16000,17000,18000,19000,20000,21000,22000,23000,24000,25000,26000,27000,28000,29000,30000,31000,32000,33000,34000,35000,36000,37000,38000,39000,40000,41000,42000,44000,45000,46000,47000,48000,49000,50000,51000,53000,54000,55000,56000&7027=-1&7001=421&7028=53&7031=0&7040=-1&7083=levels&7029=23&7090=70")

# download PCI table and extract the data frame from the list
pci_raw <- url_pci %>%
  html_nodes("table") %>%
  .[2] %>%
  html_table(fill = TRUE) %>%
  .[[1]]

#####################
# download PCE data #
#####################
# url for PCE HTML table
url_pce <- read_html("http://www.bea.gov/iTable/iTableHtml.cfm?reqid=70&step=10&isuri=1&7003=2&7035=-1&7004=x&7005=1&7006=00000,01000,02000,04000,05000,06000,08000,09000,10000,11000,12000,13000,15000,16000,17000,18000,19000,20000,21000,22000,23000,24000,25000,26000,27000,28000,29000,30000,31000,32000,33000,34000,35000,36000,37000,38000,39000,40000,41000,42000,44000,45000,46000,47000,48000,49000,50000,51000,53000,54000,55000,56000&7036=-1&7001=62&7002=6&7090=70&7007=-1&7093=levels")

# download PCE table and extract the data frame from the list
pce_raw <- url_pce %>%
  html_nodes("table") %>%
  .[2] %>%
  html_table(fill = TRUE) %>%
  .[[1]]
```


### Creating Tidy Data

Once the basic data has been acquired we need to pre-process it to get the data into a [tidy format](http://vita.had.co.nz/papers/tidy-data.html). This includes removing punctuations, changing the income and expenditure data from character to a numeric data type, reducing the data sets to the same time period (1997-2014), making sure the common variables share the same names, and changing the data from a wide format to a long format.  Once this has been done for both the PCI and PCE data we can merge the clean data frames into one common data frame (titled *data_clean*) and create a new *Savings* variable ($Savings = Income - Expenditures$).  I also remove the District of Columbia location since this is more comparable to metropolitan-level geographic areas than state-level geographic areas. We now have the data cleaned, in a tidy format, and ready to analyze as Table 1 illustrates.


```r
# create tidy PCI data
pci_clean <- pci_raw %>% 
  apply(2, function(x) gsub("[[:punct:]]", "", x)) %>%
  as_tibble(.) %>%
  group_by(GeoFips, GeoName) %>%
  mutate_each(funs(as.numeric)) %>%
  ungroup() %>%
  select(Fips = GeoFips, Location = GeoName, `1997`:`2014`) %>%
  gather(Year, Income, -c(Fips, Location))


# create tidy PCE data 
pce_clean <- pce_raw %>% 
  apply(2, function(x) gsub("[[:punct:]]", "", x)) %>%
  as_tibble(.) %>%
  group_by(Fips, Area) %>%
  mutate_each(funs(as.numeric)) %>%
  ungroup() %>%
  rename(Location = Area) %>%
  gather(Year, Expenditures, -c(Fips, Location))

# create tidy merged data frame
data_clean <- pci_clean %>%
  left_join(pce_clean) %>%
  mutate(Savings = Income - Expenditures,
         Year = as.numeric(Year)) %>%
  filter(Location != "District of Columbia")

datatable(data_clean, caption = 'Table 1: Clean and tidy data.')
```

<!--html_preserve--><div id="htmlwidget-7090" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-7090">{"x":{"filter":"none","caption":"<caption>Table 1: Clean and tidy data.\u003c/caption>","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239","240","241","242","243","244","245","246","247","248","249","250","251","252","253","254","255","256","257","258","259","260","261","262","263","264","265","266","267","268","269","270","271","272","273","274","275","276","277","278","279","280","281","282","283","284","285","286","287","288","289","290","291","292","293","294","295","296","297","298","299","300","301","302","303","304","305","306","307","308","309","310","311","312","313","314","315","316","317","318","319","320","321","322","323","324","325","326","327","328","329","330","331","332","333","334","335","336","337","338","339","340","341","342","343","344","345","346","347","348","349","350","351","352","353","354","355","356","357","358","359","360","361","362","363","364","365","366","367","368","369","370","371","372","373","374","375","376","377","378","379","380","381","382","383","384","385","386","387","388","389","390","391","392","393","394","395","396","397","398","399","400","401","402","403","404","405","406","407","408","409","410","411","412","413","414","415","416","417","418","419","420","421","422","423","424","425","426","427","428","429","430","431","432","433","434","435","436","437","438","439","440","441","442","443","444","445","446","447","448","449","450","451","452","453","454","455","456","457","458","459","460","461","462","463","464","465","466","467","468","469","470","471","472","473","474","475","476","477","478","479","480","481","482","483","484","485","486","487","488","489","490","491","492","493","494","495","496","497","498","499","500","501","502","503","504","505","506","507","508","509","510","511","512","513","514","515","516","517","518","519","520","521","522","523","524","525","526","527","528","529","530","531","532","533","534","535","536","537","538","539","540","541","542","543","544","545","546","547","548","549","550","551","552","553","554","555","556","557","558","559","560","561","562","563","564","565","566","567","568","569","570","571","572","573","574","575","576","577","578","579","580","581","582","583","584","585","586","587","588","589","590","591","592","593","594","595","596","597","598","599","600","601","602","603","604","605","606","607","608","609","610","611","612","613","614","615","616","617","618","619","620","621","622","623","624","625","626","627","628","629","630","631","632","633","634","635","636","637","638","639","640","641","642","643","644","645","646","647","648","649","650","651","652","653","654","655","656","657","658","659","660","661","662","663","664","665","666","667","668","669","670","671","672","673","674","675","676","677","678","679","680","681","682","683","684","685","686","687","688","689","690","691","692","693","694","695","696","697","698","699","700","701","702","703","704","705","706","707","708","709","710","711","712","713","714","715","716","717","718","719","720","721","722","723","724","725","726","727","728","729","730","731","732","733","734","735","736","737","738","739","740","741","742","743","744","745","746","747","748","749","750","751","752","753","754","755","756","757","758","759","760","761","762","763","764","765","766","767","768","769","770","771","772","773","774","775","776","777","778","779","780","781","782","783","784","785","786","787","788","789","790","791","792","793","794","795","796","797","798","799","800","801","802","803","804","805","806","807","808","809","810","811","812","813","814","815","816","817","818","819","820","821","822","823","824","825","826","827","828","829","830","831","832","833","834","835","836","837","838","839","840","841","842","843","844","845","846","847","848","849","850","851","852","853","854","855","856","857","858","859","860","861","862","863","864","865","866","867","868","869","870","871","872","873","874","875","876","877","878","879","880","881","882","883","884","885","886","887","888","889","890","891","892","893","894","895","896","897","898","899","900","901","902","903","904","905","906","907","908","909","910","911","912","913","914","915","916","917","918"],["    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000","    0"," 1000"," 2000"," 4000"," 5000"," 6000"," 8000"," 9000","10000","12000","13000","15000","16000","17000","18000","19000","20000","21000","22000","23000","24000","25000","26000","27000","28000","29000","30000","31000","32000","33000","34000","35000","36000","37000","38000","39000","40000","41000","42000","44000","45000","46000","47000","48000","49000","50000","51000","53000","54000","55000","56000"],["United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","United States","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"],[1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1997,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1998,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,1999,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2001,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2002,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2003,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2004,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2005,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2006,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2007,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2008,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2011,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2012,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2013,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014,2014],[22536,19050,24803,19956,17954,23430,23593,29178,23032,22538,21098,23202,18803,24527,20891,21408,21851,18666,18837,20307,24740,26141,22350,22964,17277,21461,18037,21921,24149,24524,28179,18160,25829,21091,19110,21672,18529,21445,22602,22523,19032,20523,20896,21172,18593,20900,23773,24052,17452,21814,20949,23771,20102,25596,21089,18822,24894,25434,31102,25308,23809,22533,23523,20019,25695,22360,22309,22993,19559,19669,21481,26610,27285,23490,24652,18091,22265,19189,23229,25370,26582,29496,18869,26867,21959,21123,22748,19284,22409,23666,23848,20022,22034,22652,22505,19433,22345,24854,25639,18204,23169,22170,24646,20625,26316,21679,19423,25714,26705,32630,27047,24589,23461,24465,20829,26560,23151,22782,23599,20216,20102,22463,27992,28737,24631,25799,18524,23014,19503,24145,26410,27807,30450,19095,28093,22706,21472,23469,19583,22942,24609,24680,20707,22884,23276,23285,20070,23631,26054,26623,18749,24080,23642,26224,21526,28212,22891,20220,27344,28892,35195,29837,26036,24794,25821,21962,28429,24670,24344,24757,21742,21177,23859,30025,31111,26271,27419,19447,24412,20609,25350,27787,30632,33066,20488,29898,23696,23491,24559,21083,24399,26258,26126,21988,24248,24455,24785,21064,25227,27841,28371,19908,25610,25004,27195,22198,29449,23489,21215,28432,30062,36898,32611,27110,25717,26709,22743,29435,25172,25074,25619,22350,22593,25111,31401,32986,26790,28421,20571,25078,21513,26504,28573,32301,34202,21899,30606,24088,23989,25265,22298,24988,27194,27381,22572,25202,24883,26043,21771,26804,29068,29145,21026,26809,26717,28151,23001,31096,24395,21898,29682,30710,38294,33690,28188,26579,28122,23690,30403,25774,26144,26228,23131,23508,26331,32751,34280,27299,29413,21151,26016,22456,27481,29016,33429,35952,22722,31814,24597,24988,26014,23088,25467,28284,28976,23381,25594,25733,26494,22482,27802,30055,30142,22220,27942,28182,29230,24137,32627,25515,23257,31178,31380,39124,34252,29334,27503,29372,24317,31223,26425,26809,27191,23757,24328,27728,34176,35453,28086,31048,22019,27203,23979,29374,30121,34198,37180,23629,32726,25536,27359,27037,24240,26497,29506,30644,24135,28214,26811,27280,23173,29185,31804,31334,22703,28643,30214,30731,25945,33931,27120,24521,33304,32095,40949,34856,30891,28676,31111,25851,32412,27483,29114,27678,25190,25339,29063,36434,37258,29008,32853,23330,28649,25612,30470,31996,36157,38738,24900,34180,27549,27470,28238,26098,27952,31376,32001,25310,29970,28202,28046,24332,30936,33727,33558,23484,29778,31798,31803,26984,35654,28864,25373,34550,33590,42426,34739,32376,29673,32560,26279,33336,27823,29544,28829,26016,27057,29338,37594,38572,29425,33090,24585,29127,26813,30816,34283,37048,39454,26125,35276,28746,28889,28810,28024,28383,32242,32849,26092,31243,28923,29752,25633,31134,35389,34216,24163,30367,34187,33600,28137,37265,30919,26527,36841,35143,45580,36388,34565,30728,34385,27893,35290,29213,31023,31421,27283,30217,30721,39651,41397,30083,34356,25383,30506,28485,31781,35444,39479,41893,27378,37278,30272,29766,30155,30515,30301,33670,34657,27406,32268,30072,31542,27574,33006,37288,36321,25767,31927,37916,34869,29213,39623,31866,27849,37747,36508,48106,36705,35495,31370,35942,28969,36893,29899,32802,33444,28163,32179,31748,40634,42508,30853,35789,26806,31580,30040,33932,35635,40503,43204,28499,39261,31822,32799,31230,31374,31474,35419,36083,28567,35472,31054,32915,29052,34536,38853,38626,26456,33149,39014,36128,30049,43189,32169,28896,38368,37281,51629,36832,35685,31359,37620,29685,37929,31344,34805,36587,29439,33906,33103,42787,44544,31756,37330,27925,33126,31685,36050,34869,41687,44886,30325,40051,33745,37093,32453,34758,32572,36971,37198,29642,37919,32393,35287,30284,36501,39884,40408,28080,34290,42752,35624,30069,43303,31172,28756,37847,35814,53176,37328,34171,31306,37923,28940,36971,31135,34152,35694,29476,33346,33751,43323,45439,31098,36404,27728,33241,31304,35911,33251,42221,44947,29916,40656,32701,36826,32315,32064,31894,36776,37202,29119,36965,32448,33873,28773,36892,39593,38620,28747,34352,39962,36275,30936,44863,30842,29131,38534,35619,54342,37018,35524,31436,38218,29174,37402,31914,34559,35516,30054,34278,34232,44189,46514,32045,37446,28245,33459,32387,36927,33727,43313,45454,30581,41431,32084,39835,32821,32957,31990,37819,38758,29540,38302,33295,34808,28857,37448,40436,38746,29325,34825,41302,37796,31565,47130,31656,30707,40282,37859,54967,38966,36826,33004,38912,30346,38505,33568,36867,38231,31137,34920,35168,45611,47585,33648,39166,29353,34350,34173,40727,34579,45034,46805,31833,43131,32737,43592,34700,34821,33095,39231,39630,30762,41273,34678,37012,30441,39282,41908,40047,30729,36392,44819,39460,32395,48456,32752,32947,42401,39824,55899,38888,37180,33157,40315,31586,40129,35122,38321,40410,32218,36446,35993,46807,49509,34729,41489,30378,35958,35877,41593,35575,47339,48559,32510,46001,34811,50214,36032,37292,34681,41017,41512,32113,41393,35910,39197,31985,40738,43678,43013,31670,38042,46904,39165,32429,46822,32924,32496,41859,41071,53921,38881,36583,33078,40029,32296,40587,35155,38672,41115,31965,36235,35596,45626,48489,34849,40890,30575,35610,35293,41094,34808,46652,47927,31548,45669,33697,49336,36161,38613,34533,40833,41146,31826,40730,35661,38991,32165,40991,42448,42942,31316,37830,46812,40815,33513,49733,34276,33930,43851,43561,56141,40212,38317,34524,41686,33574,42208,36350,39801,41589,33240,37778,37062,46812,50328,36417,42484,31354,36673,36028,43235,36410,48307,49906,33317,47373,35078,51302,37481,40857,36419,42404,42568,33290,41788,36892,41038,33535,42282,43848,45086,32273,39426,49861],[20384,17243,23320,19223,16151,20848,22605,25122,22335,20445,19278,22032,17608,21562,19271,19133,18606,17506,17065,20843,22098,25397,20847,22956,15184,20437,18219,19397,20216,23889,24263,17816,22106,18581,19535,19786,16725,20837,20304,20632,17814,18648,19036,18979,18525,22231,20410,21391,16409,20092,19303,21387,17902,24245,20061,16909,21776,23926,26605,23482,21401,20112,22492,18335,22569,20219,20130,19671,18379,17896,22274,23200,26769,21798,24011,15990,21359,19223,20288,20771,25171,25521,18683,23215,19131,20429,20839,17505,21744,21368,21562,18681,19580,19884,20045,19329,23337,21598,23376,17205,21078,20445,22591,18780,25544,21131,17887,23129,25575,28186,24926,22252,21282,23348,19401,23597,21327,21231,20833,19348,18663,23690,24516,28220,23108,25683,16958,22513,20395,21408,22178,26662,26863,19659,24560,20281,21378,21999,18331,22976,22607,22501,19764,20672,20944,21162,20284,24549,23180,24831,18211,22381,21679,24061,19677,27471,22398,19013,24870,27578,29551,26170,23710,22624,24763,20676,25338,22465,22448,22122,20574,19629,24919,26228,30408,24310,27582,17900,23624,21670,22733,23284,28412,28768,20729,26129,21489,22727,23391,19483,24304,24121,24357,20846,21747,22071,22663,21339,26100,24841,26476,19352,23591,22990,24914,20331,28884,22992,19627,25722,28546,30730,27350,24553,23211,25582,21197,26124,23198,23025,22879,21137,20378,26133,27425,31831,24989,28515,18628,24477,22773,23813,24054,29536,30219,21556,27159,21951,23927,24224,20349,24855,25180,25217,21388,22601,22478,23581,21838,27584,25737,26897,20205,24550,23932,25658,21185,30650,23640,20215,26553,28887,31884,28332,25090,23830,26280,21761,26843,23882,23547,23338,21848,21063,27283,28470,32652,25622,29487,19366,25412,24018,24439,24673,30583,31897,22308,27978,22260,25068,25082,20726,25622,26030,26420,22020,23513,23041,23998,22407,28714,26567,27563,21165,25360,24889,26752,22043,32282,24663,21129,27632,29856,33050,29626,26140,24825,27823,22731,27827,24820,24610,24393,22766,22040,28718,29840,34198,26503,30664,20297,26315,25294,25759,25822,32466,33605,23365,29357,23095,26286,26151,21705,26557,27424,28157,23028,25016,23864,24714,23104,30090,27964,28788,21991,26604,26359,28194,23280,34073,26299,22294,29290,31260,35110,31376,27712,25883,29378,24167,29157,26331,26089,25759,23966,23180,30519,31592,36327,27703,32165,21423,27271,26923,27272,27577,34628,35223,24934,31067,24313,27714,27152,22808,28327,28812,29901,24354,26718,25032,25792,24720,32109,29753,30450,23290,28037,28201,29743,24839,36041,28062,23591,31008,32745,37213,33151,29446,27318,31519,25907,30732,27586,27336,26982,25253,24117,32158,33466,38421,28776,33101,22677,28419,28657,28756,29494,36650,37082,26373,33044,25692,29323,28390,24346,29841,30242,31876,25726,28377,26180,27317,26416,34064,31645,31957,24363,29392,30252,31166,25692,37647,29771,24631,32796,33946,39210,34495,31153,28234,33429,27438,32138,28565,28604,28416,26415,27065,33659,35228,40316,29850,34247,24187,29233,30367,29910,31064,38218,39175,27707,34759,26661,30914,29264,25699,31403,31539,33462,26907,29706,27355,28379,28115,35638,33070,33495,25417,30772,32651,32352,26501,39275,31018,26017,34381,35107,40738,35876,32135,29104,34965,28470,33575,29392,29608,29617,27082,28059,35060,36716,41494,30605,35231,24772,30300,32174,31132,31996,39495,40500,28861,36367,27748,32591,30375,26705,32545,32820,34812,27897,31225,28125,29353,29303,36929,34436,35025,26321,31790,34552,32912,26905,41006,30825,26269,34721,35502,41458,36661,32159,29109,36032,28659,34059,29976,30694,30418,27721,28674,36013,37454,42509,31548,35946,25416,31331,33396,32066,31945,40512,41254,29975,37315,27908,34400,30847,27766,32729,33823,35709,28367,32456,28332,29940,29520,38304,35222,35677,27383,32606,35930,32077,26297,40525,29628,25761,33193,34308,40269,35859,31105,28099,35510,27316,33338,29217,30477,29666,27518,28115,35734,36928,41653,31126,35171,25018,31062,32294,31402,30286,39956,40351,29216,36730,27182,34366,30322,26885,31609,33440,35095,27577,31923,27673,29132,28170,37950,34620,34722,27669,32056,33637,32962,27093,41553,30252,26326,34065,34822,41142,36801,31947,28807,36368,28003,34249,30053,31246,30104,28271,28830,36858,37893,42987,32054,36065,25866,31710,33353,32377,30879,40863,41315,29841,38060,28085,36745,31253,27750,32392,34473,36000,28717,33151,28789,29925,28466,39252,35567,35454,28738,32766,34633,34268,28053,43507,31251,27444,35361,36252,42355,38129,33140,30047,37540,28953,35580,31190,32716,31424,29337,29996,38048,38980,44294,33518,37576,26929,33030,34726,33837,32051,42477,42541,31020,39606,28969,40139,32611,29251,33704,35866,36926,29594,34640,30109,31540,29392,40798,36873,36764,30067,34027,36600,35160,28556,44419,31744,28090,36441,37091,43197,38688,33829,30695,38861,29468,36521,32114,33500,32267,30108,30745,38791,39932,45451,34341,38652,27547,34081,35953,34783,32634,43317,43544,31899,40652,29843,43848,33651,30242,34444,36685,37542,30086,35572,30696,32574,30352,41970,37740,37822,30889,34600,37166,35879,29134,45484,32344,28639,36976,37738,44035,39605,34599,31499,39799,30427,37191,32602,34117,32892,30491,31574,39516,40565,46299,35139,39504,28102,34684,37044,35551,33250,44495,44424,32531,41666,30596,45593,34373,30845,35408,37394,38329,30560,36333,31202,33386,31251,43414,38255,38703,31578,35383,37686,37188,29838,47054,33391,29311,38346,39463,45883,40995,35931,32589,41475,31487,38657,33404,35106,33979,31161,32798,40709,41785,48199,36536,40862,28769,35390,38567,36665,34252,46202,45931,33746,43813,31751,48076,35494,31929,36845,38547,39829,31479,37449,32200,34862,32473,45235,39341,40183,32435,36428,39356],[2152,1807,1483,733,1803,2582,988,4056,697,2093,1820,1170,1195,2965,1620,2275,3245,1160,1772,-536,2642,744,1503,8,2093,1024,-182,2524,3933,635,3916,344,3723,2510,-425,1886,1804,608,2298,1891,1218,1875,1860,2193,68,-1331,3363,2661,1043,1722,1646,2384,2200,1351,1028,1913,3118,1508,4497,1826,2408,2421,1031,1684,3126,2141,2179,3322,1180,1773,-793,3410,516,1692,641,2101,906,-34,2941,4599,1411,3975,186,3652,2828,694,1909,1779,665,2298,2286,1341,2454,2768,2460,104,-992,3256,2263,999,2091,1725,2055,1845,772,548,1536,2585,1130,4444,2121,2337,2179,1117,1428,2963,1824,1551,2766,868,1439,-1227,3476,517,1523,116,1566,501,-892,2737,4232,1145,3587,-564,3533,2425,94,1470,1252,-34,2002,2179,943,2212,2332,2123,-214,-918,2874,1792,538,1699,1963,2163,1849,741,493,1207,2474,1314,5644,3667,2326,2170,1058,1286,3091,2205,1896,2635,1168,1548,-1060,3797,703,1961,-163,1547,788,-1061,2617,4503,2220,4298,-241,3769,2207,764,1168,1600,95,2137,1769,1142,2501,2384,2122,-275,-873,3000,1895,556,2019,2014,2281,1867,565,497,1588,2710,1516,6168,5261,2557,2506,1127,1546,3311,1974,2049,2740,1213,2215,-1022,3976,1155,1801,-94,1943,601,-1260,2691,4519,2765,3983,343,3447,2137,62,1041,1949,133,2014,2164,1184,2601,2405,2462,-67,-780,3331,2248,821,2259,2785,2493,1816,446,755,1683,3129,1823,6410,5358,3098,2749,1842,1929,3560,1892,2597,2890,1283,2445,-952,4281,1628,1677,-74,1785,604,-1562,3042,4343,2846,4055,414,3836,2337,-80,932,2362,-155,2254,2556,1361,2081,2692,2496,75,-912,3488,2579,1055,2582,3293,2478,2094,345,852,2128,3546,1524,6074,4626,3194,2678,1549,1586,3396,1605,2199,2798,991,2288,-990,4336,1255,1583,384,1722,888,-1315,3615,4299,1732,3575,264,3369,2441,1073,886,2535,-60,2082,2487,1107,3198,2947,2566,69,-905,3840,2546,712,2039,3855,2537,2665,-142,821,2227,4014,835,5839,3480,3179,2793,1733,1684,3255,1152,3025,1919,1224,2159,-1456,4842,931,1305,688,1907,1378,-1311,3198,4419,1529,3515,-34,3113,3236,-244,1086,3290,-375,2564,2100,956,3252,3170,2254,-388,-1173,3974,3108,194,1741,3597,2060,2145,-387,802,1782,3542,845,5213,1588,2930,2355,1041,372,2604,237,2208,1847,763,2940,-2820,4128,151,649,-11,1908,708,-1844,2060,4789,398,2372,-248,2232,3054,-434,420,3678,-1458,2000,973,366,2866,2743,2435,-783,-2930,3744,2259,-200,975,3935,2434,2445,-382,1148,1896,4045,1197,6370,1893,3412,2494,956,455,3152,648,2419,3005,868,3152,-2938,4423,1081,233,109,1196,1273,-1882,1871,4380,1261,2718,-329,2519,3611,-1148,891,4816,-1102,2131,1195,499,2562,2717,3163,-541,-2632,4218,2826,350,1155,5265,2517,2712,348,848,1832,3366,1401,7368,829,3360,2266,977,499,3318,507,3194,3827,1081,4120,-3312,3918,1014,248,558,2034,1280,-2134,2800,3639,1008,2704,-362,2894,4074,208,855,4669,-1071,2599,1271,670,4247,2929,3562,-251,-2393,4417,3601,135,1359,4462,3216,3144,2183,1344,2627,3647,1779,10171,171,3526,2250,1588,1026,3870,1368,4111,6169,1718,5232,-2910,5333,2035,208,1384,2509,1795,-1711,3984,2924,1175,3632,350,2736,5837,2693,1606,6992,-157,3148,1489,1275,5463,4061,5347,764,-1803,4662,4731,697,1684,6822,3547,3772,2778,1544,2995,4654,1506,12907,1469,3066,3207,2413,1624,3633,1918,3675,6028,1958,5231,-1983,6395,3786,-28,1233,2710,2179,-990,4509,2965,2265,4596,700,3926,5519,2460,1993,5179,285,3336,2107,1542,5042,4775,4741,603,-1058,4973,3898,1078,2296,6325,3313,3843,3310,590,2805,4469,797,13200,217,3577,2629,1850,1171,3153,1861,3313,5412,1783,5448,-2626,6296,3527,-9,1381,2379,1749,-966,4550,2848,2450,4139,740,3371,3999,3090,1568,5207,-402,3346,2758,823,5151,4506,4883,391,-1804,4869,3292,587,2059,6669,3528,3512,3623,405,3263,4921,1607,12612,837,3686,2957,1372,1393,2925,2378,4151,6807,1800,4924,-2880,6631,3291,130,1590,2424,1320,-553,6890,2528,2557,4264,813,3525,3768,3453,2089,5570,-609,3365,2704,1168,6633,4569,5472,1049,-1516,5035,3283,662,2365,8219,4300,3839,4037,1008,4857,5960,2733,12702,200,3351,2462,1454,2118,3608,3008,4821,8143,2110,5701,-2798,6875,4058,388,2837,2831,1877,-76,6810,2941,4022,5015,611,5349,4968,6366,2381,7050,237,4332,3970,2027,5821,5214,6623,1633,-1232,5938,5191,781,3442,9738,3286,3295,1338,580,3857,4883,3333,9886,-724,1984,1579,230,1869,3396,2553,4555,8223,1474,4661,-3920,5061,2190,-290,1386,2473,926,-1751,5543,1558,2157,3503,-983,4003,3101,3743,1788,7768,-875,3439,2817,1266,4397,4459,5605,914,-2423,4193,4239,-262,2447,9126,3627,3675,2679,885,4619,5505,4098,10258,-783,2386,1935,211,2087,3551,2946,4695,7610,2079,4980,-3647,5027,2129,-119,1622,2585,1283,-2539,6570,2158,2105,3975,-429,3560,3327,3226,1987,8928,-426,3857,2739,1811,4339,4692,6176,1062,-2953,4507,4903,-162,2998,10505]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> \u003c/th>\n      <th>Fips\u003c/th>\n      <th>Location\u003c/th>\n      <th>Year\u003c/th>\n      <th>Income\u003c/th>\n      <th>Expenditures\u003c/th>\n      <th>Savings\u003c/th>\n    \u003c/tr>\n  \u003c/thead>\n\u003c/table>","options":{"columnDefs":[{"className":"dt-right","targets":[3,4,5,6]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


## Exploratory Data Analysis

The primary purpose of this analysis is to assess how national and state-level PCI, PCE, and savings rates have changed over time and by geographic location. Thus, we will proceed by first assessing the national-level trends and then move on to assessing state-level trends.

### National-Level Patterns

At the national-level PCI grew by 79.6% from $22,536 in 1997 to $40,471 in 2014. Expenditures (PCE), on the other hand, grew 82.5% from $20,384 in 1997 to $37,186. Although we are assessing non-inflation adjusted dollars, we can still observe that since 1997 the rate of growth in PCE has only slightly outpaced PCI. Figure 1 illustrates the growing trends (not surprising since inflation has not been removed) and also captures the decrease in both PCI and PCE from 2008 to 2009 due to the [Great Recession](https://en.wikipedia.org/wiki/Great_Recession).


```r
data_clean %>%
  filter(Location == "United States") %>%
  ggplot(aes(x = Year)) +
  geom_line(aes(y = Income, group = 1), color = "darkseagreen4") +
  geom_line(aes(y = Expenditures, group = 1), color = "firebrick3") +
  geom_ribbon(aes(ymin = Expenditures, ymax = Income, group = 1), fill = "darkseagreen1", alpha = .5) +
  annotate("text", x = 2014.15, y = 41000, label = "2014 PCI: $40.5K", 
           color = "darkseagreen4", hjust = 0, size = 3) +
  annotate("text", x = 2014.15, y = 37000, label = "2014 PCE: $37.2K", 
           color = "firebrick3", hjust = 0, size = 3) +
  annotate("text", x = 2014.15, y = 39000, label = "2014 Savings: $3.3K", 
           color = "darkseagreen2", hjust = 0, size = 3) +
  scale_x_continuous(NULL, limits = c(1997, 2016.5), breaks = seq(1998, 2014, by = 4)) +
  scale_y_continuous(NULL, labels = scales::dollar) +
  ggtitle("Figure 1: Growth in PCI and PCE",
          subtitle = "Growth represented as current year dollars from 1997-2014 (not adjusted for inflation)") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        text = element_text(family = "Georgia", size = 12),
        plot.title = element_text(size = 28, margin = margin(b = 10)),
        plot.subtitle = element_text(size = 12, color = "darkslategrey", margin = margin(b = 25)))
```

<img src="2017-01-01-an-assessment-of-u-s-savings-rates_files/figure-html/unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

However, a closer look at just the savings rate ($Savings Rate = \frac{Savings}{Income}$) depicted in Figure 2 illustrates that no consistent trend has been established. In other words, the aggregate per capita savings rate has not consistently increased or decreased year-over-year. In 1998 the savings rate was 10% but reduced over the next few years to 6.5% in 2005 before peaking at 10.9% in 2012 and then dipping back down to about 8-9% in recent years.  Bottom-line is that since 1997 the national-level per capita savings rate has ranged between 6.5% and 10.9% with an average of 8.6%.


```r
data_clean %>%
  filter(Location == "United States") %>%
  mutate(Savings_Rate = Savings / Income) %>%
  ggplot(aes(Year, Savings_Rate)) +
  geom_line() +
  geom_hline(aes(yintercept = mean(Savings_Rate)), linetype = "dashed", alpha = .5) +
  annotate("text", x = 2010, y = .08, label = "Average: 8.6%", size = 3) +
  scale_y_continuous(NULL, labels = scales::percent, limits = c(0, .115)) +
  scale_x_continuous(NULL, breaks = seq(1998, 2014, by = 4)) +
  ggtitle("Figure 2: National-level savings rate",
          subtitle = "Changes in state-level savings rates from 1997-2014") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        text = element_text(family = "Georgia", size = 12),
        plot.title = element_text(size = 28, margin = margin(b = 10)),
        plot.subtitle = element_text(size = 12, color = "darkslategrey", margin = margin(b = 25)))
```

<img src="2017-01-01-an-assessment-of-u-s-savings-rates_files/figure-html/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

However, understanding aggregate ratios and trends provides limited insight regarding lower-level activity [^cost_curve]. Consequently, next we turn to investigating state-level trends. 

### State-Level Patterns

To get a quick understanding of how U.S. states have progressed over the years we can map the savings rates over time. Figure 3 highlights a few attributes:

1. Note how the earlier years have less diverging colors suggesting that there was more "equality" in the savings rates across the states; however, the latter years appear to have more disparity in the savings rates
2. As the years have progressed it appears that a growth in savings rates has been concentrated in the central states; primarily from the Dakotas down to Texas
3. A few individual states stand out:
    - Main, Vermont & Montana for savings rates that are consistently less than 0%
    - Massachusetts for consistently being a top savings rate state



```r
data_clean %>%
  mutate(region = tolower(Location),
         Savings_Rate = Savings / Income) %>%
  right_join(map_data("state")) %>% 
  select(-subregion) %>% 
  filter(Year %in% seq(1998, 2014, by = 2)) %>%
  ggplot(aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = Savings_Rate)) +
  facet_wrap(~ Year, ncol = 3) +
  scale_fill_gradient2(name = "Savings Rate", labels = scales::percent) +
  ggtitle("Figure 3: Savings rate changes over time",
       subtitle = "Temporal map assessment of state-level savings rates (1998-2014)") +
  expand_limits() +
  theme_void() +
  theme(strip.text.x = element_text(size = 12),
        text = element_text(family = "Georgia"),
        plot.title = element_text(size = 28, margin = margin(b = 10)),
        plot.subtitle = element_text(size = 12, color = "darkslategrey", margin = margin(b = 25)))
```

<img src="2017-01-01-an-assessment-of-u-s-savings-rates_files/figure-html/unnamed-chunk-6-1.png" style="display: block; margin: auto;" />

A closer look at the state-level trends provides more insight. We can see that the average savings rate over time has remained around 7%; however, confirming our assessment of the map it appears that the variance (or disparity in savings rates) has increased in recent years.  Moreover, the trend lines illustrate that with a few exceptions, states that are leading the way as top or bottom savings rate states have, historically, always been near the top or bottom. However, this should not be too surprising as it takes decades for states to change their industrial and economic infrastructure. 


```r
savings_rate <- data_clean %>%
  mutate(Savings_Rate = Savings / Income) %>%
  filter(Location != "United States")

top5 <- savings_rate %>%
  arrange(desc(Savings_Rate)) %>%
  filter(Year == 2014) %>%
  slice(1:5)

bottom5 <- savings_rate %>%
  arrange(Savings_Rate) %>%
  filter(Year == 2014) %>%
  slice(1:5)

avg <- savings_rate %>%
  group_by(Year) %>%
  summarise(Avg_mn = mean(Savings_Rate),
            Avg_md = median(Savings_Rate)) %>%
  mutate(Avg = "Average")

ggplot(savings_rate, aes(Year, Savings_Rate, group = Location)) +
  geom_line(alpha = .1) +
  geom_line(data = filter(savings_rate, Location %in% top5$Location),
            aes(Year, Savings_Rate, group = Location), color = "dodgerblue") +
  geom_line(data = filter(savings_rate, Location %in% bottom5$Location),
            aes(Year, Savings_Rate, group = Location), color = "red") +
  geom_line(data = avg, aes(Year, Avg_mn, group = 1), linetype = "dashed") +
  annotate("text", x = 2014.25, y = .071, label = "Average", hjust = 0, size = 3) +
  geom_text_repel(data = top5, aes(label = Location), nudge_x = .5, size = 3) +
  geom_point(data = top5, aes(Year, Savings_Rate), color = "dodgerblue") +
  geom_text_repel(data = bottom5, aes(label = Location), nudge_x = 0.5, size = 3) +
  geom_point(data = bottom5, aes(Year, Savings_Rate), color = "red") +
  scale_x_continuous(NULL, limits = c(1997, 2015.25), breaks = seq(1998, 2014, by = 2)) +
  scale_y_continuous(NULL, labels = scales::percent) +
  ggtitle("Figure 4: Savings rate changes over time",
          subtitle = "Temporal assessment of state-level savings rates (1997-2014)") +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        text = element_text(family = "Georgia"),
        plot.title = element_text(size = 28, margin = margin(b = 10)),
        plot.subtitle = element_text(size = 12, color = "darkslategrey", margin = margin(b = 25)))
```

<img src="2017-01-01-an-assessment-of-u-s-savings-rates_files/figure-html/unnamed-chunk-7-1.png" style="display: block; margin: auto;" />

However, we can also look at those states that have had the largest change in their savings rate since 1997. As Table 2 displays, three of the four states with the largest change in their savings rate were Wyoming, Oklahoma and North Dakota; all having a savings rate increase close to, or more than, 10%. The remaining states with the largest changes have all experienced declining savings rates, led by Nevada. 


```r
largest_change <- savings_rate %>%
  filter(Year == 1997 | Year == 2014) %>%
  select(Location, Year, Savings_Rate) %>%
  spread(Year, Savings_Rate) %>%
  mutate(Change = `2014` - `1997`) %>%
  arrange(desc(abs(Change))) %>%
  mutate(`1997` = paste0(round(`1997` * 100, 1), "%"),
         `2014` = paste0(round(`2014` * 100, 1), "%"),
         Change = paste0(round(Change * 100, 1), "%")) %>%
  slice(1:10)

knitr::kable(largest_change, caption = 'Table 2: Top 10 states with the largest change in their savings rate since 1997', 
             align = c('l', 'r', 'r', 'r'))
```



Table: Table 2: Top 10 states with the largest change in their savings rate since 1997

Location          1997    2014   Change
--------------  ------  ------  -------
Wyoming           7.9%   21.1%    13.2%
Oklahoma          9.7%   21.9%    12.1%
Nevada           16.3%    5.9%   -10.4%
North Dakota     -2.2%    6.3%     8.5%
Maine            -2.6%   -9.8%    -7.2%
Michigan          6.7%   -0.3%    -7.1%
New York         14.4%    7.5%    -6.9%
West Virginia       6%   -0.5%    -6.5%
Montana            -1%     -7%      -6%
New Jersey       13.9%      8%    -5.9%

This may lead us to wonder if one component (PCI vs PCE) is driving the changes in savings rate. In other words, for those states that are growing above the average level, is their PCI level growing at a greater level than those states below the average?  Or could it be that the those states with above average savings rates are experiencing a slower increase in their expenditures than those states below average. Figure 5 helps to illustrate this issue. 

Figure 5 shows that, concerning PCE (left pane), the states that have had above average savings rates have not experienced, on average, any difference in PCE growth since 1997. However, the states with below average savings rates have experienced greater variance in their PCE growth rates.  Concerning PCI (right pane), the states that have had above average savings rates have experienced, on average, slightly greater PCE growth since 1997; however, this difference is likely not to be statistically significant (though validation would be required to confirm). Again, those states with below average savings rates have experienced slightly greater variance in their growth rates than the above average savings rate states. 

Thus, it appears that those states with below average savings rates have greater variability in their PCI and PCE growth rates whereas those states with above average savings rates have more consistency. However, no significant differences appear to exist in the average PCI & PCE growth rates among states with above versus below average savings rate. This is likely why we are seeing the average savings rate remain relatively steady but the variability in savings rates among the states growing.


```r
changes <- savings_rate %>%
  filter(Year == 1997 | Year == 2014) %>%
  arrange(Location) %>%
  select(Location, Year, Income, Expenditures, Savings_Rate) %>%
  group_by(Location) %>%
  mutate(PCI = diff(Income) / lag(Income),
         PCE = diff(Expenditures) / lag(Expenditures)) %>%
  na.omit() %>%
  ungroup() %>%
  mutate(Group = ifelse(Savings_Rate > mean(Savings_Rate), "Above Average", "Below Average")) %>%
  gather(Metric, Value, PCI:PCE)


ggplot(changes, aes(Group, Value)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = .1, alpha = .5) +
  geom_text(data = filter(changes, Value > 1.1 | Value < .6), aes(label = Location), size = 3, hjust = 0, nudge_x = .05) +
  facet_wrap(~ Metric) +
  scale_y_continuous("Percent change from 1997 to 2014", labels = scales::percent) +
  xlab(NULL) +
  ggtitle("Figure 5: Percent change in PCE & PCI",
          subtitle = "Comparing the change in PCE & PCI from 1997 to 2014 for those states with above versus below \naverage savings rates") +
  theme_bw() +
  theme(panel.grid.minor = element_blank(),
        text = element_text(family = "Georgia", size = 12), 
        strip.text.x = element_text(size = 14),
        plot.title = element_text(size = 28, margin = margin(b = 10)),
        plot.subtitle = element_text(size = 12, color = "darkslategrey", margin = margin(b = 25)))
```

<img src="2017-01-01-an-assessment-of-u-s-savings-rates_files/figure-html/unnamed-chunk-9-1.png" style="display: block; margin: auto;" />

## Summary

Consequently, our analysis finds that the national-level and average state-level savings rates have remained around 7-8% since 1997. Furthermore, we find that PCI and PCE have grown at a relatively similiar rates at the national, state-levels, and among those states that have experienced above versus below average savings rates.  This suggests that the U.S. has not experienced a fundamental shift in PCI or PCE behavior.  

The noticable change that we have seen is a greater disparity in savings rates among the states in recent years. Although the average savings rate has remained around 7-8%, the variance in state-level savings rates has grown since 1997. Moreover, much of the above average growth in savings rates has been concentrated in the central U.S. states from the Dakotas down to Oklahoma, Texas and Louisiana; whereas much of the below average growth has been concentrated in more eastern and western states. Thus, if you are looking to save more of your hard-earned income you may have greater opportunities by seeking refuge in one of the fly-over states.


[^cost_curve]: The ecological fallacy and Simpson's paradox both discuss concerns of inferring the nature of lower-level trends and probabilities based on interpretation of aggregate level statistics. You can read more at: [Clark, W. A., & Avery, K. L. (1976). The effects of data aggregation in statistical analysis. *Geographical Analysis, 8*(4), 428-438.](http://onlinelibrary.wiley.com/doi/10.1111/j.1538-4632.1976.tb00549.x/abstract); [Wagner, C. H. (1982). Simpson's paradox in real life. *The American Statistician, 36*(1), 46-48](http://www.tandfonline.com/doi/abs/10.1080/00031305.1982.10482778?journalCode=utas20); [Garrett, T. A. (2003). *Aggregated versus disaggregated data in regression analysis: implications for inference. Economics Letters, 81*(1), 61-65.](http://www.sciencedirect.com/science/article/pii/S0165176503001496); [Boehmke, B. C., Johnson, A. W., White, E. D., Weir, J. D., & Gallagher, M. A. (2015). *Bending the cost curve: Moving the focus from macro-level to micro-level cost trends with cluster analysis. Journal of Cost Analysis and Parametrics, 8*(2), 126-148.](http://www.tandfonline.com/doi/abs/10.1080/1941658X.2015.1064046).
