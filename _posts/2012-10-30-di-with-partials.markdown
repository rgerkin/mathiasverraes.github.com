---
title: Javascript Dependency Injection with partial functions
slug: javascript-dependency-injection-with-partial-functions
date: 2012-10-30
layout: post
published: true
filename: 2012-10-30-di-with-partials.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
**                                                                      **
***********************************************************************-->

For a new project, I'm writing a CQRS/ES application (my first), and I'm doing that in Node.js (also my first). I've never
done any serious Javascript programming, so my gut reaction is to try and mimck patterns and concepts that I'm used to in
class-based languages. Turns out Javascript allows you to do a whole bunch of things differently, and, dare I say it,
more elegantly. All you have to do is let go of the luggage you bring from languages like Java or PHP.

Say we want to handle some commands. In classical OOP, we'd start by making a `CommandHandler`, and give it one public method
called `handle(command)`. Our method is probably oing to have some services it depends on, like a Repository. We inject that
into the class' constructor. (Note that in javascript, passing `repository` as a parameter will automatically bring it into scope
in `handle()`).

Elsewhere, we create an instance of the `CommandHandler` -- for example when we set up a dependency injection container.
And again elsewhere, we call the `handle` method on our instance.

<script src="https://gist.github.com/3972442.js?file=class-based.js"></script>

### Going class-less

This sort of code is all too familiar, and it's perfectly valid in Javascript. But a couple of things bug me. First of
all there's the Noun.verb() combo. We're really only interested in one method: `handle`. Yet we have to have a class,
with an artificial name like `CommandHandler`, which is just a there to bring us the `handle` method.

A second quirk of class-based OOP, is that we need to have a class, as well as an instance of that class. I'm not saying there's
anything wrong with that, but after a couple of days diging into Javascript, it feels silly.

So let's get rid of the class, and keep only the verb, aka the `handle()` method. That means we now have to pass in the
`Repository` in some other way. We can pass it in as a parameter, but that's awkward, because then we'd have to have the
`Repository` object available everywhere we want the `handle()`, but that's too much internal information for client code to know.

### Partial functions to the rescue

Functional programming has a neat little trick that can be applied here. A partial is function that takes another function,
and 'pre-fills' a number of parameters. It returns a function that only needs the leftover parameters. Here's a typical
example:

<script src="https://gist.github.com/3972442.js?file=partial-example.js"></script>

Partials can easily be used to 'configure' a function in a DIC, and the use the pre-configured version of the function in the client code:

<script src="https://gist.github.com/3972442.js?file=function-based.js"></script>

I'm still playing around with this kind of code, so I haven't decided yet if this is the approach I'll be using to replace
all single-method classes. In any case, Jaavascript's dynamic nature makes it easy to come up with many different ways of
doing this.

## Comments

<!-- To add a comment, copy this template:

### YOUR NAME - YYY/MM/DD
YOUR COMMENT TEXT HERE....

-->