---
title: The Specification Pattern in PHP - Introduction
slug: specification-pattern-php
date: 2012-12-12
layout: post
published: true
filename: 2012-12-12-specification-pattern-php.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
**                                                                      **
***********************************************************************-->


The Specification pattern, straight from DDD, is a very elegant way to encapsulate how you select objects, and, as we'll
see later on, it can be used to make testing database queries easy. Despite it's simplicity, I've never seen the pattern
being used in the PHP codebases I've worked on, apart from the ones where I introduced it myself, so it's time for a write up.

### Getting Started

We'll start with a very simple example. It'll look like overkill now, but bear with me. Imagine an ecommerce system
where customers with more than five orders get a 10% deduction.

{% highlight php %}
<?php
class Customer {
  private $orders = array();
  public function qualifiesForDeduction() {
    return count($this->orders) > 5;
  }
}
{% endhighlight %}

That's all dandy, but in real code this would get you in trouble. If you use a relational database, the `Customer` object
probably shouldn't hold a reference to all it's orders, as that could slow you down. And you'd probably want to do a `SELECT COUNT()` anyway,
instead of loading the orders into memory first and counting them there. You could solve this by moving the logic to a service
or a repository class, but you'd end throwing a bunch of somewhat unrelated methods together. Many people even put this in
a controller, but that's a big no-no.

More importantly, the business rule is hardcoded. Not just the number five is hardcoded; the rule that deductions depend
on the number of orders is hardcoded. That's going to be a problem when you have lots of installations of your ecommerce
system, each with different rules.

### When in doubt, encapsulate

A Specification has a very simple interface:

{% highlight php %}
<?php
interface CustomerSpecification {
  /** @return bool */
  function isSatisfiedBy(Customer $customer);
}
{% endhighlight %}

The `isSatisfiedBy()` method is always a simple yes/no question, and always takes just one argument, the object under scrutiny.

Now we can encapsulate our business rule in a separate class:

{% highlight php %}
<?php
class CustomerQualifiesForDeduction implements CustomerSpecification {
  public function isSatisfiedBy(Customer $customer) {
    return count($customer->getOrders()) > 5;
  }
}
{% endhighlight %}

Testing our Specification, or using it in our client code is straightforward:

{% highlight php %}
<?php
class CustomerQualifiesForDeduction extends PHPUnit_Framework_TestCase {
  public function testCustomerWithOverFiveOrdersSatisfiesSpecification() {
    $specification = new CustomerQualifiesForDeduction;
    $customer = new Customer;
    foreach(range(1,5) as $i) { $customer->addOrder(new Order($i)); }

    $this->assertFalse($specification->isSatisfiedBy($customer));
    $customer->addOrder(new Order(6));
    $this->assertTrue($specification->isSatisfiedBy($customer));
  }
}
{% endhighlight %}






### References

- http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215
- http://martinfowler.com/apsupp/spec.pdf

## Comments

<!-- To add a comment, copy this template:

### [YOUR NAME](YOUR URL) - YYY/MM/DD
YOUR COMMENT TEXT HERE....

-->
