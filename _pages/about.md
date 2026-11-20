---
layout: profile
permalink: /
title: "Junjie Su"
description: "Junjie Su (苏俊杰) — M.S. student at BUPT and R&D Intern at Kimi, working on Agent Harness, AI Infra, and Post-training."
author_profile: false
redirect_from:
  - /about/
  - /about.html
---
{% assign featured_papers = site.publications | sort: "featured_order" %}
<div class="site-shell">
  <section class="home-hero" aria-labelledby="home-title">
    <div class="home-hero__copy">
      <h1 id="home-title">Junjie Su<span class="display-dot">.</span></h1>
      <p class="home-hero__tagline">Agent Harness · AI Infra · Post-training</p>
      <p class="home-hero__intro">I am an M.S. student at <a href="https://www.bupt.edu.cn/" target="_blank" rel="noopener noreferrer">BUPT</a> and an R&amp;D Intern at <a href="https://www.kimi.com/" target="_blank" rel="noopener noreferrer">Kimi</a>. My work focuses on the cost and performance of AI systems, with an additional interest in building thoughtful products.</p>
      <p class="home-hero__intro">I am advised by <a href="https://teacher.bupt.edu.cn/liujun/zh_CN/index/64453/list/" target="_blank" rel="noopener noreferrer">Prof. Jun Liu</a>. Previously, I was advised by <a href="https://scss.bupt.edu.cn/info/1063/3808.htm" target="_blank" rel="noopener noreferrer">Prof. Jie Hao</a> and collaborated with <a href="https://weifeijin.github.io/" target="_blank" rel="noopener noreferrer">Weifei Jin</a> on audio security and adversarial machine learning. I also joined the AI startup <a href="https://www.mirofish.ai/" target="_blank" rel="noopener noreferrer">MiroFish</a> as an AI Intern &amp; Head of Engineering and worked at <a href="https://www.bytedance.com/en/" target="_blank" rel="noopener noreferrer">ByteDance</a> as a Backend R&amp;D Intern.</p>
      <div class="home-hero__actions">
        <a class="button button--primary" href="{{ '/cv/' | relative_url }}">Curriculum vitae<i class="fa-solid fa-arrow-right" aria-hidden="true"></i></a>
        <a class="text-link" href="{{ '/publications/' | relative_url }}">Selected papers<i class="fa-solid fa-arrow-up-right-from-square" aria-hidden="true"></i></a>
      </div>
    </div>

    <aside class="home-hero__aside" aria-label="Current roles">
      <figure class="portrait">
        <img src="{{ '/images/site/avatar.jpg' | relative_url }}" alt="Portrait of Junjie Su">
        <figcaption><span>Junjie Su · 苏俊杰</span><span>Beijing, China</span></figcaption>
      </figure>
      <div class="now-list">
        <div class="now-list__item">
          <span class="status-dot" aria-hidden="true"></span>
          <div><span class="now-list__label">Currently at</span><strong>Kimi · R&amp;D Intern</strong></div>
        </div>
        <div class="now-list__item">
          <span class="now-list__index">M.S.</span>
          <div><span class="now-list__label">Intelligent Science and Technology</span><strong>BUPT · Class of 2029</strong></div>
        </div>
      </div>
    </aside>
  </section>

  <section class="home-duo section-rule" aria-label="Selected research and recent updates">
    <div class="home-duo__primary">
      <div class="section-heading">
        <h2>Selected papers</h2>
        <a class="text-link text-link--small" href="{{ '/publications/' | relative_url }}">All papers<i class="fa-solid fa-arrow-right" aria-hidden="true"></i></a>
      </div>
      <div class="paper-list paper-list--compact">
        {% for post in featured_papers limit: 2 %}
        <article class="paper-item">
          <div class="paper-item__meta"><span>{{ post.venue }}</span></div>
          <div class="paper-item__body">
            <h3><a href="{{ post.paperurl }}" target="_blank" rel="noopener noreferrer">{{ post.title }}</a></h3>
            <p>{{ post.authors_short }}</p>
          </div>
        </article>
        {% endfor %}
      </div>
    </div>

    <div class="home-duo__secondary">
      <div class="section-heading">
        <h2>Recent news</h2>
        <a class="text-link text-link--small" href="{{ '/news/' | relative_url }}">Full timeline<i class="fa-solid fa-arrow-right" aria-hidden="true"></i></a>
      </div>
      <ol class="news-list news-list--compact">
        {% for item in site.data.news limit: 5 %}
        <li class="news-item">
          <time>{{ item.date }}</time>
          <p>{% if item.url %}{{ item.before }} <a href="{{ item.url }}" target="_blank" rel="noopener noreferrer">{{ item.link_text }}</a> {{ item.after }}{% else %}{{ item.text }}{% endif %}</p>
        </li>
        {% endfor %}
      </ol>
    </div>
  </section>

  <section class="section-rule home-projects" aria-labelledby="home-projects-title">
    <div class="section-heading">
      <div><h2 id="home-projects-title">Open Source</h2></div>
      <a class="text-link text-link--small" href="{{ '/projects/' | relative_url }}">Project details<i class="fa-solid fa-arrow-right" aria-hidden="true"></i></a>
    </div>
    <div class="project-grid">
      {% for project in site.data.projects %}
      <article class="project-card">
        <div class="project-card__heading"><h3><a href="{{ project.url }}" target="_blank" rel="noopener noreferrer">{{ project.name }}</a></h3><span>{{ project.role }}</span></div>
        <p>{{ project.description }}</p>
        <a class="text-link text-link--small" href="{{ project.source }}" target="_blank" rel="noopener noreferrer">View on GitHub<i class="fa-solid fa-arrow-up-right-from-square" aria-hidden="true"></i></a>
      </article>
      {% endfor %}
    </div>
  </section>
</div>
