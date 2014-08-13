---
title: Value Objects and User Interfaces
slug: value-objects-and-user-interfaces
date: 2013-11-15
layout: post
published: true
tags: [blog]
abstract: "Separate value objects in your model from concepts that serve the UI."
---

I got this mail from a listener of the [podcast episode on Value Objects](http://elephantintheroom.io/blog/2013/10/episode-2-heart-and-soul-of-oop/) I recorded with Konstantin:

<blockquote>
I've been listening to your Elephant in the room podcast Episode #002, i was wondering if you have a coding example of where you use the Country as a value object and not as an entity.

I've come across this problem too, and was hoping you may have an example that i can look at to give me a better understanding in terms of how to code this?

My first question would really be how would you logically store a list of all countries outside of a database if you were using value objects for use in a Form lookup field?
</blockquote>

There's nothing intrinsically wrong with modelling countries as entities and storing them in the database. But in most cases,
that overcomplicating things. Countries don't change often. When a country's name changes,
it is in fact, for all practical purposes, a new country. If a country one day does not exist anymore, you can't simply
change all addresses, because possibly the country was split into two countries.

Whenever you have this kind of friction, there's usually some missing concept screaming to be discovered. In this case,
two concerns are being mixed. One is a modelling concern: we want to treat `Country` as a value object with all the
benefits that it brings. The other is a user experience concern: we want to help the user to pick a country from a list, so we don't
end up with twenty different spellings of the same country. And finally, we'd probably want to validate somehow that the
submitted country indeed exists.

So what's the missing concept? The value object represents an actual country, and the UX and validation require a list of
available countries. Even though both are closely related, the nuance is slightly different. So let's make it explicit and
 call the new concept `AvailableCountries`. These available countries can be entities in a database, records in a JSON, or
 even simply a hardcoded list in your code. (That depends on whether the business wants easy access to them through a UI.)

In code, it could look something like this:

{% highlight php %}
<?php

final class Country
{
    private $countryCode;

    public function __construct($countryCode)
    {
        $this->countryCode = $countryCode;
    }

    public function __toString()
    {
        return $this->countryCode;
    }
}

final class AvailableCountry
{
    private $country;
    private $name;

    public function __construct(Country $country, $name)
    {
        $this->country = $country;
        $this->name = $name;
    }

    /** @return Country */
    public function getCountry()
    {
        return $this->country;
    }

    public function getName()
    {
        return $this->name;
    }

}

final class AvailableCountryRepository
{
    /** @return AvailableCountry[] */
    public function findAll()
    {
        return [
            'BE' => new AvailableCountry(new Country('BE'), 'Belgium'),
            'FR' => new AvailableCountry(new Country('FR'), 'France'),
            //...
        ];
    }

    /** @return AvailableCountry */
    public function findByCountry(Country $country)
    {
        return $this->findAll()[(string) $country];
    }
}
{% endhighlight %}

So now you can query `AvailableCountryRepository` to populate select boxes, and use it to see if a Country exists.

## When to use

This pattern should be easy to implement in many different ways, suited to whatever your use case is. Deciding when and
when not to use this pattern, is probably the hardest part. Start by imagining you are building a 'pure' model. There's
no UI, no database, just code. Is the thing you're modelling an entity or a value object? Does it change over time? If two
 instances have the same value, can they have a different identity? Or is it the value alone that defines what they are?
Try listing the problems you are trying to solve (model, UX, validation, ...) and try to come up with a separate solution
for each of them. Take decoupling to the max, poke around for missing concepts, and make the implicit explicit. Don't think
of database normalisation, relational integrity, performance, ... those are all optimisations that you can add on top of
your solution, as opposed to allowing your logical solution to be defined by the infrastructural constraints. And above all,
experiment, fail, try again, learn!


## Read More

- Elephant in the Room podcast, [Episode #002 on Value Objects](http://elephantintheroom.io/blog/2013/10/episode-2-heart-and-soul-of-oop/)
- [Accidental Entities - You don't need that identity](http://www.jefclaes.be/2013/05/accidental-entities-you-dont-need-that.html) by [@JefClaes](http://twitter.com/JefClaes)
- [Accidental Entities - What about the UI?](http://www.jefclaes.be/2013/05/accidental-entities-you-dont-need-that.html) by [@JefClaes](http://twitter.com/JefClaes)
- [Related Entities vs Child Entities](/2013/12/related-entities-vs-child-entities/)

