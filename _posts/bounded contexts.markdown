---
title: Buzzword-free Bounded Contexts
slug: buzzword-free-bounded-contexts
date: 2014-02-13
layout: post
published: true
---

{% include tldr.html text="My recent attempt at explaining Bounded Contexts at @DDDBE, was too heavy on terminology. Rinse, adjust, repeat." %}


Context is everywhere. The human brain interprets context immediately, without effort. Try this:

- A product of my company
- A product of prime factors
- A product of my imagination

Note how easy it was for you to derive context. For machines, this is hard, which is one reason we feed them models with unambiguous names.

The difference is often even a lot subtler.

- A product in the sales department is a thing with a weight and dimensions, a description, a few pictures and some customer reviews.
- For the inventory, it's something that takes space on a shelf and that you always have too many or too few of.
- For the shipping department, it's something you need to deliver to a customer, it has a weight and dimensions, but this time they include the packaging.

 In each of these departments, people know the context perfectly well. They don't bother finding a different name, because even though it's all called product, there's never any misunderstanding.

And then the software developers come along, and we put all these totally different things that are all called product, in the same database table and model. We may be smart, but we've been fooled by the fact that they share the same name, and we've totally missed the context.

Now imagine that instead of one team, building one application and one model, we have three teams, in three different companies, building three systems. Nobody is calling the other teams going "Hey, we should all share one database!". That's a recipe for disaster. What you would do, is agree on a narrow, strictly defined way of integrating, through messaging, an API, import scripts, or dumping files on an FTP.

Whether you will easily reach agreement on those integration contracts, is [a whole different discussion](/2014/01/bandwidth-and-context-mapping/). But apart from that, it's great not to share your database, or any other infrastructure. There is no complication from trying to put all the things in one model. So why do we make it so hard on ourselves when we are just one team? We can borrow the benefits of having multiple teams (clarity, clean separation), without the downsides (communication overhead). That's essentially what Bounded Contexts are about:

- Split up your system according to natural divisions in the domain, such as departments, userbases, lifecycles, goals, ...
- Make the contexts explicit. ("A Product in the context of Shipping is...")
- Make the boundaries explicit. ("Shipping uses database A, Inventory uses database B...")
- Keep the models consistent within a Bounded Context. Well, keeping your models consistent is a good idea anyway.