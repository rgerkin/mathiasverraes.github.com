---
title: Using Contextual Code Formatting for Readability
slug: 2013-01-05-contextual-code-formatting
date: 2013-01-05
layout: post
published: true
filename: 2013-01-05-contextual-code-formatting.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
**                                                                      **
***********************************************************************-->


I used to care a great deal about having a coding standard. I often took the initiative to write a document for the team that
 described the do's and don'ts, and I was often the one setting up automated formatting sniffers on every commit.

I've come to see that we have been ignoring an opportunity to use formatting to our advantage. By arguing and voting
over standards, and building automated tools to do the
formatting for us, and refusing commits that failed the formatting validators, we lost track of why we needed a standard
in the first place. It's not to fulfil the desire of the pedants in our teams, or for the esthetic of neatly aligned spaces.

The goal should be to write easily readable and maintainable code. What makes code more readable depends on context.

### An example

Can you spot the difference between these to statements?


{% highlight php %}
<?php
$countries = ["AD"=>"Andorra","AE"=>"UnitedArabEmirates","AF"=>"Afghanistan","AG"=>"AntiguaAndBarbuda","AI"=>"Anguilla","AL"=>"Albania","AM"=>"Armenia","AN"=>"NetherlandsAntilles","AO"=>"Angola","AQ"=>"Antarctica","AR"=>"Argentina","AS"=>"AmericanSamoa","AT"=>"Austria","AU"=>"Australia","AW"=>"Aruba",etc
$options = [
    "entryPoint" => "http://example.com",
    "alwaysUsePost" => false,
    "followRedirects" => false,
];
{% endhighlight %}


`$countries` is written very compact, no whitespace, in a single line that laughs in the face of 80 character margins.
 `$options`, despite having only three elements, uses ample whitespace and newlines. But why?

The `$countries` is not very readable, because it doesn't have to be. Chances are you'll never need to change that list, let alone
read it entirely. Just glancing at the beginning of the line tells you what you can expect the rest of the contents to be like.
And if you do need to update the countries, you'll probably copy/paste a list from somewhere else.

By writing the line very compact, you give a visual suggestion to the reader: "The contents of this line is not important to you,
don't bother reading it."

The contents of the `$options` array on the other hand are important. If one day you need to investigate why redirects aren't
 being followed, you will read this code and change it. You'll be thankful you didn't have to squint your eyes to find the relevant
 element in a huge unreadable compressed line of code.

### Drawing attention

That's just a simple example of making our formatting dependend on what works for a specific situation. Make the boring
implementation details, look like boring code. Compact the stuff the never changes, the generic boilerplate stuff, so that
 readers understand intuitively that it doesn't matter. But make the important code stand out. Highlight it using whitespace,
 well-placed comments, and attractive formatting. Be creative and figure out where formatting can help you be more expressive and
 intentional.



## Comments

<!-- To add a comment, copy this template:

### [YOUR NAME](YOUR URL) - YYY/MM/DD
YOUR COMMENT TEXT HERE....

-->
