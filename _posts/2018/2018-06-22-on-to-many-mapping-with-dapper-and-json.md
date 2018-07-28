---
layout: post
title: "1:N Mapping with Dapper and JSON"
subtitle: "A nice way to deal with a very common request and complex objects"
tags: dapper dotnet micro-orm orm json one-to-many
published: true
---

In a real-world scenario, dealing with one-to-many relationships is very common.
A customer and its orders, an order and its items, a class and its students…and
the list can go on and on forever.

Unfortunately such common problem is not natively managed by Dapper. Yes, you
can find a workaround using Multiple Records, as also described here: [Multiple Recordset](#TBD).


but the solution is really not friendly nor straightforward, and requires you to
write code that is somehow unnatural, especially for seasoned data developer. In
a one-to-many relationship a *join *or a subquery would be the way to return the
data, but when using the Multiple Resultsets technique, you have to resort to
return two separate resultset instead and join them manually on the client side
to avoid to deal with duplicated data.

Luckily, with some [lateral
thinking](https://en.wikipedia.org/wiki/Lateral_thinking), and the JSON support
in SQL Server 2016 an later, the problem can be easily and elegantly solved.

Let's say we have the following object model:

![](/public/images/2018-06-22/image-02.png)

If we could have a json like the following returned from the database then it
would be perfect: it would be easily deserialized into our object model,
correctly allowing us to return a one-to-many relationship object graph.

    {
        "EmailAddress": "info@davidemauri.it",
        "FirstName": "Davide",
        "Id": 5,
        "LastName": "Mauri",
        "Tags": [
            {
                "Name": "Developer"
            },
            {
                "Name": "Data Guy"
            }
        ]
    }

Well, with SQL Server 2016 and after, it is pretty easy to do, thanks to the FOR
JSON PATH option. If we have the data stored in two tables like this:

![](/public/images/2018-06-22/image-03.png)

the query we have to write to return data into the expected json format is
pretty easy and clear:

![](/public/images/2018-06-22/image-04.png)

The trick here is to use the `JSON_QUERY` function to tell the engine that we
want to have a *Tags *object as child of the root object. Please also note the
double parenthesis used in the `JSON_QUERY` invocation. That function expects a
json string as parameter, and by wrapping the `SELECT` statement in additional
parenthesis we're telling the engine that we want to pass the result of the
`SELECT` into the function. Since that result is already a JSON string, the
`JSON_QUERY` is needed in order to avoid json to be escaped and turned into a
string in the final result.

Now that we have a query able to return json in the format we want and that can
be deserialized into our model without any further processing, all is left to do
is tell Dapper how to manage the User object so that it will nicely and
automatically take care of serializing and deserializing that object to/from the
json representation for us. As I described here: 
[Custom Type Handling](/2018/04/15/custom-type-handling), this can be done writing a Custom Type Handler. It will be really really simple:

![](/public/images/2018-06-22/image-05.png)

That's it! Just serialize and deserialize, and nothing else. As you can easily
guess, such simple class is better to be turned into a generic class, so that it
can be used to manage any object. That's exactly what you'll find the the
samples available on GitHub.

In the sample code you'll also find how you can return one json document for
each User, in case you want to return more than one user a time. It's nothing
more than an additional iteration of `JSON_QUERY` usage, but if you're new to SQL
it may not be so easy to figure out, so I though it could be helpful to have a
sample showing how you can get this:

![](/public/images/2018-06-22/image-06.png)


That will work perfectly with Dapper.

## Samples

As usual all samples are here on GitHub. There are two examples related to this
post: "*One-To-Many*" that is the one used to explain how to make it work, and
the "*Complex Custom Handling*" that shows how to deal with complex object where
you have to build a complex json, with arrays, nested objects and do so on.

https://github.com/yorek/dapper-samples

## Conclusion

The described techniques really opens up a world of possibilities. I encourage
you to read, for example, how I used that to replace [ElasticSeach with Azure
SQL](https://medium.com/@mauridb/from-elasticsearch-back-to-sql-server-597249c16a9d),
and to use the JSON support in SQL Server more and more since it really help to
create clean, lean and easy to maintain solutions.

It will be possible, in fact, to create a simple extension method like this:

![](/public/images/2018-06-22/image-07.png)

So that you can use Dapper to deal with complex objects and one-to-many
relationship by just executing the following code:

![](/public/images/2018-06-22/image-08.png)

Simple, Clean, Lean and developer and data friendly. You get the best of both
world: object oriented encapsulation and well structured code and relational
database power and correctness.

## What's Next

Well…this is the end of this series. I think I've covered all the things you
have to know to work with Dapper. If you want to read more on a specific
subject, or you think I've not covered some part of Dapper, or if maybe I just
missed something, just drop me a note. I'll be happy to see what I can do.

And of course, if in future there will be new feature added to Dapper I'll write
about them.

Until then, have fun!