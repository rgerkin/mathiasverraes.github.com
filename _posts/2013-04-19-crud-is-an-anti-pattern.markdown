---
title: CRUD is an antipattern
slug: crud-is-an-anti-pattern
date: 2013-04-19
layout: post
published: true
filename: 2013-04-19-crud-is-an-anti-pattern.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
**                                                                      **
***********************************************************************-->

**tl;dr CRUD doesn't express behaviour. Avoid setters, and use expressive, encapsulated operations instead.**

CRUD is, as Greg Young calls it, our industry's [Grand Failure](http://herdingcode.com/?p=189). We have deluded our
users, and ourselves, that applications are nothing more than a thin layer around our database. We present the user
with grids and edit forms, and ask them to fill in fields, that we map more or less directly to our relational tables.
We use terms like "data model".

Real processes and businesses are not CRUD though. Real people don't say "I've set the paid amount of the order to '120',
the paid currency to 'EUR', and status to 'paid'". They say "I've paid €120 for the order".

A good domain model is not a data model. A domain model describes behaviour, and the data is an artefact of that. Let's
translate our user story to code.

### CRUD thinking:

{% highlight php %}
<?php
$order->setStatus('paid');
$order->setPaidAmount(120);
$order->setPaidCurrency('EUR');
$order->setCustomer($customer);
{% endhighlight %}

### Step 1: Replace a setter with an expressive method

{% highlight php %}
<?php
$order->pay();
{% endhighlight %}

Note that internally, the Order object still stores the `status` field. That's perfectly fine.

### Step 2: Replace values that belong together with a Value Object:

{% highlight php %}
<?php
$money = new Money(120, new Currency('EUR'));
$order->setPaidMoney($money);
{% endhighlight %}

I've written about Value Objects and Money elsewhere on this blog already.

### Step 3: Encapsulate Operation

{% highlight php %}
<?php
$order->pay($customer, $money);
{% endhighlight %}

It should be clear that the code in step 3 is a lot closer to demonstrating the behaviour and the actual purpose of our application.
We haven't changed anything in the internal representation of our Order object. It still has fields like
`paidAmount`, `paidCurrency`, `customerId`, and `status`, that are mapped to the database. Order no longer exposes it's
internals directly, but instead exposes a public api that is intention-revealing. It matches how users see our application:
as a set of behaviours, instead of a bunch of relational tables.


### Bonus points

Optionally, we can make it even more expressive by stating that it's the Customer who's paying:

{% highlight php %}
<?php
$customer->pay($order, $money);
{% endhighlight %}

The downside of this, is that we are coupling the Customer to the Order. This may or may not be desirable, depending on
context. In any case, it's always worth considering.




## Comments

<!-- To add a comment, copy this template: (don't worry about markup, I'll clean it up if need be)

### [YOUR NAME](YOUR URL) - YYY/MM/DD
YOUR COMMENT TEXT HERE....

-->
