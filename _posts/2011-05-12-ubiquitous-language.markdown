---
title: Ubiquitous Language
slug: ubiquitous-language
date: 2011-05-12
layout: post
published: true
---

Customers usually have never been forced to really think about their domain in a structured way -- let alone explain it in detail to a developer, who doesn’t know anything about that domain. Often the customer doesn’t have a set of clear definitions for the concepts his business uses daily, or has multiple terms for the same concepts.

Developers are even worse. They also tend to have vague concepts and lots of ways to name the same thing. Depending on where you look in the code or the documentation (if any), you might see: “bank account”, “account”, “bank_account”, “bankAccount”, “BankAccount”. And worse: “BA”, “bank_acc”, “acnt”. When storage is involved, you’ll find “item”, “row”, “record”, “model”. And another set of words for a collection of bank accounts: “list”, “array”, “collection”, “bankaccounts”, “acntset”, … you get the picture.

Even on small projects, this hinders communication. Developers, project managers, customers, and others involved with the project, need to communicate about the domain, but everybody uses a different, but equally vague terminology.

### A common language

The overcome this, you should start building a ubiquitous language, from the moment you start talking to the customer. Use a single term for a single concept, be it a thing, a relationship, or a behavior. Use the exact same term in the code, in the documentation, and in speech, and give it a strict spelling, down to the capitalization. Always “BankAccount”, never “bank account”. Don’t use abbreviations, as they make everything harder to read (except for really common ones, like “ISBN”).

You need to be disciplined about it, and expect the same from everybody involved: correct the customer when he uses a different word, fix the spelling when someone writes it down incorrectly, and change other’s code. Some people might get annoyed at first at your insistence, but they will soon get comfortable with using the language.

Maintain this ubiquitous language throughout the project. When concepts change, or your understanding of the domain changes, adjust the language, make sure it is adapted everywhere, and tell everyone.

### Benefits

You’ll notice that soon, communication between everyone in the project will go much easier. When something is unclear, you can refer to the documentation. For new people on the project, it will be a lot easier to get up to speed. Code becomes easier to read, and easier to understand, as there are less concepts, and they are clearly defined. The application is much less vulnerable to regressions, and changing or refactoring is a breeze.

