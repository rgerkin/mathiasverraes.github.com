---
title: Accessing private properties from other instances
slug: accessing-private-properties-from-other-instances
date: 2011-03-24
layout: post
published: true
filename: 2011-03-24-accessing-private-properties-from-other-instances.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
**                                                                      **
***********************************************************************-->

In PHP, when a property or method is marked private, it can only be accessed from within that class. That includes **other instances of the same class**. This may seem counter-intuitive at first, because we are used to dealing with instances of classes. The visibility operator however works not on object-level, but on class level.

An example:

<script src="https://gist.github.com/885448.js?file=private_properties1.php"></script>

This should make it clear that both instances of Foo have access to each other's private properties.

What practical use does this have? A great candidate for this are [Value Objects](http://domaindrivendesign.org/node/135). If we want to make sure that to separate instances of Foo are actually equal, we can easily compare their private properties:

<script src="https://gist.github.com/885448.js?file=private_properties2.php"></script>


## Comments

### Nicholas K. Dionysopoulos - 2011/03/24
Nice info, Mathias! It's very counter-intuitive indeed. On the other OO languages I know of (Delphi, various .NET dialects) a private variable is inaccessible outside the context of the owner object instance.

### Jonathan Mayhak - 2011/03/24
Good info. Had no idea php worked like this.

Also, great use case....very practical!

### Lolol - 2011/03/24
This is also the case in Java, which i found rather awkward when i found it.. but apparently it has some use. kind of takes away the principle behind private if you can extend a class to create functions to read another instance of that base class` privates :)

<!-- To add a comment, copy this template:

### YOUR NAME - YYY/MM/DD
YOUR COMMENT TEXT HERE....

-->