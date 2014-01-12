---
title: Interface Segregation Like You Mean It
slug: interface-segregation-like-you-mean-it
date: 2014-01-11
layout: post
published: true
---

{% include tldr.html text="A richer toolbox of naming strategies, induces better interface segregation." %}

<img style="float:right;margin-left: 10px" src="/img/posts/2014-01-11-interface-segregation-like-you-mean-it/vormenstoof.jpg" alt="The iron Dobbin is one creepy looking vehicle">


One of the qualities of good design, is that it reduces the cognitive load required to operate it. Complexity can be measured as the number of concepts you need to understand and keep in memory *at the same time*. Compare the microwave oven I have (lots of menus, buttons, cryptic icons, and programs I don't use) with the microwave oven I wish I had (a start and a stop button, a dial, and a time display).

Software code is naturally complex, which is why software design is always a hot topic. One well-known, but not-so-well applied design guideline, is the Interface Segregation Principle (ISP), which states that **a client should not be forced to depend on methods it does not use**. The machine cares little about such rules, so the principle clearly exists for the benefit of the human reader of the code. I used to believe that the ISP was merely a specialisation of the Single Responsibility Principle (SRP), but the two principles are in fact quite independent.

The ISP can be stated in a more general way: a client should not be forced to be **exposed to concepts it does not require**. Or: a client should not **gain additional complexity that serves no purpose**. The Interface Segregation Principle expresses a desire for simplicity. The idea is not new at all, as it was beautifully worded by Antoine De Saint Exupéry:

<blockquote>Il semble que la perfection soit atteinte non quand il n'y a plus rien à ajouter, mais quand il n'y a plus rien à retrancher.</blockquote>

Let's look at a very simple EventStore.

{% highlight php %}
<?php
interface EventStore
{
    /**
     * Commits a sequence of Domain Events to the database
     * @param DomainEvent[] $events
     * @return void
     */
    public function commit(array $events);

    /**
     * Retrieves all Domain Events for a particular stream from the database
     * @param StreamId $streamId
     * @return DomainEvent[]
     */
    public function fetchBy(StreamId $streamId);

    /**
     * Retrieves all Domain Events since the beginning of time from the database
     * @return DomainEvent[]
     */
    public function fetchAll();
}

interface StreamId { /*...*/ }
interface DomainEvent  { /*...*/ }
{% endhighlight %}

(Don't worry if you know little about event sourcing, this story is about the interfaces anyway.)

Typically, a Repository would use the EventStore to store the changes from an Aggregate, and to reconstitute an Aggregate from its history (the AggregateId in the domain, translates to the StreamId in the EventStore's lingo). In other words, the Repository is interested in `commit()` and `fetchBy()`.

A second client, is a Projector. A Projector listen to events, and uses that information to create a read model. Sometimes, you'll want to replay a Projector from the beginning of time. You're interested in `fetchAll()` and nothing else.

Finally, a third client might be some legacy code, that doesn't use event sourcing, but that you want to emit events anyway, for consumption in newer parts of the code. This legacy code will `commit()` events, but not fetch them.

The Repository is interested in both reading and writing events, but the Projector only reads, and the legacy only writes events. `EventStore` applies the SRP, as its responsibility is to represent an event store database. But both Projector and the legacy model are forced to depend on functionality and methods they have no use for. To find perfection, we need to take concepts away, not add them.



{% highlight php %}
<?php
interface EventStore extends SegregatedInterfaceA, SegregatedInterfaceB {}

interface SegregatedInterfaceA
{
    public function commit(array $events);
}

interface SegregatedInterfaceB
{
    public function fetchBy(StreamId $streamId);
    public function fetchAll();
}

interface StreamId { /*...*/ }
interface DomainEvent  { /*...*/ }
{% endhighlight %}

The Repository is still allowed to depend on the `EventStore` interface, but the Projector depends on `SegregatedInterfaceB` only, and the legacy code on `SegregatedInterfaceA`. No code is now depending on features it doesn't care about. Achievement unlocked, Master Segregator Badge awarded!


## Naming segregated interfaces

This, of course, leads us to my pet problem of naming things. Ah naming! The noble art of expressing an idea elegantly, in the No Man's Land where [linguistics and mathematics live together in an uneasy relationship](/2014/01/domain-driven-design-is-linguistic/). The obvious contestants are:

{% highlight php %}
<?php
interface EventStore extends EventCommitter, EventFetcher {}
{% endhighlight %}

Although years of exposure to Java-like nominalisation, you may have grown used to words like EventCommitter and EventFetcher. I'll let you in on a secret: nobody talks like that. Would you talk like that to your mother? Before I start ranting about the ugliness of this made-up language, let us put my personal sense of aesthetics aside.

I feel there is a deeper issue. We've invented new words. New concepts. Didn't we agree earlier that we wanted to reduce the number of concepts? Granted, EventCommitter and EventFetcher are not that far removed from the method names they expose. But it's easy to go wild in a naming frenzy. We've all seen AbstractDecoratorProxyFactories, and we can never un-see it.

## From ontological to behavioral naming

How about this?

{% highlight php %}
<?php
interface EventStore extends CommitsEvents, FetchesEvents {}

interface CommitsEvents
{
    public function commit(array $events);
}

interface FetchesEvents
{
    public function fetchBy(IdentifiesStream $streamId);
    public function fetchAll();
}

interface IdentifiesStream { /*...*/ }
interface DomainEvent  { /*...*/ }
{% endhighlight %}

The resulting client code looks like this:

{% highlight php %}
<?php
interface ProjectsEvents
{
    public function projectFrom(FetchesEvents $eventStore);
}

interface CollectsAggregates
{
    public function get(IdentifiesAggregate $aggregateId);
}
{% endhighlight %}

I believe this solves the problem of introducing new concepts. I've been exploring this style of naming recently, and it just feels really nice to me. It's a little more advanced than the ideas I proposed in [Sensible Interfaces](/2013/09/sensible-interfaces/). The difference is subtle, but here it's no longer just about the contracts. Instead of using interfaces as purely ontological statements, they focus purely on behavior. Client code declares what behavior it expects its collaborators to have. It doesn't matter anymore whether the client is passed an EventStore, a Dog, or a SingletonProxyAbstractFactoryInvokerProvider. As long as it `IdentifiesAggregates`, it fits our purpose. This is the ultimate decoupling. It is, in my opinion, much closer to what Alan Kay meant: it's all about the messaging. It's not about the what the object is, it's about how it communicates to other objects.

There are some downsides of course. It works much better in programming languages that put the typehint after the variable name:

{% highlight php %}
<?php
interface ProjectsEvents
{
    public function projectFrom($eventStore FetchesEvents);
}

interface CollectsAggregates
{
    public function get($aggregateId IdentifiesAggregate);
}
{% endhighlight %}

It would also work better if the 'implements' keyword is omitted.

{% highlight php %}
<?php
final class MySQLEventStore implements CommitsEvents, FetchesEvents { /* ... */ }
// vs
final class MySQLEventStore CommitsEvents, FetchesEvents { /* ... */ }
{% endhighlight %}

This mismatch between my language and the programming language, is something you quickly overcome. After all, you're a programmer, you're good with building mental models from coded information. The minor, temporary inconveniences, don't measure up to the benefit of an expressive language, closer to natural language, expressing communication instead of state.

## Opinions and experiments

I'm not suggesting to use this style for every interface. Perhaps there needn't be a rule. Find the name that suits best through trial and error. Naming things is hard, but it's supposed to be hard. It drives our thinking. Trying to replace the act of naming, with simple one-size-fits-all conventions, for the sake of convenience, is just lazy.

You may feel strong disagreement with my naming. It probably breaks with every convention you know. Keep in mind though that conventions come from habit. Habit comes from repeatedly applying solutions that worked. So inherently, a convention is always a solution to yesterday's problem. I enjoy reading people's opinions, but before you comment, consider trying this style for a while. After reading my tweets about this idea, [@cryptocompress](http://twitter.com/cryptocompress) built a simple proof of concept [PHP preparser](https://github.com/cryptocompress/PreHParser), that allows you to omit the 'implements' keyword, and switch variable names and typehints, just to get a feel for it. I think that deserves our respect. In the end, he still seemed unimpressed, but at least it was an opinion founded on experience. Experiments trump opinions, every time.


