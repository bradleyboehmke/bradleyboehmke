---
layout: page
title: Archive
permalink: /categoryview/
sitemap: false
---
    
# Categories

<div>
    {% assign categories = site.categories | sort %}
    {% for category in categories %}
     <span class="site-category">
        <a href="#{{ category | first | slugify }}">
               <font size="3"> {{ category[0] | replace:'-', ' ' }} ({{ category | last | size }}) </font>
        </a>
        &nbsp;
    </span>
    {% endfor %}
</div>

<br>
<br>

# Tags

<div>
    {% assign tags = site.tags | sort %}
    {% for tag in tags %}
     <span class="site-tag">
        <a href="#{{ tag | first | slugify }}">
               <font size="3"> {{ tag[0] | replace:'-', ' ' }} ({{ tag | last | size }}) </font>
        </a>
        &nbsp;
    </span>
    {% endfor %}
</div>

<br>
<br>

# Posts by Categories

<div id="index">
    {% for category in categories %}
    <a name="{{ category[0] }}"></a><h4 style="font-family:Gentium Basic">{{ category[0] | replace:'-', ' ' }} ({{ category | last | size }}) </h4>
    {% assign sorted_posts = site.posts | sort: 'title' %}
    {% for post in sorted_posts %}
    {%if post.categories contains category[0]%}

     <a href="{{ site.baseurl }}{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a>
    <br>
    {%endif%}
    {% endfor %}
    <br><br>
    {% endfor %}
</div>

<small><a href="#">Go to top</a></small>
