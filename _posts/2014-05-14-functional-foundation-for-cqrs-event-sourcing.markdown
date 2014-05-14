---
title: "A Functional Foundation for CQRS/ES"
slug: functional-foundation-for-cqrs-event-sourcing
date: 2014-05-14
layout: post
published: true
---


I've been dabbling with Functional Programming languages for a while now. Although I can't say I'm at all proficient, it has affected my programming style. Even if my code is mostly OOP, my whiteboard drawings look more functional. I'm [thinking about functions a lot](/2014/01/domain-driven-design-is-linguistic/). So it made sense to describe the CQRS-architecture of my system as a set of functions.


Command Query Responsibility Segregation is described by the Greg Young as "using two objects where previously there was only one". The idea is as ingenious as it is simple, but the I feel the quote doesn't do it justice. In a [Twitter conversation](https://twitter.com/abdullin/status/465747026953908225) between Rinat Abdullin and Eric Evans, the idea was proposed that CQRS enables you to denormalize your model. The value lies in the fact that, because you have independent read and write models, you can reason more clearly about your model. The separation opens up opportunities to capture deeper insights, because you can optimize the two side separately.

Even though CQRS can be used without Event Sourcing, this post assumes Domain Events all the way down. In a brainstorming session with [@stijnvnh](https://twitter.com/stijnvnh), we identified four (conceptual) functions.


<img style="float:left;margin-right: 10px" src="/img/posts/2014-05-14-functional-foundation-for-cqrs/circle-diagram-small.png" alt="Functional Foundation for CQRS">



## Protection


```f(history, command) -> events```

Commands and Domain Events are first class citizens of our model. Aggregates no longer expose state, but only events. Aggregates are at the core of the decision making process. They decide what the outcome of a Command is, and that outcome is expressed is Domain Events. The history of that particular Aggregate instance, influences the decision, so it must be injected. If you want to split the reconstitution of the Aggregate instance from the handling of the command, (for example because you want to keep infrastructural and model concerns separated), you can use currying:

```f(history)(command) -> events```

'Protection' refers to the primary goal of the Aggregates: protecting its invariants, making sure that the user can not cause the system to go in an inconsistent or illegal state. When the invariants are violated, the operation should fail:

```f(history, command) -> either<exception|events>```

(This part of FP is still a bit terra incognita for me though.)


## Interpretation

```f(events) -> state```

As the Aggregates do not expose, something else must. The function above is a Projector. It takes (a stream of) events, and projects these into something that represents a subset of the perceived state of our system. That state makes up our read models for further consumption. I like the idea of "interpretation" here: Two different Projectors could have a completely different interpretation of what the meaning of a set of behaviours is. This is similar to how a journalist or politician interprets a series of events, and comes up with a different conclusion, or at least a different focus, than her colleagues.

Of course these interpretations are based in the domain. The beauty of the decoupling from the write model, is that when the domain evolves, or we gain deeper insight, it's now easy to shift the interpretation, by simply making new projectors and read models, and replay the history of the system into them.

The projection can be expressed as a left fold:

```f(events) -> foldLeft(f', events, initialState)```


## Intention

```f(state) -> command```

One of the major consumers of the read models, is usually an end user. Many applications need to somehow report some state (projected in the previous section), for the user to look at and base decisions on. The user then makes his intention known to domain model, by sending commands. And it is an intention indeed, because, as we saw earlier, the Aggregate might refuse the command later.

Note that we don't present the user with the list of events, (unless that temporality is important). Humans are pretty bad at deducing state from events, which is why you should never base your opinion on that of one journalist or politician. In the case of our application, we give the user ready-made, automated interpretations.

It's the only function presented here that is not pure. Human users are influenced by lots of global state, they have ideas, principles, mood swings, and [biases](/2014/01/domain-driven-design-is-linguistic/). It's like they have a mind of their own! Modelling the end user is pretty much impossible...

## Automation

```f(events) -> command```

... but sometimes it is! Humans in organizations behave predictably in certain circumstances. Many tasks in an organization are repeatable: "Whenever X and Y have happened, Z needs to happen." Automating these business processes, making them faster and safer, is one of the appeals of enterprise software. Process Managers take on this job: they are event listeners, that react to certain events or combinations of events. They may hold intermediate state, so internally, they look like projectors. But the state is invisible. The only observable output are new commands.

In some cases, a Process Manager can output events straight away. This makes sense when there are no invariants other than what the Process Manager can take care of on its own. But most of the time, you'll want a proper Command that can be refused by an Aggregate.


## Read More

- [Fighting Bottlenecks with CQRS](/2013/12/fighting-bottlenecks-with-cqrs/)
- [Domain-Driven Design is Linguistic](/2014/01/domain-driven-design-is-linguistic/)


