---
title: Interface discovery with PHPUnit’s Mock objects
slug: interface-discovery-with-phpunit-mock-objects
date: 2011-03-21
layout: post
published: true
filename: 2011-03-21-interface-discovery-with-phpunit-mock-objects.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
**                                                                      **
***********************************************************************-->

[PHPUnit](https://github.com/sebastianbergmann/phpunit/) provides some great features to create [mock objects](http://en.wikipedia.org/wiki/Mock_object). The idea is that when you are testing code that depends on another class, you provide the object with a mock instance of that class, instead of a real object. That way, you are making sure that your test will only fail if the system under test is broken, and not if one of it’s dependencies is broken. You could simply write a mock class and instantiate it, but PHPUnit can generate them for you.

The PHPUnit documentation doesn’t explicitly state this, but you can also create mock objects from interfaces. This makes a lot of sense if you think about it. In many cases, you should actually use mocked interfaces in your tests instead of mocked concrete classes. After all, the interface is the contract by which classes agree to talk to the outside world.

### A simple example

Let’s write some code, in true [TDD](http://en.wikipedia.org/wiki/Test-driven_development) style. Let’s say we want to post to Twitter whenever someone deposits money in our bank account. We don’t want the test to actually send out tweets. In fact, we haven’t even thought about what our Twitter class will look like. This is our test:

<script src="https://gist.github.com/879470.js?file=BankAccountTest1.php"></script>

Running this test fails, as we haven’t got a BankAccount class yet.


    PHP Fatal error:  Class 'BankAccount' not found

Let’s add it:

<script src="https://gist.github.com/879470.js?file=BankAccount1.php"></script>

The test now succeeds, for the simple reason we are not really testing anything. Let’s make sure that BankAccount::deposit() actually sends out a tweet. We do this by telling the mock to expect a call to it’s tweet() method.

<script src="https://gist.github.com/879470.js?file=BankAccountTest2.php"></script>

The test fails with the following message:


    1) BankAccountTest::testSendEmailWhenReceivingMoney
    Expectation failed for method name is equal to <string:tweet> 
    when invoked 1 time(s)
    Method was expected to be called 1 times, actually called 0 times.

Let’s add some code that calls tweet() to our deposit() method.

<script src="https://gist.github.com/879470.js?file=BankAccount2.php"></script>

We get a new error:

    PHP Fatal error:
    Call to undefined method Mock_Twitter_28053312::tweet()

Mock_Twitter_28053312 is the class that PHPUnit generated based on the Twitter interface, which we haven’t written yet. The good news is that by now, we have discovered what the interface should look like:

<script src="https://gist.github.com/879470.js?file=Twitter.php"></script>

### Conclusion

The whole point of this technique, is that we have now written BankAccount, without worrying how our Twitter implementation will work. In the process, we discovered that we will need an implementation of a Twitter interface, and we discovered what that interface looks like.

Later on, we probably build a RESTfulTwitter implements Twitter, which would post messages using the Twitter REST API. If we had build the Twitter implementation first, we’d probably would have been tempted to add all kinds of features that we thought we might need. Instead of that, we discovered what we actually needed. Our test proves that our code adheres to [YAGNI](http://en.wikipedia.org/wiki/You_ain't_gonna_need_it).


## Comments

<!-- To add a comment, copy this template:

### [YOUR NAME](YOUR URL) - YYY/MM/DD
YOUR COMMENT TEXT HERE....

-->
