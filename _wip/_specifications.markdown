



- Introduction
- Configuring Specifications
- Boolean specifications and when to avoid them
- Naming specifications
- Define repositories?
- Selecting objects using Specifations
- Testing database queries using Specifications





intro idea:

ORM's are leaky abstractions. Even the best ORM's require you to understand how relational databases work. And that means
you will be writing queries. It doesn't mean ORM's are evil; they are merely a partial solution to a common problem.

However, the fact that ORM's are leaky, doesn't mean you should allow them to bleed all over your codebase. Most people
understand this, and group their queries in the Repositories. And in fact, Repositories are one of the few places in
the codebases where I **tolerate** queries.

starts with an innocent query, and as the applications evolve, they turn into the little monsters:
untestable, unmaintainable,
the whole idea is procedural: adding a method for each case

