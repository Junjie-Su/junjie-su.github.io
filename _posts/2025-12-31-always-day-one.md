---
title: 'Always Day One'
date: 2025-12-31
permalink: /posts/2025/12/always-day-one/
tags:
  - life
  - thinking
  - career
---

In 2012, Jeff Bezos wrote in his annual letter to Amazon shareholders: “Day 2 is stasis, followed by irrelevance, followed by excruciating painful decline, followed by death.” He used “Day One” to describe a state of perpetual beginning—curious, disruptive, restless. Years later, ByteDance adopted this philosophy as the first principle of its corporate culture: Always Day One.

Before I joined the company, I saw those words on the office wall and thought nothing of them—just another corporate slogan. Six months later, as I handed in my badge and walked out of Zijin Digital Park for the last time, sunlight falling on the wall with the ByteDance logo, I realized those words had acquired weight. “Always Day One” doesn't mean starting from scratch forever. It means carrying the mindset of someone who is starting from scratch—humble, curious, unafraid to tear things down and rebuild.

During my six months on the TikTok Servarch team, I was sent back to Day One more times than I could have anticipated. This is a record of those moments, and a letter to the person I was living through them.

## Getting In

In the first half of 2025, while my friends were starting internships at tech companies, I was still buried in lab work at university. The lab was demanding but insular; they were gaining exposure to real industry problems. The imbalance nagged at me. I realized that if I didn't step out on my own, I'd miss a critical window of growth. So I made a decision: I would intern at a top tech company, or not at all.

The preparation took longer than I expected. Between polishing my resume, grinding LeetCode, and managing lab obligations and coursework, it wasn't until early May that I was ready to start applying. What followed was nearly two months of intensive interviewing—roughly eleven rounds across multiple teams at Tencent and ByteDance. It didn't go smoothly. I was rejected by several ByteDance teams in succession, and the fatigue was real.

Ironically, that fatigue helped. By the time the TikTok team—the one I'd originally applied to—finally reached out, I'd stopped overthinking. I wasn't nervous anymore; my talking points were second nature. The interviews became genuine technical conversations. In one round, we spent most of the time discussing AI, which happened to be my comfort zone. The interviewer joked that my code was mediocre, but passed me anyway—even skipping the third technical round and sending me straight to HR.

Sometimes, when you stop trying so hard, things find their way to you.

## Cold Start

On July 16th, I officially joined ByteDance. The company is known for offering minimal onboarding, but my mentor Tushen gave me nearly ten days to self-study Go and the internal tech stack. He then assigned me a legacy platform migration—moving certain capabilities from one system to another. The task itself was eventually shelved due to a business pivot, but its real value was transitional: it took me from “just arrived” to “able to contribute.” When I later asked Tushen whether the assignment had been intentional, he didn't deny it. I was lucky to have a mentor who thought about how to bring an intern up to speed.

Our office was in Zijin Digital Park in Beijing—an older, leased building. But for someone entering Big Tech for the first time, everything felt exciting: free meals, a gym, snack-stocked pantries, standing desks, large monitors. More importantly, the team culture was exceptional. ByteDance's organizational structure is remarkably flat. As an intern, I had the same voice as full-time engineers—if your argument held up, no one discounted it because of your title. Colleagues would chat with me after work, invite me to play table tennis, go for walks. The boundary between work and life was clear and respected. That comfort helped me find my footing quickly.

## Into the Core

After the warm-up, I was handed work with real business impact: implementing auto-scaling for traffic failover scenarios. This capability had never been integrated into the platform before. Previously, capacity scaling during failover relied entirely on SREs coordinating resources manually—slow, error-prone, and plagued by stale information. Our goal was to let the system automatically infer capacity requirements from traffic changes and execute scaling across data centers with a single click.

My understanding at the time, however, was far less clear than that summary suggests. I thought the job was straightforward: call the underlying component's scaling API, pass in the parameters, trigger it, done. That mental model captured the core idea but missed the complexity of failover scenarios entirely. Throughout Q3, my work on Redis auto-scaling went through multiple rounds of redesign and refactoring. I barely finished the feature before the National Day holiday in October, and didn't even have time to test it properly before leaving for the break.

But that period also held unexpected beauty. Around the holiday, I applied to work from the Shenzhen office and got my manager's approval. The Shenzhen campus was in Jinghu Tower, right next to Shenzhen Bay Park. Working in my hometown felt surreal—my home was impossibly close to the office, and the daily commute became something I looked forward to.

![The view at breakfast](/images/shenzhen-breakfast.png)

The conditions at Jinghu Tower were a world apart from Zijin Digital Park in Beijing—especially the food, which was genuinely moving.

![Lunch](/images/shenzhen-lunch.png)

![Dinner](/images/shenzhen-dinner.png)

After dinner, I'd walk along Shenzhen Bay. The sea breeze, the sunset, the city lights in the distance—none of this existed in my Beijing routine.

![An evening walk by Shenzhen Bay](/images/shenzhen-evening-walk.png)

