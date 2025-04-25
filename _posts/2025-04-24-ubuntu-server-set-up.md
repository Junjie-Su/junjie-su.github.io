---
title: 'A Day in the Server Room: My Sysadmin Adventure'
date: 2025-04-24
permalink: /posts/2025/04/server-room-sysadmin-adventure/
tags:
  - experience
  - sysadmin
  - research
---
As a junior undergraduate, I’ve been given the chance to work in my mentor’s lab, a head start on research thanks to my confirmed spot in their graduate program after graduation. My days are usually spent coding algorithms, but on April 24, I faced a different kind of challenge. After an 8 AM class, I took the campus shuttle to the lab to deploy an AI backend I’d been developing. My mentor handed me an ancient server—its password long forgotten—and asked me to reinstall it from scratch. Just like that, I went from algo engineer to makeshift sysadmin.

## A Week Apart

I’d ventured into the lab’s server room the week before for my first attempt at setting up this machine. The place was a tech geek’s dream: rows of sleek, blinking servers, though the noise was like a jet engine. It was undeniably cool, but the server was a headache. Its GPUs refused to output a video stream, even with three cards plugged in. My mentor and I were baffled, but when he tried again the next day, it worked like nothing was wrong. **Sometimes, it’s just tech magic.**

This time, my mentor gave me a blank U disk and left me to tackle it solo. I found an 8-minute installation tutorial online, thinking it would be a quick job. **I was wrong to assume it would be that simple.** What I expected to be a straightforward task turned into a two-day ordeal of trial and error.

## Troubles and Solutions

The trouble started early. I couldn’t access the BIOS with F12, as the tutorial suggested. After some frantic searching, I learned this server’s motherboard used F2 instead. A small win, but bigger challenges loomed. I got the USB boot working and began the installation, which seemed to go smoothly—until it didn’t.

The real issue, which I missed at first, was that the server had no network connection. **I spent hours wrestling with errors while configuring the software sources, certain I’d botched the dependencies.** I repeated the entire installation twice, double-checking every step, only to discover the static IP setup was failing because the network was dead. The cable looked fine, and everything seemed normal—making it all the more frustrating when I realized it was a total facepalm moment. Out of ideas, I called my mentor for backup.

When he arrived, we found the Ethernet cable was plugged into a dead port. **After running a new cable from a nearby cabinet, the network sprang to life, and the installation finally went smoothly.** It was a humbling reminder that even a tiny oversight, like a bad port, can derail everything.

## Takeaways

This one networking glitch ate up nearly two days of my time. **Being a sysadmin is no joke—it requires technical skill, patience, and a touch of tech mysticism.** I learned to check the basics (like network connectivity) before diving into complex fixes. I also realized **online tutorials are great but don’t cover every server’s quirks.** Next time, I’ll come armed with a better checklist and more caution.

This wasn’t the research work I expected as an undergrad dipping my toes into grad-level projects, but it was a valuable lesson. It gave me a newfound respect for IT pros and a story to share with my lab mates. For now, the server’s up and running, and I’m back to coding algorithms—until the next tech adventure beckons.
