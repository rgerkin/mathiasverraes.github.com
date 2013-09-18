---
title: Extract Till You Drop
slug: extract-till-you-drop
date: 2013-09-18
layout: post
published: true
---

{% include tldr.html text="If I'm not afraid to refactor messy code in front of a live audience, you shouldn't be afraid to do it in the comfort of your office." %}

### Events

#### Upcoming

- [Symfony Live](http://london2013.live.symfony.com/speakers.html#mathias) in London, UK, September 19-20, 2013
  - Reviews on [joind.in](https://joind.in/talk/view/9334)

### Screencast

There are no slides for this presentation, it's all live demoing. I prerecorded a screencast. You'll notice I haven't
managed to cram in everything I hoped to show, when I wrote the abstract. If plenty of people are interested, I'm happy
to record more videos of refactoring techniques.

<iframe width="420" height="315" src="//www.youtube.com/embed/S9pKJxOPmWM" frameborder="0" allowfullscreen></iframe>
[Watch video on YouTube](https://www.youtube.com/watch?v=S9pKJxOPmWM)

### Abstract

We’ve all seen them: applications out of control. Under the pressure of deadlines and endless change requests, with the weight of years of legacy, the code has become unmaintainable. Adding features is a slow hit and miss process. You know something needs to be done, but nobody knows how. To change the code safely, you need tests, but to make it testable, you need to change it. Rebuilding the system from scratch is not an option.

With the right tools, techniques, and mindset, any codebase can be brought under test, and be refactored towards a better architecture. All without affecting the behavior of the system, and allowing the business to continue.

This presentation is not for the weak of heart. We’ll skip the theory and dive straight into the spaghetti code. Dependencies will be broken; designs will be messed up before they get better; fat controllers will mercilessly be put on a diet. It’s live coding, and it may fail. But it will change how you approach legacy code forever.
