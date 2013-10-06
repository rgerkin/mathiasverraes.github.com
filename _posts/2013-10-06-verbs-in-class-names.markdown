---
title: Verbs in Class Names
slug: verbs-in-class-names
date: 2013-10-06
layout: post
published: true
---

{% include tldr.html text="Use a verb to build a sentence. There will be no translation to code in your brain. The sentence _is_ the code." %}


When you first learned Object Oriented Programming, somebody probably told you that objects map to things. And that still holds true
most of the time. And maybe somebody explained it using the simple heuristic to "look for the nouns", which can indeed be a great
discovery technique. But then somebody probably phrased that as "class names should not have verbs in them". To me,
that rule is severely limiting the possibilities for your models. So here are some cases where I prefer to use verbs.



## Messages

The king sends a message to the general: "Attack the enemy on the south flank with three divisions". The general does as
 he's told, and succeeds. He sends a message back to the king: "The enemy is defeated!". Peace is restored in the
 [Kingdom of Nouns](http://steve-yegge.blogspot.co.uk/2006/03/execution-in-kingdom-of-nouns.html).

The messages that are sent back and forth, are "things", so they can be modeled as objects. Message objects have all the benefits
of OOP: you can pass them around, have type hinting, encapsulation... They can have properties: `private $flank = 'south'`,
`private $numberOfDivisions = 3`. You can serialize the messages, send them over the wire,
persist them in an audit log, or even an event store. You can publish the messages, or put them in a message queue, using
ZeroMQ or an alternative.

If you know me at all, you know I'm obsessed with naming. So what should we name these two messages? We could use the
nouns "Attack" and "Defeat", as in `AttackMessage`, `DefeatMessage`. (English is a bit messy in this regard, as nouns and
verbs are often exactly the same word -- an attack, to attack.) To me, this naming is too vague, too implicit. Let's try
a bit harder. Both message objects are very much alike. Are we missing a concept? If we focus on the differences, then we
discover that one of them is a (Domain-) Command: The king tells the general what to do. The other one is a (Domain) Event: it's something
that happened in the past, that is of interest to the king: the enemy was defeated. `AttackCommand`, `DefeatEvent`? Close.

The most expressive option is to name it after its purpose. `AttackEnemy implements Command`, `EnemyWasDefeated implements Event`.
Again, we have the problem with English here. But this time it's either an imperative verb ("Do This"), or a past tense ("This happened").
More examples are `CheckoutBasket`, `PayForOrder`, `OrderWasPaid`, `OrderWasShipped`.

There's no ambiguity about what any of these objects represents. And you can use them to build expressive api's:
`$auditLog->recordThat(new EnemyWasDefeated($onDate));` Imagine the `new` keyword isn't there, and what you end up with is a nice
sentence, saying exactly what it does: the audit log records that the enemy was defeated on a certain date.


## Specifications

The Specification pattern is a way to model business rules as individual objects -- I talk about this in
[Unbreakable Domain Models](/2013/06/unbreakable-domain-models/). The idea is that a question about an object, is answered by a
`isSatisfiedBy()` method:


{% highlight php %}
<?php
class CustomerIsPremium implements CustomerSpecification {
    public function __construct($someCollaborator) { /* ... */ }

    /** @return bool */
    public function isSatisfiedBy(Customer $customer) {
        // figure out if the customer is indeed premium and return true or false.
    }
}
{% endhighlight %}

Other examples are `OrderIsReadyForShipment`, `BankAccountIsWithinCreditLimit`, ...
Again, having the verb in there makes it much more natural. They are small, composable objects, and you can build sentences from them.


## Exceptions

Exceptions can be similar to events, as they describe something that has happened in your system, with the nuance that it is
an undesirable event, a warning that some operation was inconsistent with, for example, business rules that are in effect. For
application- or infrastructure-level exceptions, I don't really bother much: `DbException` or `FSException` are fine, the
message string will usually tell you more, and it's all very technical anyway. But for domain model exceptions, I want it,
 once more, in the language of the business: `OrderShipmentHasFailed`, `BackAccountWasOverdrawn`. I don't generalize them
 either: I have an individual exception class for each specific occasion.


## Interfaces

Interfaces are not classes, but close enough for inclusion. I go on about them in [Sensible Interfaces](/2013/09/sensible-interfaces/),
but let's hammer it some more.

{% highlight php %}
<?php
class FireEmployee implements DomainCommand, HasPermissions {
   public function getPermissions() {
       return ['ROLE_CEO', 'ROLE_HR_MANAGER'];
   }
}
{% endhighlight %}

I feel like I'm ranting here, but once, again, it's a sentence in natural language. You can talk to another developer and
say "This domain command has permissions". There is no additional translation in your brain that converts that sentence to
 code such as `implements Permissionable`.

The sentence _is_ the code.


### Read more

- [Sensible Interfaces](/2013/09/sensible-interfaces/)
- [Execution in the Kingdom of Nouns](http://steve-yegge.blogspot.co.uk/2006/03/execution-in-kingdom-of-nouns.html)
- [Unbreakable Domain Models](/2013/06/unbreakable-domain-models/)
- [Class names with verbs enforce the Single Responsibility Principle](http://schneide.wordpress.com/2012/10/01/class-names-with-verbs-enforce-the-single-responsibility-principle-srp/)

