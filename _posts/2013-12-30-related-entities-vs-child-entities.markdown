---
title: Related Entities vs Child Entities
slug: related-entities-vs-child-entities
date: 2013-12-30
layout: post
published: true
tags: [blog]
abstract: "Making the difference between Related Entities and Child Entities explicit, and choosing your modelling strategy accordingly, will pay off in the long term."
image: "http://verraes.net/img/posts/2013-12-30-related-entities-vs-child-entities/marshfrog_illus_cropped.jpg"
---




## Entity

<img style="float:right;margin-left: 10px" src="/img/posts/2013-12-30-related-entities-vs-child-entities/marshfrog_illus_cropped.jpg" alt="Frog lifecycle">

An **Entity is an object in our Domain Model with an identity and a lifecycle**. "Lifecycle" means that it is created, possibly changes over time, and eventually can cease to exist. Throughout this lifecycle, we need some way to identify this object, especially when our system talks to other systems about this Entity.

Imagine a simple project management application. When we start a new Project, we give it a name, a due date, and a 'started' status. We assign an identifier to the Project. Later, at different times, we rename the Project, change the due date, and, at a certain point, and change the status to 'ended'. After a while, we delete the Project from the system. Because we need to work with this Project at different times in its lifecycle, we need to persist it to something more trustworthy than memory. We use a database for this, and every time we want to access the Project, we use its identifier to talk to the database. Our system is not an island: we publish a list of Projects to client systems, and these clients can query our system for the current state of a Project, also by using the identifier.


## Entity relationships

Two entities, of the same or of different types, can have a relation. In our example, we could be interested in the Employee who is responsible for the Project, and the Employees who are assigned to the Project. Projects and Employees have their own lifecycles: Both can change independently, the link can be broken. If a Project is cancelled (deleted), the Employee Entities are not deleted, and when an Employee is fired, the Project can still continue to exist. This is a weak relationship.


## Child Entities

Sometimes, an **Entity's lifecycle is entirely dependent on another Entity. We call this a Child Entity**. It's a strong relationship: the Child Entity has only meaning in the context of its parent, and cannot exist outside of it. If the Parent Entity ceases to exist, the Child Entity is deleted as well. Ideally, all operations on the child are handled by the parent, even its creation.

In our example, our Project has Tasks. A Task is part of one Project, and one Project alone. The Task can't be created independently of the Project, it can't exist outside of it, and when the Project is deleted, its Tasks are deleted. Tasks have a 'completed' boolean flag. Clearly a Task has a lifecycle: it gets created, at a certain point it is completed, and it can be removed. This lifecycle only exists in the context of Project.

Why is all of this important? **Modelling is the art of making the implicit explicit**. By making the difference between related Entities and Child Entities explicit,we open up the possibility to treat them differently, make different design decisions, and optimise differently. It's going to affect how we encapsulate behaviours, how we build repositories, REST APIs, and database schemas. It determines the boundaries of our models, which in turn determines the opportunities for partitioning our system. **Thinking hard about this difference, is going to help us decide what to couple, and what to decouple**.

## Coding the example

Let's build the code for Project and Task. Keep in mind that this is not necessarily the best or the only way to do it. I just want to try to get you to think about how Child Entities differ conceptually from related Entities at the same hierarchical level of each other.


{% highlight php %}
<?php
final class Task
{
    private $description;

    public function __construct($description)
    {
        $this->description = $description;
    }
}

final class Project
{
    /**
     * @var string
     */
    private $projectId;

    /**
     * @var string
     */
    private $title;

    /**
     * @var Task[]
     */
    private $tasks = [];

    public function __construct($projectId, $title)
    {
        $this->projectId = $projectId;
        $this->title = $title;
    }

    public function addTask($description)
    {
        $this->tasks[] = new Task($description);
    }
}
{% endhighlight %}

In this code, Task is effectively a Value Object. That could definitely work, but in remember that we want to track whether a Task is completed. A Task that is completed, is still the same Task, even though one of its properties changed. Its identity remains, independent of its values. That makes it an Entity.

Why is `Project#addTask()` taking only a description, and not a Task instance? Tasks are an essential part of a Project. We want our Project Parent Entity to be in control of the lifecycle of Task. That means we don't want other code to start making Task objects. In PHP, there's no concept of 'friend classes', so we can't really prevent anyone from making Task instances -- [except by the power of code reviews](/2013/10/pre-merge-code-reviews/) :-)


Moving on, we need a way to identify Tasks. We give the control over the Task identity to Project. A Task's identity only has meaning in the context of Project, so the id does not have to be unique across all Tasks, only across Tasks within a Project. Here's a simple solution:

{% highlight php %}
<?php
final class Task
{
    private $taskId;
    private $description;

    public function __construct($taskId, $description)
    {
        $this->taskId = $taskId;
        $this->description = $description;
    }
}

