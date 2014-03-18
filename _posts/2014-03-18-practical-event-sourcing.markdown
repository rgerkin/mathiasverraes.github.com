---
title: Practical Event Sourcing
slug: practical-event-sourcing.markdown
date: 2014-03-18
layout: post
published: true
---


<script async class="speakerdeck-embed" data-id="78d43d2090a401318cc322b59c6a013f" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
[See the slides on Speakerdeck](https://speakerdeck.com/mathiasverraes/practical-event-sourcing)

## Abstract

Traditionally, we create structural models for our applications, and store the state of these models in our databases.

But there are alternatives: Event Sourcing is the idea that you can store all the domain events that affect an entity, and replay these events to restore the object's state. This may sound counterintuitive, because of all the years we've spent building relational, denormalized database schemas. But it is in fact quite simple, elegant, and powerful.

In the past year, I've had the pleasure of building and shipping two event sourced systems. In this session, I will show practical code, to give you a feel of how you can build event sourced models using PHP.

## Presentations

- [PHPNE 2014](http://conference.phpne.org.uk/) in Newcastle-Upon-Thyne, UK, March 18, 2014
  - [Joind.in reviews](http://joind.in/talk/view/10911)
- Your company or event? [Contact me](http://verraes.net/#contact)

