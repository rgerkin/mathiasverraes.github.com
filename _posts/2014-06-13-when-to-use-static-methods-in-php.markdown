---
title: "When to Use Static Methods"
slug: when-to-use-static-methods-in-php
date: 2014-06-13
layout: post
published: true
tags: [blog]
---

{% include tldr.html text="Static methods? Yes, when they are stateless." %}


Some of the reactions to my last blog post on [Named Constructors in PHP](/2014/06/named-constructors-in-php/), originate from the notion that static methods are inherently bad and should never be used. This is rather overgeneralized. 

Static methods are nothing more than namespaced global functions. Namespacing, I think we can all agree on, is great. As for global functions: We use those all the time. The native functions in PHP form our basic building blocks.

The problem to consider is shared global state. The example that I gave in my previous post, is referentially transparent:

{% highlight php %}
<?php
$time = Time::from("11:45");
{% endhighlight %}

In other words, it is stateless, it is free of side effects, and as such, it is entirely predictable. You can call the exact same function with the exact same argument as often as you like, and you will always get the exact same result back (a Time instance with value 11:45), no matter the history of the system, no matter the context from which you call it. 
 
Another example:

{% highlight php %}
<?php
$sum = Calculator::sum(1, 2); 
{% endhighlight %}

Again, the outcome is predictable. `Calculator::sum($x, $y)` provides a service that is stateless, that doesn't remember anything, and whose outcome can't be influenced by anything other than the arguments you put in there. Furthermore, this service will never have polymorphic, or have different implementations. Returning anything other 3 would break the contract. Of course, you could come up with a more efficient algorithm for adding to numbers, but that would have no effect on any of the clients of Calculator.

For a counterexample, let's look at a stateful service:

{% highlight php %}
<?php
Counter::increment(1);
$count = Counter::getCount();
{% endhighlight %}

This is of course a simple example, but in more complex situations, it can be rather opaque to understand this statefullness. Imagine that one developer use the Counter in one part of the code, and another developer uses it in another part. They both test their code in isolation, and it works fine. As soon as the parts are integrated, the count becomes erratic, because they both share the same global state, instead of each owning a separate Counter. The solution is to have objects here:


{% highlight php %}
<?php
$myCounter = new Counter;
$myCounter->increment(1);
$count = $myCounter->getCount();
{% endhighlight %}


## Abstractions


You might still feel resistance against something like `Calculator::sum($x, $y)`, because it can not be extended or mocked. Keep in mind however that we are at the lowest level of abstraction here. You can't extend or mock the + operator either in PHP.  Yet you've never felt the need for that. If you do need higher levels of abstraction, then composition is your friend. OOP composition is well known, but let's look at FP really quickly. There is, in PHP, an interesting distinction between `+` and `Calculator::sum($x, $y)`: the former can not be injected, the latter can:
 
{% highlight php %}
<?php
$result = array_reduce([1,2,3], 'Calculator::sum', 0);
// $result = 6
{% endhighlight %} 

I'm getting in the realm of higher-order programming now, which is rather out of scope, but let's just agree that functions and static methods can be very useful, with the right mindset.

## Read More

 - [Named Constructors in PHP](/2014/06/named-constructors-in-php/)
