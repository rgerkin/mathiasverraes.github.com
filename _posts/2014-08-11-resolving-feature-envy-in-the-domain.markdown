---
title: Resolving Feature Envy in the Domain
slug: resolving-feature-envy-in-the-domain
date: 2014-08-11
layout: post
published: true
tags: [blog]
---

{% include tldr.html text="Expressing the Ubiquitous Language helps us to get rid of Feature Envy code smell." %}


[Benjamin Eberlei](https://twitter.com/beberlei) did [a really nice job of explaining refactoring the Feature Envy code smell](http://www.whitewashing.de/2014/08/11/spotting_featureenvy_and_refactoring.html) on his blog. I wrote a comment because I felt the example could be taken one step further. You should read the original post. Below are Benjamin's code examples (for reference), followed by a repost of my comment.

## Original examples


{% highlight php %}
<?php 
function calculateReport(DateTime $start, $days)
{
    if ($days < 0) {
        throw new InvalidArgumentException($days);
    }

    $endDate = clone $start;
    $endDate->modify('+' . $days . ' day');

    // calculation code here
}
{% endhighlight %}

Benjamin then explains how the calculation of the end date can be moved into a custom DateTime class, thus freeing `calculateReport()` from the responsibility:

{% highlight php %}
<?php 
class DateTime
{
    // ... other methods

    public function getDateDaysInFuture($days)
    {
        if ($days < 0) {
            throw new InvalidArgumentException($days);
        }

        $endDate = clone $this;
        $endDate->modify('+' . $days . ' day');

        return $endDate;
    }
}

function calculateReport(DateTime $start, $days)
{
    $endDate = $start->getDateDaysInFuture($days);

    // calculation code here.
}
{% endhighlight %}


## Whole Value

`calculateReport()` is envious of an object that does not yet exist. `DateTime` and `$days` (an int) belong closely together, they are one concept. Grouping them together into one logical value is a pattern called Whole Value. The implementation of that pattern in OOP is a Value Object.

{% highlight php %}
<?php 
function calculateReportFor(ReportingPeriod $reportingPeriod)
{
    // no more period calculation here
    // calculation code here.
}
{% endhighlight %}


By having a single value object that represents a period instead of two values, we have the added benefit that `calculateReportFor()` adheres to SRP now: it doesn't calculate periods, it only calculates reports.

So where does the `ReportingPeriod` come from? We could just instantiate it:

{% highlight php %}
<?php 
$startDate = new DateTime('now');
$endDate = $start->getDateDaysInFuture($days);
$reportingPeriod = new ReportingPeriod($startTime, $endDate);
{% endhighlight %}


But now we moved to responsibility of calculating the end date to the client, which creates lots of boring duplication. Value objects have the property of attracting behavior. We can add a nice little static factory method to instantiate our `ReportingPeriod`:

{% highlight php %}
<?php
$reportingPeriod = ReportingPeriod::forDuration(DateTime $startDate, $days);
{% endhighlight %}

## Applying Domain-Driven Design

Now let's take a closer look at the domain. (Of course there's no real domain in Benjamin's example code, so I'm going to assume we're dealing with finance.) Reports in financial statements don't just cover any random period, they cover months, quarters, or years. Let's make that explicit:

{% highlight php %}
<?php
calculateReportFor(ReportingPeriod::month(12, 2014));
calculateReportFor(ReportingPeriod::quarter(4, 2014));
calculateReportFor(ReportingPeriod::year(2014));
{% endhighlight %}

Because calculateReportFor() is decoupled from the calculation of periods, it's reusable for any kind of period, so the option of passing in arbitrary ReportPeriods is still there if we need it. The important thing is that we are modelling the Ubiquitous Language, staying close to the domain, and have smaller, simpler, more reusable, SRP objects, that are also easier to test in isolation.

## Read more

- [Named Constructors](/2014/06/named-constructors-in-php/)
- [When to Use Static Methods](/2014/06/when-to-use-static-methods-in-php/)
- [DRY is about Knowledge](/2014/08/dry-is-about-knowledge/)