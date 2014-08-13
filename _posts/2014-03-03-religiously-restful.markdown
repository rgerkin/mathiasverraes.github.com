---
title: Religiously RESTful
slug: religiously-restful
date: 2014-03-03
layout: post
published: true
tags: [blog]
abstract: "REST: The language of the future, or opium for the masses?"
---



Should you always speak and write perfect Oxford English? Most people will agree that this would be impractical, and take a lot of effort. It depends on your conversation partner, or your audience, and, quite importantly, on the expected lifespan of the message. If you are among friends, in the pub, you will most likely speak your local dialect. If you write a text message to your best mate, same. If, on the other hand, you were the King, and you were addressing the nation on a matter of the gravest importance, you'd want it to be in the best English you have at your disposal. If you write a document that is likely to survive you, such as legislature, you'd want to make sure it is still readable in a hundred years. Your local vernacular wouldn't provide that guarantee.

<img style="float:left;margin-right: 10px" src="/img/posts/2014-03-03-religiously-restful/colin-firth-as-king-george-vi-in-the-king.jpeg" alt="Colin Firth as King George VI">

 REST is a protocol, a language. You can speak it perfectly, but this comes at a greater cost. You and your team need a deeper understanding of the protocol. There's effort in figuring out the tools, making sure you follow the rules, and refactoring when you realised that you misinterpreted how the protocol should be implemented.

 The truth is, not all APIs need that level of REST maturity. Often, all you are building is a quick and dirty interface to allow two systems to talk to each other. If you build an API, and the only client is your own web user interface, and perhaps an mobile application, then there will be very little benefit in spending all the effort on perfection. After all, next year, you might throw away the REST API and replace it with some new protocol, or perhaps even something like a message based integration. Only if you are building an API that you expect to be maintained for a very long time, with lots of clients all over the planet, a strict protocol will serve you.

 REST is tool, and it solves the problem of standardisation and long time maintainability quite well. Consider carefully if you need to whole tool, or just an approximation. Use the time you gain to build a better language for the domain model at the heart of your system, because this is a lot more critical than the infrastructure around it. Speak the RESTish language you are comfortable with, and learn the official language when you need it.