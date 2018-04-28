---
layout: post
title: "Transitive Closure Clustering with SQL Server UDA and JSON"
subtitle: "Using SQL Server, UDA, JSON and some creative Lateral Thinkin to solve a common complex problem"
tags: sql-server json lateral-thinking graph transitive-closure clustering
---

For a feature we’re developing in
[Sensoria](http://www.sensoriafitness.com/), we had to solve one of the
well-know, yet hard to solve, problem with data and relationships
between elements in a data set. While there are several ways to solve
the same problem (just search for “transitive closure” with your own
favorite search engine), I’d like to describe here a very interesting
approach that not only shows how to leverage to the maximum SQL
Server/Azure SQL, .NET and its newly added JSON support, but also to
highlight that one key assets of an architect / developer, in a world
where (so-called) AI is going to be very strong, is the human ability to
find creative solutions. Thinking out-of-the-box or, in other words,
practice some *lateral thinking,* is going to be key factor in future:
let me show you one case that explains why.

## The Problem

Let’s make an example to clarify the problem. Let’s say you are at a
party where a lot of people have been invited, and you wonder how and if
people are connected to each other via common friends. Let’s use letters
to easily identify people, and let’s say we have this situation:

![](/public/images/2017-11-12/image-01.png)

As you can see, people can be divided in two groups, so that each group,
or *cluster*, will be made only of those people who are connected to
each other via a common friend, friend of a friend, and so on.

This means that you have to find the [transitive
closure](https://en.wikipedia.org/wiki/Transitive_closure) for the
elements and then create groups so that the elements with the same
transitive closure (said more easily: that are directly or indirectly
related to each other) will be in the same group.

## The obvious solution

This is a typical graph problem, and so, since we’re using SQL Azure, we
tried to use the new Graph features. Unfortunately calculating the
transitive closure is a feature that is not yet there, so another
solution was needed.

It seemed that the only option to solve our problem was to use a Graph
database ([Azure Cosmos
DB](https://docs.microsoft.com/en-us/azure/cosmos-db/graph-introduction)
would have been the choice), but that would have required us to move
data in/out of our database, which is Azure SQL, that in turn would have
made our architecture a little bit more complex — and thus more
expensive to manage and maintain—and, in addition, we would have needed
to figure out how to keep the two databases in sync.

Nothing really too complex or hard, but before going that road I decided
to spend some time to figure out if such solution would have been viable
with the good old SQL. If yes, it would have helped us to save time and
money while keeping the overall architectural complexity low (which
helps to have maintenance costs low and performance high). Modeling
graph using relational database it is possible and it is also quite
easy, as you can write the data shown above like a set of pairs:

![](/public/images/2017-11-12/image-02.png)

but performance are usually less than good when compared to Graph
databases. In our case we had a very specific use case, we just need to
group all the elements that are connected together, and thus we could
just focus to solve this specific problem.

## The creative solution

I proposed the problem to my good friend [Itzik
Ben-Gan](http://sqlmag.com/author/itzik-ben-gan) that helped me to find
a very nice SQL only solution that will soon be published on SQL Server
Magazine, but I also decided to try a different *creative* approach,
just to experiment a bit and keep my [*lateral
thinking*](https://en.wikipedia.org/wiki/Lateral_thinking) abilities
trained.

At a first glance this sounds to be the perfect job for an
[UDA](https://docs.microsoft.com/en-us/sql/relational-databases/clr-integration-database-objects-user-defined-functions/clr-user-defined-aggregates),
but there is the additional problem that a user defined aggregate must
return just a scalar value, which is the result of the aggregation
function applied to all values that belongs to the same group. If the
aggregation value is a *sum*, the returned scalar would be the value
obtained by summing all the group values, if the aggregation function is
*concatenation*, the resulting scalar would be a string containing all
the string values in the same group concatenated one after the other.

Now what if, due to how the custom aggregation function works, the data
may generate *subgroups*? And what if the number of such subgroups
cannot be known in advance, but only *after* that data has been
processed?

Let’s say, for example, you want to take all the orders of a customer,
and create an aggregation function that split them in two groups: those
who are above the customer’s order average amount and those who are
below. This can be easily done in SQL, I know, so I would never create
an UDA for this, but it easily and clearly explains the problem. This
kind of problems cannot be solved using a UDA, it seems, since the
return value *must* be a scalar and nothing else: no sub-grouping, since
how would you fit them into a scalar value?

Unfortunately for us, this constraint is blocking problem, since we need
to read all the data, and only after calculating the transitive closure
of each element, we know how many groups we really have. It may be one,
but it may be more than one, like in the example I described at the
beginning.

Now, let’s try to think in a very creative way: what is a scalar, but
can also be seen as a complex object…like an array of object? Yes: JSON
is an answer. Let’s say we don’t use letters but numbers, and thus the
original data can be rewritten as the following:

![](/public/images/2017-11-12/image-03.png)

Now, if an aggregation function could return a “scalar” value like:

    {
     "1": [1, 2, 3, 4, 5, 6],
     "3": [7, 8, 9, 10, 11]
    }

then the problem would be elegantly solved. As you can see the two
groups are correctly identified and each group has a unique number
assigned that identifies it.

Now, say that the UDA is called *TCC:*

![](/public/images/2017-11-12/image-04.png)

Once you have such JSON, transforming it into a table is a really
simple:

    WITH cte AS
    (
        SELECT 
            dbo.TCC([Person], [IsFriendOf]) AS Result 
        FROM 
            [dbo].[Friends]
    ),
    cte2 AS (
        SELECT
            CAST(J1.[key] AS INT) AS groupid,
            CAST(J2.[value] AS INT) AS id
        FROM
            cte
        CROSS APPLY
            OPENJSON(cte.[result]) J1
        CROSS APPLY
            OPENJSON(j1.[value]) J2
    )
    SELECT
        *
    FROM
        cte2

And the result will be

![](/public/images/2017-11-12/image-05.png)

Problem solved!

Now, this is exactly what I have built in the last days. You can find
the fully working code and example data here:

[yorek/non-scalar-uda-transitive-closure](https://github.com/yorek/non-scalar-uda-transitive-closure)

What I love of the solution, beside performances that will be discussed
later, is how it helps to make the solution easy, elegant and simple.
All the complexity is hidden and encapsulated into the UDA, data doesn’t
need to move around different systems, which help to reduce *friction*
and thus costs, and there is no need to learn a new language, like
[Gremlin](https://docs.microsoft.com/en-us/azure/cosmos-db/gremlin-support),
to solve our small and very specific problem.

## Performances

What about performances? Well, this is one of the **very** few occasion
where you can actually beat the database optimizer. Thanks to the fact
that the UDA allows you to scan data only once, you can load each number
into a list and add all the numbers into that list only if they are
connected. If they are not connected, just create a new list. If you
discover at some point that the two list have a common number (or friend
to follow the original example) you merge them into one.

This is just the perfect use case of the
[HashSet](https://msdn.microsoft.com/en-us/library/bb359438%28v=vs.110%29.aspx)
that has a [constant search
time](https://msdn.microsoft.com/en-us/library/bb356440%28v=vs.110%29.aspx)
— O(1) — but that unfortunately cannot be used in a SQLCLR object since
it is marked as *MayLeakOnAbort.*

The other object that offers the same constant search time is a
[Dictionary](https://msdn.microsoft.com/en-us/library/xfhwa508%28v=vs.110%29.aspx)
and the
[*ContainsKey*](https://msdn.microsoft.com/en-us/library/kw5aaea4%28v=vs.110%29.aspx)method
which *can* be used in SQLCLR. So I’ve built the entire algorithm around
a dictionary — a key-value pair — whose value is always set to *true*
(could also have been anything else, since I don’t use such value at
all), and the number that belong to the group represented by the
dictionary is stored as a key.

Performance are great as you can see in the comparison chart here:

![](/public/images/2017-11-12/image-06.png)

The values on the horizontal axis describes how the random test data was
built. 2000x100 means that data was generated so that the resulting
groups would have been 2000, each one with 100 elements in it. The SQL
solution used is the best one we’ve been able to find (big thanks to
Itzik, of course, that came up with a very elegant and clever solution).
Of course, if you can came up with a better one, let me know.

## Conclusions

*Lateral thinking* is our secret weapon. If you are afraid of AI coming
to steal your job, don’t be, and try to solve problems in the most
creative way, using your technical knowledge, intuition, gut feeling and
your ability to invent a solution where it doesn’t even seem to exists.

The very first solution I tried was so slow that after minutes, even on
small data sets, it was still running.

But then, in couple of days I’ve been able to find such solution, that
is just what we need right now: it allows us to keep overall
architecture complexity low and give us amazing performance, all of that
also allowing us to spare money (we’re 100% on the cloud, so we pay for
each bit we use…in this case means several thousands per year).

If in future we need some more complex graph support, extending our
platform to use Cosmos DB (or any other Graph Database) will be
inevitable and we’ll gladly embrace it, be assured: the message here is
not about which is the best technology to do what, but that one should
always try to look for a solution different than the obvious one. It
just may be the best one for the target use case.
