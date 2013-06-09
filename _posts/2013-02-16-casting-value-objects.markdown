---
title: Casting Value Objects to strings
slug: 2013-02-16-casting-value_objects
date: 2013-02-16
layout: post
published: true
filename: 2013-02-16-casting-value-objects.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
**                                                                      **
***********************************************************************-->

__tl;dr: Cast Value Objects to strings that can be parsed back into the Value Object.__


I'm a big fan of Value Objects, as they are very helpful in encapsulating behavior, and communicating intent. In fact, as a
friend remarked, Value Objects are the heart and soul of Object Oriented Programming. Discussing the uses of Value Objects
is not what I want to talk about here though.

Let's set up two simple examples first:

{% highlight php %}

<?php
class TwitterHandle
{
    private $handle;

    public function __construct($handle)
    {
        // Put some validation here, like a regex check
        $this->handle = $handle;
    }
}

class DateRange
{
    private $start, $stop;

    public function __construct(DateTime $start, DateTime $end)
    {
        // Put some validation here, like checking if $end > $start
        $this->start = $start;
        $this->stop = $end;
    }
}

{% endhighlight %}


### Simple string casting

Value Objects are one of the few places where using [PHP's magic __toString()](http://www.php.net/manual/en/language.oop5.magic.php#object.tostring)
makes perfect sense. For single-value Value Objects like the `TwitterHandle`, it's obvious what should be in there. The
_toString() method simply returns the string representation.

{% highlight php %}

<?php
class TwitterHandleTest extends PHPUnit_Framework_TestCase
{
    /** @test */
    public function ItShouldCastToString()
    {
        $twitterHandle = new TwitterHandle('@mathiasverraes');
        $this->assertEquals(
            '@mathiasverraes',
            (string) $twitterHandle,
            "Casting a TwitterHandle to a string "
            ."should return the string version of the handle"
        );
    }
}

{% endhighlight %}

Implemented inside TwitterHandle, it looks like this:

{% highlight php %}

<?php
class TwitterHandle
{
    private $handle;

    // constructor ....

    public function __toString()
    {
        return $this->handle;
    }
}

{% endhighlight %}

That's quite self-evident, but what about other cases?

### Rules for casting Value Objects to string

I had a couple of basic rules, that I have been using for a while for Value Objects. They were always implicit, but
talking about them in a pair programming session made them explicit.

### 1. Don't use _toString() for presentation.

It's tempting to use a __toString() method to render the Value Object in a View. More often
than not, you would need to put presentation logic in your Value Object, and that's a big no-no. It's better to perform
presentation rendering in a separate class or function, like a filter for your templating engine. It allows you to fine-tune
the rendering for your use case.

{% highlight html %}

<span>
Find me on Twitter:
<?php renderAsTwitterLink($user->getTwitterAccount()) ?>
</span>

<!-- renders to: -->

<span>
Find me on Twitter:
<a href="https://twitter.com/mathiasverraes" title="Visit Twitter">
    @mathiasverraes
</a>
</span>

{% endhighlight %}

Imagine we would have put the HTML rendering inside the TwitterHandle class; that would have been a sackable offense in
my book! You'll notice that this is especially important with Value Objects like dates and monetaries, where the
rendering depends on the language.


### 2. Always return a complete representation of the Value Object.

Another temptation is to use string casting to get the numeric part of a measurement.

{% highlight php %}

<?php
$aDistance = new Distance(5, 'meters');
$this->assertEquals('5', (string) $aDistance); // bad, don't do this

{% endhighlight %}

`'5'` is not a valid representation of a distance. Is it meters, centimeters, or inches? That information is now lost. If you start doing
calculations with that `'5'`, you may get nasty bugs. [The kind of bugs that crash spacecrafts](http://en.wikipedia.org/wiki/Mars_Climate_Orbiter).
So make sure that the string represents all of the Value Object:

{% highlight php %}

<?php
$aDistance = new Distance(5, 'meters');
$this->assertEquals('5 meters', (string) $aDistance); // much better

{% endhighlight %}


### 3. Return a parsable string

The most useful string representation you can come up with, is one that can be parsed back into the Value Object. For the
TwitterHandle example, that's again very easy, so let's use DateRange as an example:

{% highlight php %}

<?php
$aDateRange = new DateRange(
    new DateTime('2013-01-01'),
    new DateTime('2013-02-07')
);

$stringVersion = (string) $aDateRange;
$this->assertEquals('2013-01-01 - 2013-02-07', $stringVersion);

$parsedDateRange = DateRange::parse($stringVersion);
$this->assertEquals($aDateRange, $parsedVersion);

{% endhighlight %}

So as you can see, `'2013-01-01 - 2013-02-07'` is a string representation of a DateRange, that can be parsed back into a DateRange object.
In pseudocode:

`DateRange == parse(string(DateRange))`

It works just as well for our other examples:

{% highlight php %}

<?php
$this->assertEquals(
    new Distance(5, 'meters'),
    Distance::parse(
        (string) new Distance(5, 'meters')
    )
);
// leaving the implementation as an exercise for the reader :-)

{% endhighlight %}

This will turn out to be very handy, especially when integrating with other systems, like a REST api or a database. But
that's something we'll cover in a future blog post.

Related posts:

 - [Representing Money in PHP, Fowler-style](/2011/04/fowler-money-pattern-in-php/)


## Comments

<!-- To add a comment, copy this template: (don't worry about markup, I'll clean it up if need be)

### [YOUR NAME](YOUR URL|TWITTER|...) - YYYY/MM/DD
YOUR COMMENT TEXT HERE....

-->
