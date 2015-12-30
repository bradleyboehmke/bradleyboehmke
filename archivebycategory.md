---
layout: page
title: Archive
permalink: /categoryview/
sitemap: false
---
    
# Post by Category

<div>
    {% assign categories = site.categories | sort %}
    {% for category in categories %}
     <span class="site-tag">
        <a href="#{{ category | first | slugify }}">
                {{ category[0] | replace:'-', ' ' }} ({{ category | last | size }})
        </a>
        &nbsp;
    </span>
    {% endfor %}
</div>

<br>

<div id="index">
    {% for category in categories %}
    <a name="{{ category[0] }}"></a><br><strong>{{ category[0] | replace:'-', ' ' }} ({{ category | last | size }}) </strong>
    {% assign sorted_posts = site.posts | sort: 'title' %}
    {% for post in sorted_posts %}
    {%if post.categories contains category[0]%}

     <a href="{{ site.url }}{{site.baseurl}}{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a>

    {%endif%}
    {% endfor %}

    {% endfor %}
</div>
