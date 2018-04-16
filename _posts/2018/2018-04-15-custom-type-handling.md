---
layout: post
title: "Custom Type Handling"
subtitle: "Go beyond Dapper limits and map arbitrary complex class"
tags: dapper dotnet micro-orm orm custom-handling
---

To map - or better - deserialize data coming from your database into a complex custom object Dapper supports a feature named “Custom Handlers”.
As you already learned in previous posts, with simple object you don’t have to do anything special since Dapper automatically maps database columns to properties with the same name. If you only need to change this mapping logic you can do that using [Custom Mappers](/2018/02/12/custom-columns-mapping/). If you need to completely control how database data is mapped your object that you need a Custom Handler.

## Custom Handling

Let's say you have the following class model:

![](/public/images/2018-04-15/image-01.png)

and more specifically the User class looks likes this:

![](/public/images/2018-04-15/image-02.png)

but in your database you have user a rather different approach, storing the roles as a comma-separated values right into the `User` table. (I'm not saying this is the right approach, beware!)

![](/public/images/2018-04-15/image-03.png)

Well, in this situation the automatic mapping of Dapper.NET is pretty useless since it will try to map a string (the Roles column) to a `Roles` object and, of course, if you try to execute even a simple query that involves the Roles object, like:

```
SELECT Id, FirstName, LastName, Roles FROM dbo.Users WHERE Id = 1
```

it will result in an error:

```
Unhandled Exception: System.Data.DataException: Error parsing column 4 (Roles=Role1, Role2, Role3 - String) ---> System.InvalidCastException: Invalid cast from 'System.String' to 'Dapper.Samples.Advanced.CustomHandling+Roles'.
```

since there is no implict cast from a `String` to a `Roles` object. Same happens if you try to use `Roles` object as a parameter, for example in an update:

```
conn.Execute("UPDATE dbo.Users SET Roles = @roles WHERE Id = @userId", new { @userId = 1, @roles = roles });
```

the result error will be:

```
Unhandled Exception: System.NotSupportedException: The member  of type Dapper.Samples.Advanced.CustomHandling+Role cannot be used as a parameter value
```

These two errors are the way Dappers tells you that it doesn't know how to deal with your complex `Roles` class. How data stored in a table column can be used to deserialize the object? And how that object should be serialized into the database?

The way you can help Dapper figure out all of this is by creating an explicit mapping using the `SqlMapper.TypeHandler` base class. By creating an object that inherits from the mentioned class you have two methods to overload where you can define how data is handled when it needs to be passed to the database (`SetValue`), and how to handle it when the database gives a value back to you (`Parse`):

![](/public/images/2018-04-15/image-04.png)

The called methods provided by the `Roles` class, are also very simple: they just convert a comma-separated values from and to a list of `Role`:

![](/public/images/2018-04-15/image-05.png)

Once this is done, the new Type Handler needs to be registered with Dapper so that it knows it can be used. This is as easy as doing the followin:

```
SqlMapper.AddTypeHandler(new RolesTypeHandler());
```

And now that is set, every time somewhere in your code you'll try to use a `Roles` object as a query parameter or as the result of a query, Dapper will know how to deal with it, so that the followin code will now work perfectly:

![](/public/images/2018-04-15/image-06.png)

## Handling JSON

Being able to handle JSON is absolutely mandatory today. Dapper unfortunately doesn't provide any native support to JSON so if you have a class where a property is actually a JSON object, let's say a JSON array, you won't have any luck dealign with it natively. If you try to take a perfectly valid JSON array stored in your database, and put into a `JArray` object you'll get the error mentioned before:

```
Unhandled Exception: System.Data.DataException: Error parsing column 3 (Tags=["Developer","Data Guy"] - String) ---> System.InvalidCastException: Invalid cast from 'System.String' to 'Newtonsoft.Json.Linq.JArray'.
```

this happens because SQL Server returns JSON as a string...and since there is no implicit conversion between a `String` and `JArray` the above error is thrown.

Luckily we know how to fix the problem now. All is needed is a custom Type Handler to tell Dapper how to deal with JSON. Really simple, here you go:

![](/public/images/2018-04-15/image-07.png)

Once the Custom Type Handler is set, dealing with `JArray` is done once and for all, and we can make the `User` class a little bit more complex now, by adding support for user tags:

![](/public/images/2018-04-15/image-08.png)

Deserializing user data from database to such object will be now as easy as doing:

```
var u = conn.QuerySingle<User>("SELECT Id, FirstName, LastName, EmailAddress, Roles, Tags FROM dbo.UsersTagsView WHERE Id = 1");
```

Elegant, easy and clean, isn't it?

## Samples

The code mentioned above is included in the "Custom Handling" sample in the GitHub repository:

[Dapper .NET Samples](https://yorek.github.io/dapper-samples/)

## Conclusion

Being able to explicitly define how data is serialized and deserialized into the database fix almost all limitations that Dapper may have shown so far. And it opens up interesting scenario, where any object, even the most complex one, can be stored into a relational database in the preferred format (entirely normalized, partially normalized or completely denormalized). Pair this ability with the fact that modern relational database (like SQL Server or PostgreSQL for example) handle JSON natively and with great performances, and you can really do something amazing here.

## What's Next

With the acquired knowledge, some [*lateral thinking*](https://en.wikipedia.org/wiki/Lateral_thinking), and the JSON support in SQL Server (or your preferred relational database), it is now easy to make Dapper able to deal with 1:N relationships, even without using `JArray` objects. We'll discuss this extremely interesting topic in the next post. Stay tuned.
