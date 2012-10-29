---
title: Representing Money in PHP, Fowler-style
slug: fowler-money-pattern-in-php
date: 2011-04-04
layout: post
published: true
filename: 2011-04-04-fowler-money-pattern-in-php.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
**                                                                      **
***********************************************************************-->

Whenever working with values in object oriented programming, it's often a good idea to wrap them in a ValueObject. Money is a perfect candidate for a ValueObject: When talking about money, numbers are meaningless if they are not combined with a currency.

I've been using a very simple version of the Money pattern as described in [Martin Fowler's PoEAA](http://martinfowler.com/books.html). I couldn't find a PHP implementation anywhere, so I decided to make my own little open source library for it. You can find it on [my GitHub account](https://github.com/mathiasverraes/money) (where else?).

### Immutability

An important aspect of ValueObjects is their immutability:

Let's say Jim and Hannah both want to buy a copy of book priced at EUR 25.

<script src="https://gist.github.com/3973917.js?file=1.php"></script>

Jim has a coupon for EUR 5.

<script src="https://gist.github.com/3973917.js?file=2.php"></script>

Because `$jim_price` and `$hannah_price` are the same object, you'd expect Hannah to now have the reduced price as well. To prevent this problem, Money objects are immutable. With the code above, both `$jim_price` and `$hannah_price` are still EUR 25:

<script src="https://gist.github.com/3973917.js?file=3.php"></script>

The correct way of doing operations is:

<script src="https://gist.github.com/3973917.js?file=4.php"></script>


### Allocation

My company made a whopping profit of 5 cents, which has to be divided amongst myself (70%) and my investor (30%). Cents can't be divided, so I can't give 3.5 and 1.5 cents. If I round up, I get 4 cents, the investor gets 2, which means I need to conjure up an additional cent. Rounding down to 3 and 1 cent leaves me 1 cent. Apart from re-investing that cent in the company, the best solution is to keep handing out the remainder until all money is spent. In other words:

<script src="https://gist.github.com/3973917.js?file=5.php"></script>

Now `$my_cut` is 4 cents, and `$investors_cut` is 1 cent. The order in which you allocate the the money is important:

<script src="https://gist.github.com/3973917.js?file=6.php"></script>

Now `$my_cut` is 3 cents, and `$investors_cut` is 2 cents.

### Conclusion

At the moment my Money class has all the features that Fowler lists. You can see some more example by looking at the [unit tests](https://github.com/mathiasverraes/money/tree/master/tests). I hope to add a lot stuff more if time permits: currency conversion, parsing of strings like '$2.00' and 'USD 2.00', dealing with major units and subunits in currencies, etc. In any case, I hope it's useful to somebody in it's present form.

## Comments

<!-- To add a comment, copy this template:

### YOUR NAME - YYY/MM/DD
YOUR COMMENT TEXT HERE....

-->