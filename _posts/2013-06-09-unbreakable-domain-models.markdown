---
title: Unbreakable Domain Models
slug: unbreakable-domain-models
date: 2013-06-09
layout: post
published: true
tags: [talk]
image: "https://speakerd.s3.amazonaws.com/presentations/838642907d6c0131238f2adccd741a3a/slide_0.jpg?1393018100"
---

### Slides

<script async class="speakerdeck-embed" data-id="838642907d6c0131238f2adccd741a3a" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
[See the slides on Speakerdeck](https://speakerdeck.com/mathiasverraes/unbreakable-domain-models-phpuk-2014-london#)

## Video

<iframe width="560" height="315" src="//www.youtube.com/embed/ZJ63ltuwMaE?list=PL_aPVo2HeGF-7o9SPO5arFrAaU8bcIjba" frameborder="0" allowfullscreen></iframe>
[Watch the video on Youtube](http://www.youtube.com/watch?v=ZJ63ltuwMaE&feature=share&list=PL_aPVo2HeGF-7o9SPO5arFrAaU8bcIjba&index=8)

### Abstract

Data Mappers (like Doctrine2) help us a lot to persist data. Yet many projects are still struggling with tough questions:
- Where to put business logic?
- How to protect our code from abuse?
- Where to put queries, and how test them?

Let’s look beyond the old Gang of Four design patterns, and take some clues from tactical Domain Driven Design. At the heart of our models, we can use Value Objects and Entities, with tightly defined consistency boundaries. Repositories abstract away the persistence.  Encapsulated Operations helps us to protect invariants. And if we need to manage a lot of complexity, the Specification pattern helps us express business rules in the language of the business.

These patterns help us evolve from structural data models, to rich behavioral models. They capture not just state and relationships, but true meaning.

The presentation is a fast paced introduction to some patterns and ideas that will make your Domain Model expressive, unbreakable, and beautiful.

### Events


#### Future

- Your company or event? [Contact me](http://verraes.net/#contact)

#### Past

- [Confoo](http://confoo.ca/en/2014/session/unbreakable-domain-models) in Montreal, Canada, February 24-28, 2014
  - [Feedback collected by the organizers](/img/posts/2013-06-09-unbreakable-domain-models/UnbreakableDomainModels-Confoo14-feedback.pdf)
- PHPUK in London, UK, Februari 21-22, 2014
  - Reviews on [joind.in](http://joind.in/talk/view/10690)
- [PHPNW](http://conference.phpnw.org.uk/phpnw13/schedule/mathias-verraes/) in Manchester, UK, October 4-5, 2013
  - Review by [Jerome Gill](http://www.boxuk.com/php-north-west-2013)
  - Review by [Martin Bean](http://martinbean.co.uk/blog/2013/10/09/php-north-west-2013-conference/)
  - Reviews on [joind.in](https://joind.in/9312)
- [FrOSCon](http://programm.froscon.org/2013/events/1243.html) in Sankt-Augustin, Germany, August 24-25, 2013
  - Reviews on [joind.in](http://joind.in/talk/view/9020)
- [Dutch PHP Conference](http://www.phpconference.nl/talks#mathias-verraes-unbreakable-domain-models) in Amsterdam, Netherlands, June 6-8, 2013
  - Review by [Rowan Merewood](http://techportal.inviqa.com/2013/06/12/dpc13/)
  - Review by [Richard Tuin](http://www.enrise.com/2013/06/a-review-of-the-dutch-php-conference-2013/)
  - Review by [Ray Burgemeestre](http://blog.cppse.nl/dutch-php-conference-2013)
  - Reviews on [joind.in](http://joind.in/talk/view/8438)
- [Dataflow Community Evening](http://www.dataflow.be/nl/eerste-community-gent) in Ghent, Belgium, May 8, 2013

## Learn More
Check out [Elephant in the Room #002: The Heart and Soul of OOP](http://elephantintheroom.io/blog/2013/10/episode-2-heart-and-soul-of-oop/) for more info about Value Objects.