Those days planted a seed in my mind: someday, if the opportunity arises, I want to come back to Shenzhen, and back to ByteDance.

## Starting Over

Returning to Beijing after the holiday, I was met with an unexpected change: Tushen had transferred to Seed, ByteDance's AI infrastructure division. Just before the break, we'd sat down for a one-on-one about my career plans, and he'd given me thoughtful advice. I respected his decision, but the reality was immediate—I needed to adapt to a completely new mentor.

My new mentor, Haobin, was a seasoned engineer with exacting standards for code quality. After taking over the failover project, he brought a wave of new ideas. What began as a routine refactoring discussion escalated, under his near-perfectionist demands, into a full platform rewrite. Qi, Xin, and I—the three frontline developers—spent over a month iterating on the design before arriving at that conclusion.

This meant my entire Q3's work would be discarded. And it wasn't just me—Xin's substantial contributions from the first half of the year would need to be redone as well. The frustration was real. Three months of effort, scrapped before it ever reached production. But once the initial sting faded, we recognized that the earlier approach had been too idealistic, and that the pursuit of perfection had actually slowed us down. Once we accepted that, the team recalibrated quickly and rallied to meet the new timeline.

The cost of starting over was steep, but it taught me something important: code can be thrown away, but capability cannot. Everything I'd learned in Q3—my understanding of the business logic, my familiarity with the scaling pipeline—carried directly into the new system. In a sense, this was “Day One” in its purest form: the output reset to zero, but the experience remained, and I was stronger than the last time around.

## Friction and Growth

Haobin's rigor extended to every dimension of the code: style, memory management, concurrency patterns—all scrutinized during code review. Every batch operation had to support pagination and streaming. Goroutine usage and retry logic were treated with extreme caution. In my first few reviews, my code was essentially rewritten.

It was exhausting at the time. But in retrospect, those high standards forced me to grow faster than I otherwise would have. To get my code through review, I had to develop a deep understanding of every framework and component we used. To convince Haobin to accept my approach, I had to back my opinions with thorough technical research.

The turning point came during a debate about data processing. Haobin proposed replacing streaming with pagination to simplify the codebase—one implementation to maintain instead of two. But as I dug into the details, I found a fundamental limitation: under full-dataset processing, pagination introduced a logical gap that could silently drop data. Only streaming guaranteed completeness. I laid out my analysis, and he accepted it.

After that, something shifted between us. Code reviews moved faster. He stopped micromanaging every detail and began engaging me as a peer—discussing trade-offs, accepting alternative technical judgments. I went from passively receiving feedback to actively shaping technical decisions. That trust was earned, and the process of earning it was the most valuable thing I took from the internship.

After weeks of intense work—at one point, taking a taxi home past midnight for over a week straight—I completed everything I'd been tasked with: auto-scaling support for both TCE and Redis, the two core components in the failover pipeline.

## The Final Days

I'd set my end date before I even started: December 25th, Christmas Day. By December, the work was winding down, but a strange feeling of having one foot out the door lingered. I started eating lunch alone, cutting back on casual conversations, spending my midday breaks walking through the park near the office.

The day before I left, I gave a tech talk at the company on the history of large language models—something I'd spent two months preparing. Afterward, a colleague joked that they'd never seen anything so thorough. It was my parting gift to the team.

On my last morning, everything proceeded as usual. Stand-up, syncing progress, tying up loose ends. Haobin thanked me after the meeting and said he was satisfied with my work. A colleague asked why I wasn't converting to full-time, saying I'd outperformed most new graduates. My manager added me on WeChat and told me the door was always open—after graduation, skip Beijing and come straight to Shenzhen. “Assuming I'm still here,” he added with a grin.

Everyone respected my decision. There was no grand farewell, no ceremony. Things simply wound down. It wasn't until I handed my badge to the front desk that the six months finally felt real—and over.

## Always Day One

Before walking out of Zijin Digital Park, I stopped to take a photo of the wall bearing the ByteDance logo. I might never set foot in this office again, but I wanted something to remember it by.

My Lark account would be deactivated that evening, but before it was, one last message came through—an invitation to a team dinner. Apparently, the team had held one the week before I joined and was now holding another right after I left. My timing, it seemed, was impeccable. They invited me anyway, giving me one brief, “limited-time” return.

Looking back on those six months, I see a series of Day Ones: the first day on the job, staring at an unfamiliar tech stack; the day my work was thrown out and I had to start over; the day I met a new mentor and had to rebuild trust from nothing. Each reset was disheartening, but each time I came back a little stronger than before.

“Always Day One” is not an empty slogan. It is a choice—to treat every setback as a new starting point, to stay humble as a perpetual learner, to believe that tearing things down and rebuilding is not something to fear. I left ByteDance carrying six months of growth and one conviction: wherever I go next, I'm ready to begin again from Day One.

But leaving doesn't mean it's over. This experience only deepened my certainty that someday, I'll return—better, and ready to start again.

In the meantime, an unexpected journey was already waiting for me.