final class Project
{
    // ...
    public function addTask($description)
    {
        $this->tasks[] = new Task($this->getNextTaskId(), $description);
    }

    private function getNextTaskId()
    {
        return count($this->tasks) + 1;
    }
}
{% endhighlight %}

Because we can now identify Tasks, we can complete individual Tasks.

{% highlight php %}
<?php
final class Task
{
    // ...

    /**
     * @var bool
     */
    private $completed = false;

    public function getTaskId()
    {
        return $this->taskId;
    }

    public function complete()
    {
        $this->completed = true;
    }
}


final class Project
{
    // ...

    public function completeTask($taskId)
    {
        $this->getTaskById($taskId)
            ->complete();
    }

    private function getTaskById($taskId)
    {
        foreach($this->tasks as $task) {
            if($task->getTaskId() == $taskId) {
                return $task;
            }
        }
        // throw
    }
}
{% endhighlight %}

As you can see, Task is still entirely private to Project. Only Project knows how to complete a Task. If for some reason, the underlying code changes completely, the API of Project will remain intact. Hopefully, this illustrates how **the Child Entity pattern fits nicely with object oriented ideas of information hiding and encapsulation**. Imagine that every object only has access to a very limited set of information, a limited set of operations on a limited set of collaborators. Writing spaghetti code would be impossible. We can't protect our code to that extent, but having a mental model of this, is definitely going to help you reason about your system.

Another benefit of all this encapsulation, is that Project can guard invariants for its set of Tasks. One such invariant could be a business rule stating that "Tasks can only be completed if the Project has at least five Tasks." This business rule should not be guarded inside Task, but Project is a natural fit for it.

Other operations on Task, like changing the description and removing a Task, can be handled in the same manner. I leave that as an exercise for the reader.

## Persistence

In the real world, we can't keep all of this in memory, so we persist stuff in databases. If we want to map Project and Task to a relational database, we'd likely use a one-to-many relationship. We'll need to make a slight change to our code.

{% highlight php %}
<?php
final class Task
{
    private $projectId;
    private $taskId;
    private $description;

    public function __construct($projectId, $taskId, $description)
    {
        $this->projectId = $projectId;
        $this->taskId = $taskId;
        $this->description = $description;
    }
    // ...
}

final class Project
{
    // ...
    public function addTask($description)
    {
        $this->tasks[] = new Task($this->projectId, $this->getNextTaskId(), $description);
    }
}
{% endhighlight %}

Before, the Task didn't know about the Project it belonged to. Now it does, which is a slightly annoying trade-off. Just be aware that we don't really want a bidirectional relation here. We could give Task a reference to Project instead of just the projectId, and let the ORM work it out.

In our database schema, Task's primary key is a composite of projectId and taskId. If the ORM or the infrastructure doesn't deal well with composite ids that are also foreign keys, we could make taskId the only primary key, and make it unique for all Tasks. Again, conceptually, this is a small trade-off, with benefits and drawbacks.

## Repository

Because Task is a Child Entity, it doesn't have its own repository. All write operations can easily be done by fetching the Project instance from the ProjectRepository, and calling methods on Project that manipulate its Tasks, as shown above. For reading, we do the same: we see Project as a complete unit, including its children, so when we fetch a Project, we get the full object graph. This only includes Child Entities, and not related entities such as User. If we were to include all related entities as well, we risk getting into a big, highly coupled mess. We could get circular references (which your ORM should deal with, but still). And we would be very tempted to access methods on the User objects we get from Project, which would be a clear violation of the Law of Demeter.

But again, in the real world, we might run into issues. We may need reports across Child Entities from different parents, for example a list of incomplete Tasks for the whole system. Fetching all Projects and looping over their Tasks might cause performance issues. A read model projection could fix this, but it's out of scope for this post. We can introduce a TaskRepository to answer such queries. It blurs the line of a Child Entity's encapsulation, but again, if we are aware that it is a trade-off, we are already better equipped than if we did it blindly, without consideration.

## Passing references

To render a Project with its Tasks, we'll need to access Tasks in the view, so we need Project to expose a getTasks() method. The idea here is that what you get from this method, is a **passing reference** to Tasks. You are allowed to use it, but your use is temporary. Your client code is supposed to forget about the Task object, and always refer back to Project if it needs it again.

## Coupling

To wrap it up, have a look at the graph below.

<!-- Source of this svg is in /graphs/2013-12-30-related-entities-vs-child-entities.dot -->

<svg width="255pt" height="264pt"
 viewBox="0.00 0.00 254.94 264.00" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<g id="graph0" class="graph" transform="scale(1 1) rotate(0) translate(4 260)">
