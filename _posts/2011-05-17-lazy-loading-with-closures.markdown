---
comments: true
date: 2011-05-17 21:57:07
layout: post
slug: lazy-loading-with-closures
title: Lazy Loading in PHP with Closures
wordpress_id: 90
categories:
- Software development
tags:
- ddd
- design patterns
- php
---

Closures are a great way to do all kinds of neat tricks in PHP, and they’re particularly useful for  Lazy Loading. I’m currently involved in a +200k SLoC legacy project, and the challenge is moving it to a Domain Driven implementation (while improving the performance), with the ultimate goal of making it more testable.


### The problem


We want to find a Customer, and ask it for a list of Orders:

[gist][/gist]
  With the ActiveRecord pattern, this is simple. The Customer object holds an instance of the database adapter, and queries it for related Orders:  [gist][/gist]

The downside of ActiveRecord, is that it violates the principle of Separation of Concerns. The Customer class contains domain knowledge (“What is a customer, how does it behave?”), as well as persistence knowledge (“How do we store a customer?”). The Customer class in our example even knows how to find it’s Orders in the database. The tight coupling between Customer and the database makes it less portable, and hard to test.

In DDD, we solve this by keeping the Customer class pure, and move the logic for storing the object to a CustomerRepository. Clients of the Repository don’t know how or where it finds Customers, and the Customer class itself doesn’t know anything about the Repository or the database it is stored in. As for the Orders, they are pushed in the Customer at creation time.

[gist][/gist]  Note that the client code for this example is still the same as in the first snippet.



### Adding Lazy Loading to the mix



The problem with the previous example is that we always query the database for the Orders, even when we don’t need them. We don’t want to move that query back to the Customer class, but we want to keep our client code intact. The trick is to move the logic for finding Orders into a Closure, push it into the Customer instance, and execute only when we actually need the Orders. In other words, Customer now holds a reference to the Orders, and only dereferences it at the very last moment -- hence the term Lazy Loading.  [gist][/gist]

The client code is still exactly as in the very first code snippet. But this time, when we call getOrders(), the Closure we prepared in find() is executed. It’s self-contained: it has the database instance and the Customer’s id, and it knows what to do. Customer on the other hand has no idea what goes on inside the Closure, but can perfectly deliver on getOrders() calls.


### Conclusion


Clearly this is a simplified example. My colleague, who has a lot more experience with the project, pointed out a whole bunch of real life use cases where this method would cause an abundance of queries. I'll keep you posted when we figure out how to deal with those.
