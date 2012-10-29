---
comments: true
date: 2011-03-23 11:35:31
layout: post
slug: keep-you-controllers-thin-with-doctrine2
title: Keep your controllers thin with Doctrine2
wordpress_id: 29
categories:
- Software development
tags:
- ddd
- doctrine2
---

Doctrine2 does such a nice job abstracting everything related to the database, that you might be tempted to do everything else in your controllers. Say we have a Bug entity:

[gist][/gist]
 
To get a list of fixed bugs, we get the Bug repository from the EntityManager and ask for a list of Bugs where status equals ‘fixed’.  [gist][/gist]

That’s easy enough. Surely there can be no harm in having this code inside a controller? Although this code doesn’t look like one, it is in a fact a database query. It’s a shortcut for this:

[gist][/gist]
 
Having a query in our controller should ring some serious alarm bells. It means that despite all abstraction Doctrine2 provides, we are at this point still coupling the controller to the database. If one day we decide to change how bug status is represented in the database, we’d need to modify all our controllers.

Let’s have a closer look at the Repository. [Evans](http://domaindrivendesign.org/books/evans_2003) defines it as “an object that can provide the illusion of an in-memory collection of all objects of that type”, that clients talk to using the domain language. In other words, findBy(array(‘status’ => ‘fixed’)) is too generic: in domain language, we want to ask the repository to findAllFixedBugs(). If the database schema changes, we’ll only have to change that method.  Luckily Doctrine2’s repositories can be extended:  [gist][/gist]

Finally we can replace the code in our controller with this

[gist][/gist]

Our controller is now decoupled from the database. As an added bonus, the code does a much better job of communicating it’s intent than our first version ever could.
