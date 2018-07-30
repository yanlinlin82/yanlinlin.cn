---
title: Plugin-free Related Posts on GitHub Pages
slug: plugin-free-related-posts-on-github-pages
date: 2015-01-02T01:20:00+08:00
categories: [ 旧文, 实践 ]
tags: [ GitHub, Jekyll ]
host-at: GitHub
---
It seems geeky to host a personal blog on [GitHub Pages]. Suffered too much pain with other blog services as well as the huge [wordpress], I have finally migrated [my blog here].

[GitHub Pages], however, has some limitations. Maybe for the [reason of system burdun], It uses '--safe' option to disable customized plugins. Option '--lsi' is also ignored, which makes 'Releated Posts' be the latest ten posts, without considering relevance between posts. I think listing most relevant posts is essential for readers to notice other articles they may be interested. So I just googled for the problem. Here I found two webpages with potential solutions:

1. [Jekyll Related Posts without Plugin](http://zhangwenli.com/blog/2014/07/15/jekyll-related-posts-without-plugin/)
2. [Jekyll "Related Posts" helper](https://github.com/eramdam/Jekyll-Related-Posts-Helper)

The relevance between posts is measured by number of shared tags. It is better to re-order the related posts by relevance. Here goes my final solution (see also [source of my blog]):

{% raw %}

    {% if site.brute_force_lsi %}
      {% capture related %}
        {% for tag in page.tags %}
          {{ site.tags[tag] | map: "id" | join: " " }}
        {% endfor %}
      {% endcapture %}
      {% assign related = related | split: " " %}
      {% assign max_hit = 0 %}
      {% capture hits %}
        {% for post in site.posts %}
          {% assign hit = 0 %}
          {% if post.id != page.id and related contains post.id %}
            {% for id in related %}
              {% if post.id == id %}
                {% assign hit = hit | plus: 1 %}
              {% endif %}
            {% endfor %}
            {% if hit > max_hit %}
              {% assign max_hit = hit %}
            {% endif %}
          {% endif %}
          {{ hit }}
        {% endfor %}
      {% endcapture %}
      {% assign hits = hits | split: " " %}
      {% capture post_index %}
        {% assign count = 0 %}
        {% for level in (1..max_hit) reversed %}
          {% for hit in hits %}
            {% assign num = hit | minus: 0 %}
            {% if level == num %}
              {{ forloop.index0 }}
              {% assign count = count | plus: 1 %}
              {% if count >= site.related_posts_max %}{% break %}{% endif %}
            {% endif %}
          {% endfor %}
          {% if count >= site.related_posts_max %}{% break %}{% endif %}
        {% endfor %}
      {% endcapture %}
      {% assign post_index = post_index | split: " " %}
    <div id="related">
      <hr />
      <h2>Related Posts</h2>
      <ul class="posts">
      {% for index in post_index %}
        {% assign num = index | minus: 0 %}
        {% assign post = site.posts[num] %}
        <li><span>{{ post.date | date: '%Y-%m-%d %H:%M' }}</span>
        - <a href="{{ post.url }}">{{ post.title }}</a></li>
      {% endfor %}
      </ul>
    </div>
    {% endif %}

{% endraw %}

Finally, to enable such brute force scanning for related posts, add following lines into `_config.yml`:

    brute_force_lsi: false
    related_posts_max: 6

[GitHub Pages]: http://pages.github.com/
[wordpress]: http://wordpress.org/
[my blog here]: http://yanlinlin82.github.io/
[reason of system burdun]: https://github.com/jekyll/jekyll/issues/867
[source of my blog]: http://github.com/yanlinlin82/yanlinlin82.github.io
