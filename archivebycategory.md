---
layout: page
title: Archive
permalink: /archives/
sitemap: false
---


<font size="6">Tags</font>
<div>
    {% assign tags = site.tags | sort %}
    {% for tag in tags %}
     <span class="site-tag">
        <a href="#{{ tag | first | slugify }}">
               <font size="5" style="font-variant: small-caps"> {{ tag[0] | replace:'-', ' ' }} ({{ tag | last | size }}) </font>
        </a>
        <br>
    </span>
    {% endfor %}
</div>


<br>
<br>


<font size="6">Posts by Tags</font>
<div id="tag-index">
    {% for tag in tags %}
        <a name="{{ tag[0] }}"></a><strong><font size="5" style="font-variant: small-caps">{{ tag[0] | replace:'-', ' ' }} ({{ tag | last | size }}) </font></strong>
        <br>
    {% assign sorted_posts = site.posts | sort: 'date' | reverse %}
    {% for post in sorted_posts %}
    {%if post.tags contains tag[0]%}
     <a href="{{ site.baseurl }}{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a>
    <br>
    {%endif%}
    {% endfor %}
    <br>
    {% endfor %}
</div>

<small><a href="#">Go to top</a></small>
