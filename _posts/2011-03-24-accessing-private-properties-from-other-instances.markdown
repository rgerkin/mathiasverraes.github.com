---
comments: true
date: 2011-03-24
layout: post
slug: accessing-private-properties-from-other-instances
title: Accessing private properties from other instances
published: true
---

In PHP, when a property or method is marked private, it can only be accessed from within that class. That includes **other instances of the same class**. This may seem counter-intuitive at first, because we are used to dealing with instances of classes. The visibility operator however works not on object-level, but on class level.

An example:

<script src="https://gist.github.com/885448.js?file=private_properties1.php"></script>

This should make it clear that both instances of Foo have access to each other's private properties.

What practical use does this have? A great candidate for this are [Value Objects](http://domaindrivendesign.org/node/135). If we want to make sure that to separate instances of Foo are actually equal, we can easily compare their private properties:

<script src="https://gist.github.com/885448.js?file=private_properties2.php"></script>

