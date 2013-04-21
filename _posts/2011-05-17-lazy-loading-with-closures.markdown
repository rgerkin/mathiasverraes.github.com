---
title: Lazy Loading in PHP with Closures
slug: lazy-loading-with-closures
date: 2011-05-17 21:57:07
layout: post
published: true
filename: 2011-05-17-lazy-loading-with-closures.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
**                                                                      **
***********************************************************************-->

Closures are a great way to do all kinds of neat tricks in PHP, and they’re particularly useful for  Lazy Loading. I’m
currently involved in a +200k SLoC legacy project, and the challenge is moving it to a Domain Driven implementation
(while improving the performance), with the ultimate goal of making it more testable.

### The problem

We want to find a Customer, and ask it for a list of Orders:

{% highlight php %}
<?php
// client code
$customer = $customerRepository->find($id);
$orders = $customer->getOrders();
{% endhighlight %}

With the ActiveRecord pattern, this is simple. The Customer object holds an instance of the database adapter, and queries
it for related Orders:

{% highlight php %}
<?php
class Customer
{
    public function getOrders()
    {
        $ordersData = $this->db->query(/* select orders... */);
        $orders = array();)
        foreach($ordersdata as $orderdata) {
            $orders[] = new Order($orderdata);
        }
        return $orders;
    }
}
{% endhighlight %}

The downside of ActiveRecord, is that it violates the principle of Separation of Concerns. The Customer class contains
domain knowledge (“What is a customer, how does it behave?”), as well as persistence knowledge (“How do we store a customer?”).
The Customer class in our example even knows how to find it’s Orders in the database. The tight coupling between Customer
and the database makes it less portable, and hard to test.

In DDD, we solve this by keeping the Customer class pure, and move the logic for storing the object to a CustomerRepository.
Clients of the Repository don’t know how or where it finds Customers, and the Customer class itself doesn’t know anything
about the Repository or the database it is stored in. As for the Orders, they are pushed in the Customer at creation time.

{% highlight php %}
<?php
class Customer
{
    public function getOrders()
    {
        return $this->orders;
    }
}

class CustomerRepository
{
    public function find($id)
    {
        $customerdata = $this->db->query(/* select customer ...*/);
        $customer = new Customer($customerdata);

        $ordersdata = $this->db->query(/* select orders ... */);
        foreach($ordersdata as $orderdata){
            $customer->addOrder(new Order($orderdata));
        }
    }
}
{% endhighlight %}

Note that the client code for this example is still the same as in the first snippet.

### Adding Lazy Loading to the mix

The problem with the previous example is that we always query the database for the Orders, even when we don’t need them.
We don’t want to move that query back to the Customer class, but we want to keep our client code intact. The trick is to move the logic for finding Orders into a Closure, push it into the Customer instance, and execute only when we actually need the Orders. In other words, Customer now holds a reference to the Orders, and only dereferences it at the very last moment -- hence the term Lazy Loading.

{% highlight php %}
<?php
class Customer
{
    public function setOrdersReference(Closure $ordersReference)
    {
        $this->ordersReference = $ordersReference;
    }

    public function getOrders()
    {
        if(!isset($this->orders)) {
            $reference = $this->ordersReference;
            $this->orders = $reference();
        }
        return $this->orders;
    }
}

class CustomerRepository
{
    public function find($id)
    {
        $db = $this->db;
        $customerdata = $db->query(/* select customer ...*/);
        $customer = new Customer($customerdata);

        $ordersReference = function($customer) use($id, $db) {
            $ordersdata = $db->query(/* select orders ... */);
            $orders = array();
            foreach($ordersdata as $orderdata) {
                $orders[] = new Order($orderdata);
            }
            return $orders;
        };
        $customer->setOrderReference($ordersReference);
        return $customer;
    }
}
{% endhighlight %}

The client code is still exactly as in the very first code snippet. But this time, when we call getOrders(), the Closure
we prepared in find() is executed. It’s self-contained: it has the database instance and the Customer’s id, and it knows
what to do. Customer on the other hand has no idea what goes on inside the Closure, but can perfectly deliver on getOrders() calls.

### Conclusion

Clearly this is a simplified example. My colleague, who has a lot more experience with the project, pointed out a whole
bunch of real life use cases where this method would cause an abundance of queries. I'll keep you posted when we figure
out how to deal with those.


## Comments

### Alessandro Nadalin - 2011/05/17
One of the good things of doctrine 1 was that it used lazy loading by default.
That meant if you didn't want to do N bunch of separated queries you only needed to do a ->leftJoin() when quering a Doctrine_Table (which, conceptually, is similar - but far away - to the repository).

But it was active record... gosh :)

BTW, i'd suggest not to inject the whole instance of the DB abstraction into the closure, but something like a query object ( Doctrine_Query, for instance )

In order to avoid "a whole bunch of real life use cases where this method would cause an abundance of queries" you should not use a ->find(), which should be relation-agnostic, but some other pre-defined methods like:

{% highlight php %}
<?php
class UserRepository
{
  public function getUserWithFriends($userId)
  {
      return $this->createQuery('UserTable')->leftJoin('friends')->blablabla();
  }
{% endhighlight %}

### Herman Peeren - 2011/05/17
My idea about Lazy Loading:

The Lazy Loading in this example only is more efficient when the total number of hits to getOrders() is less than the number of customer-objects.  So, it depends on the situation when to use Lazy Loading or not.

To be able to take this design decision, you need to know in what situations it will be used: the "art" of programming.

### Mathias Verraes - 2011/05/17
Exactly. I failed to mentioned that normally, you'd use an ORM like Doctrine2 to do this kind of stuff. Unfortunately the project is too large, too complex, and too critical to refactor to Doctrine2 (or at least not in one go).

### Herman Peeren - 2011/05/17
But, as far as I know, Doctrine2  ALWAYS uses Lazy Loading. And my point is: there might be situations where that is not the best choice. So, we have a lot of ease of use when using an ORM-framework, but will sometimes get a lack of performance.

An advantage when you need to program everything yourself, is that you can still take the decision yourself to use Eager or Lazy Loading. As Johan Cruijff (Dutch Ajax Champion) would say: "every disadvantage has it's advantage".

<!-- To add a comment, copy this template: (don't worry about markup, I'll clean it up if need be)

### [YOUR NAME](YOUR URL|TWITTER|...) - YYYY/MM/DD
YOUR COMMENT TEXT HERE....

-->
