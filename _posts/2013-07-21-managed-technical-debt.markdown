---
title: Managed Technical Debt
slug: managed-technical-debt
date: 2013-07-21
layout: post
published: true
filename: 2013-07-21-managed-technical-debt.markdown
---
<!-- *********************************************************************
**                                                                      **
** To add a comment, scroll to the bottom and use the comment template. **
** Then save the file and send me a pull request.                       **
** (Or just send me an email. The whole fork-to-comment idea was an     **
** experiment, but I guess it failed. I will replace it with something  **
** simpler soonish.                                                     **
**                                                                      **
***********************************************************************-->


[Alberto Brandolini](https://twitter.com/mathiasverraes/status/326435664319111170) said at IDDD Belgium (quoting from memory):
"We've always explained 'technical debt' badly to the business. If you have debt with a bank, you can talk to someone,
negotiate, and agree on a payment plan. But technical debt is like debt with the mob: they come at night, pointing a gun
to your head, and they want their money NOW."

[Greg Young](http://codebetter.com/gregyoung/2013/03/06/startups-and-tdd/) on the other hand, has talked on several occasions about how technical debt is not necessarily bad. Businesses
take loans all the time. They are a powerful tool to make an investment now, and pay for it later. It's a fundamental
aspect of our economy.

### Shortcuts


I get very irritated when a non-technical person tells me to take shortcuts to meet a deadline. Or -- even worse -- when
 a developer-turned-project-manager does so. Technical debt is often what made the project slow in the first place. And as
 a consultant being more and more specialized in "problem projects", I've seen a lot of crappy code that grinds projects
 to a halt.

And yet, I myself tell teams to take shortcuts all the time. But there's a difference. I know the codebase intimately.
I know where it's problematic, and where it's under control. I know what is covered with tests, which parts are hurting us,
and which parts are simply not elegant. And most importantly: when I introduce technical debt, I know how to get rid of
it, and I refactor as soon as I feel it's needed. I add comments in the code suggesting how to change it, and often I
hang a sticky note in the backlog. Whenever new code is affected by earlier debt, I bump the priority of the backlog item.

### Team discipline

When opinions are at odds, like in the quotes above, there's often a problem in the language. There's one term, and two
concepts. In the interest of making
the implicit explicit, I'd like to propose that we make a clear distinction between **Managed Technical Debt**, and **Unmanaged
Technical Debt**. The former is defined as technical debt where most of the following conditions are present:

- The team is disciplined: it applies techniques such as refactoring, pair programming, iterative development, CI, TDD (or other testing schemes) ...
- The codebase is well structured, well tested, and stable.
- When introducing new technical debt, the team estimates the cost/benefit.
- Even though the introduced solution is not optimal, the team understands what the optimal solution would be, and how
the current solution can later be evolved towards that goal.
- Technical debt is documented.
- Technical debt is not introduced on top of existing technical debt.
- Existing technical debt is paid off as soon as there's a clear need.

For Unmanaged Technical Debt on the other hand, most of the opposite conditions are present:

- The team lacks maturity.
- Hacks are built as workarounds for the effects of previous hacks.
- The team is unaware that a newly introduced solution is not optimal,
- or the team is aware, but does not understand what an optimal solution would be or how to achieve it.



## Comments

<!-- To add a comment, copy this template: (don't worry about markup, I'll clean it up if need be)

### [YOUR NAME](YOUR URL|TWITTER|...)  - YYYY/MM/DD
YOUR COMMENT TEXT HERE....

-->
