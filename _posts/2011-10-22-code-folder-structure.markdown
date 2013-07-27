---
title: Code Folder Structure
slug: code-folder-structure
date: 2011-10-22
layout: post
published: true
---


All code bases I ever read or worked with, share a similar folder structure:


  * Controllers
    * BlogPostController
    * CommentController
  * Models
    * BlogPostModel
    * CommentModel
  * Views
    * BlogPostsView
    * BlogPostDetailView
  * Helpers
    * …


The ones where the developer has read Domain Driven Design, or is using Doctrine2 or Hibernate, usually have a better focus on the domain model:

  * Model
    * Entities
      * BlogPost
      * Comment
      * User
    * Repositories
      * BlogPostRepository
      * CommentRepository
      * UserRepository
    * Services
      * UserService
      * ...

The philosophy of these folder structures is usually inspired by the frameworks they use. After all, if your framework is organized like this, it must be a best practice, right? It does make really good sense for a framework to be organized in packages [modules, components, …] like this.

For your application, it’s a missed opportunity. You are not communicating the role each class has in relation to others, or the dependencies it has. A BlogPostRepository and a CommentRepository have no direct relation to each other, apart from the fact that they are both Repositories. However, a BlogPostRepository has a very tight dependency on BlogPost.

	
  * BlogDomain
    * BlogPost
      * BlogPost
      * BlogPostRepository
    * Comment
      * Comment
      * CommentRepository
  * CoreDomain
    * User
      * User
      * UserRepository

This makes it a lot easier to communicate bounded contexts, and to illustrate dependencies. For example, the BlogDomain depends on the CoreDomain. On a smaller scale, the BlogPost package depends on the Comment package. Zooming in even further, BlogPostRepository depends on BlogPost.

![Folder structure](/img/posts/folderstructure1.png)

In other words: A BlogPost and a Comment know about their author. A BlogPost has zero or more Comments, but the Comments are not aware that they belong to BlogPost. A BlogPostRepository manages BlogPost entities, but those entities have no idea that they are being managed.

Obviously the whole example is too simple, as examples usually are. The point is that, to keep code clean, it’s important to think hard about coupling between elements. A folder structure aides to delineate depedencies. Close proximity in the tree suggests closer coupling. Documentation can further help to explain the direction of the coupling. We may just as well decide that Comments do know about the BlogPost they belong too, but that should be a conscious decision.