<title>g</title>
<polygon fill="white" stroke="white" points="-4,4 -4,-260 250.941,-260 250.941,4 -4,4"/>
<g id="clust1" class="cluster"><title>cluster_0</title>
<polygon fill="Lavender" stroke="black" points="8,-130 8,-248 209,-248 209,-130 8,-130"/>
</g>
<g id="clust2" class="cluster"><title>cluster_1</title>
<polygon fill="palegreen" stroke="black" points="133,-8 133,-92 203,-92 203,-8 133,-8"/>
</g>
<!-- Project -->
<g id="node1" class="node"><title>Project</title>
<polygon fill="white" stroke="black" points="134.536,-139 134.536,-239 201.464,-239 201.464,-139 134.536,-139"/>
<text text-anchor="middle" x="168" y="-221" font-family="Times,serif" font-size="14.00">Project</text>
<polyline fill="none" stroke="black" points="134.536,-214.2 201.464,-214.2 "/>
<text text-anchor="middle" x="168" y="-196.2" font-family="Times,serif" font-size="14.00">projectId</text>
<text text-anchor="middle" x="168" y="-179.4" font-family="Times,serif" font-size="14.00"> title</text>
<text text-anchor="middle" x="168" y="-162.6" font-family="Times,serif" font-size="14.00"> tasks[]</text>
<text text-anchor="middle" x="168" y="-145.8" font-family="Times,serif" font-size="14.00"> assignee</text>
</g>
<!-- Task -->
<g id="node2" class="node"><title>Task</title>
<polygon fill="white" stroke="black" points="16.1465,-155.8 16.1465,-222.2 97.8535,-222.2 97.8535,-155.8 16.1465,-155.8"/>
<text text-anchor="middle" x="57" y="-204.2" font-family="Times,serif" font-size="14.00">Task</text>
<polyline fill="none" stroke="black" points="16.1465,-197.4 97.8535,-197.4 "/>
<text text-anchor="middle" x="57" y="-179.4" font-family="Times,serif" font-size="14.00">taskId</text>
<text text-anchor="middle" x="57" y="-162.6" font-family="Times,serif" font-size="14.00"> description</text>
</g>
<!-- Project&#45;&gt;Task -->
<g id="edge1" class="edge"><title>Project&#45;&gt;Task</title>
<path fill="none" stroke="black" d="M134.41,-189C126.171,-189 117.164,-189 108.301,-189"/>
<polygon fill="black" stroke="black" points="108.017,-185.5 98.0169,-189 108.017,-192.5 108.017,-185.5"/>
<text text-anchor="middle" x="115.768" y="-194.8" font-family="Times,serif" font-size="14.00">has</text>
</g>
<!-- User -->
<g id="node3" class="node"><title>User</title>
<polygon fill="white" stroke="black" points="141,-16.8 141,-83.2 195,-83.2 195,-16.8 141,-16.8"/>
<text text-anchor="middle" x="167.993" y="-65.2" font-family="Times,serif" font-size="14.00">User</text>
<polyline fill="none" stroke="black" points="141,-58.4 194.986,-58.4 "/>
<text text-anchor="middle" x="167.993" y="-40.4" font-family="Times,serif" font-size="14.00">userId</text>
<text text-anchor="middle" x="167.993" y="-23.6" font-family="Times,serif" font-size="14.00"> name</text>
</g>
<!-- Project&#45;&gt;User -->
<g id="edge2" class="edge"><title>Project&#45;&gt;User</title>
<path fill="none" stroke="black" d="M168,-138.927C168,-124.099 168,-107.947 168,-93.5798"/>
<polygon fill="black" stroke="black" points="171.5,-93.4779 168,-83.4779 164.5,-93.478 171.5,-93.4779"/>
<text text-anchor="middle" x="207.471" y="-105.4" font-family="Times,serif" font-size="14.00"> is assigned to</text>
</g>
</g>
</svg>

It should be clear now that Project and Task are highly cohesive, and have strong coupling, because that's what they are like in our simple domain. On the other hand, User is only very weakly coupled to Project. I find that most people, when building models, make no distinction between these relations, and simply use the same approach for everything. The result is that the connection between parents and children is too weak, and the relation between merely related entities, is too strong. This coupling creates messy models. The underlying business reasoning is not made explicit in the model.

As is always the problem with examples, is that the one I used here is too simple and not production-ready. Consider it pseudo-code, to illustrate the concept, rather than a set of rules of how to model a domain. If nothing else, I hope it helps you to model more explicitly.

## Read more

- [CRUD is an anti-pattern](/2013/04/crud-is-an-anti-pattern/)
- [Value Objects and User Interfaces](http://verraes.net/2013/11/value-objects-and-user-interfaces/) (and especially the comments)
- Elephant in the Room podcast, [Episode #002 on Value Objects](http://elephantintheroom.io/blog/2013/10/episode-2-heart-and-soul-of-oop/)
