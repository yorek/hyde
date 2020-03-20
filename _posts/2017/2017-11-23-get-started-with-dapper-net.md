---
layout: post
title: "Dapper .NET: Getting started"
subtitle: "Learning Dapper .NET basics with 10 samples"
tags: dapper micro-orm azure-sql sql-server csharp
published: true
---
Dapper is a micro ORM born in 2011. You can still find the original post online, [here](https://samsaffron.com/archive/2011/03/30/How+I+learned+to+stop+worrying+and+write+my+own+ORM).

It is one of the fastest and simplest around, yet it is very extensible and, above all, well adopted and used in very high-performance websites. More specifically has been developed and is maintained by the guys behind StackOverflow, so you can be sure it is battle-tested. Source code is on GitHub

[StackExchange/Dapper](https://github.com/StackExchange/Dapper)

and development is very active. All these reasons made it my micro ORM of choice.

## Setting up the environment

Since I use SQL Server for my daily work I’ll just use that database for all the examples. If you’re on a different platform than Windows, just use the SQL Server 2017 Docker image. Here you can find anything you need to know to get started with SQL Server and Docker.

[Get started with SQL Server 2017 on Docker](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker)

For the purpose of becoming familiar with other platforms, I’m writing this series of articles using all the three major platforms: macOS, Linux (Ubuntu) and Windows 10. This means that I’m also using [.NET Core](https://www.microsoft.com/net/download/windows) and [Visual Studio Code](https://code.visualstudio.com/).

## Installing Dapper

Dapper supports both .NET and .NET Core. To start with Dapper you just need to install the NuGet or dotnet package:

[Dapper](https://www.nuget.org/packages/Dapper)

## Let’s start querying!

As said in the subtitle, in this article I’ll focus on the basics of Dapper .NET, and all it takes to get familiar with it are just 10 samples I have created and posted on GitHub, here:

[yorek/dapper-samples](https://github.com/yorek/dapper-samples)

Dapper .NET extends the `IDBConnection` interface, adding four methods:

 - `Query`
 - `Execute`
 - `ExecuteScalar`
 - `ExecuteReader`

they are all defined in [SqlMapper.cs](https://github.com/StackExchange/Dapper/blob/master/Dapper/SqlMapper.cs) and, they all supporting async calls, via the specialized *`<MethodName>`* methods. The 10 samples I’ve created shows how the above methods can be used. Let’s take a look at them before playing with the sample code:

### Query

Executes a query and maps the result to a list of dynamic objects or, if specified, to a list of strongly typed objects:

```
public class User
{
  public int Id { get; set; }
  public string FirstName { get; set; }
  public string LastName { get; set; }
}

// conn is a SqlConnection
var queryResult = conn.Query<User>("SELECT [Id], [FirstName],[LastName] FROM dbo.[Users]");
```

If the target object has been specified (“User” in the above sample), mapping is done by matching the names of returned columns with object properties names.

Since the result is an `IEnumerable`, you can use `First()`, `FirstOrDefault()`*,*`Single()` or `SingleOrDefault()` if you need to, but you don’t really have to, since there are specialized implementations of the Query method that already do this for you:

 - `QueryFirst`
 - `QueryFirstOrDefault`
 - `QuerySingle`
 - `QuerySingleOrDefault`

Here’s a summary what you can expect to be returned by each method in case your query return no rows, one row or multiple rows:

![](/public/images/2017-11-23/image-01.png)

Of course, if you have asked Dapper to return a specific type, like the User in the sample code shown before, you will have the requested object returned instead of “Row”.

Generally speaking, you should prefer using the above methods instead of using the one with the same names on the `IEnumerable`. This is due to how Dapper works behind the scenes: by default the entire result set is read in memory and the returned as an `IEnumerable`. The idea behind this behavior is to keep the connection to the database open for the least amount of time possible, in order to favor concurrency at the database level. If you don’t like this behavior, keep in mind that it *can be*changed and we’ll discuss about that in future. Anyway, this means that if you only need one row or you’re expecting only one row, there is no point in loading everything in memory, and only then taking the first row or checking if you got exactly a single row, right? That’s why the methods provided by Dapper should be preferred. They will just take one row, without loading all the others in memory. It may seem a very small thing, but are those kind of details that make performance great instead of just good.

### Execute

This method executes a query that doesn’t return any resultset. Its return value contains that number of rows affected by the query. If the executed actually generates a resultset, that will be discarded.

```
int affectedRows = conn.Execute("UPDATE dbo.[Users] SET [FirstName] = 'John' WHERE [Id] = 3");
```

### ExecuteScalar

This methods executes a query that return a resultset made of exactly one row and one column. Just like the good old [IDBCommand.ExecuteScalar](https://docs.microsoft.com/en-us/dotnet/api/system.data.idbcommand.executescalar?view=netframework-4.7.1#System_Data_IDbCommand_ExecuteScalar).

```
conn.ExecuteScalar<string>("SELECT [FirstName] FROM dbo.[Users] WHERE [Id] = 1")
```

### ExecuteReader

I think that this method exists mainly for making easier to adopt Dapper in legacy codebases where instead of dealing with strongly typed lists you have to deal with a DataReader, and refactoring to use a typed list it is not possible. If that’s the case, then is the method for you. As the name suggest it just returns a [IDataReader](https://docs.microsoft.com/en-us/dotnet/api/system.data.idatareader?view=netframework-4.7.1).

```
var dataReader = conn.ExecuteReader("SELECT [Id], [FirstName], [LastName] FROM dbo.[Users]");
```

## Parameters

All the aforementioned methods supports parametric queries. Parameters are defined in queries using the “@” symbol and then there are two ways that can be used to assign values to defined parameters: using anonymous objects or the Dapper-specific `DynamicParameter` class.

### Parameters via Anonymous Objects

With this option all is needed is that anonymous object’s fields have the same name of the used parameters. You can use the “@” sign also in the field name if you want or you can omit it as long as, again, the name matches the parameter you want to assign the value to.

```
var queryResult = conn.Query<User>(“SELECT [Id], [FirstName], [LastName] FROM dbo.[Users] WHERE Id = @Id”, new { @Id = 1 });
```

This is very concise and clean, but it doesn’t allow to specify if a parameter is an input or output parameter, and the data type is inferred from the parameter type itself. Here’s what get executed on the database:

![](/public/images/2017-11-23/image-02.png)

So, while very convenient, this behavior could drive to [unpleasant implicit conversions](https://sqlperformance.com/2013/04/t-sql-queries/implicit-conversion-costs), especially with strings that are sent as `nvarchar(4000)`**by default. If you want have control on how strings are passed to the database, you have to use the [DBString](https://github.com/StackExchange/Dapper/blob/master/Dapper/DbString.cs) class:

![](/public/images/2017-11-23/image-03.png)

One nice feature that you have when using anonymous objects as parameters is the ability to pass an `IEnumerable`. This is useful in case you need to pass a list of values to be used in a IN construct: can just pass an `IEnumerable` as parameter value, and the values will be automatically expanded to a comma-separated list of values.

![](/public/images/2017-11-23/image-04.png)

### Parameters via DynamicParameter

By using the `DynamicParameters` object all options related to a parameter can be set.

```
DynamicParameters dp = new DynamicParameters();
dp.Add("FirstName", "Davide", DbType.String,   
   ParameterDirection.Input, 100);
dp.Add("LastName", "Mauri");

var queryResult = conn.Query<User>("SELECT [Id], [FirstName], [LastName] FROM dbo.[Users] WHERE FirstName = @FirstName AND LastName = @LastName", dp);
```

You have full control over how parameters are sent to the database, as you can see from what get executed:

![](/public/images/2017-11-23/image-05.png)

Dynamic Parameters are especially perfect for complex stored procedure, in case you need handle also a return value:

![](/public/images/2017-11-23/image-06.png)

## Stored Procedures

Of course execution of stored procedure is supported. Any of the mentioned methods allows the execution of a stored procedure. All it’s needed is to *omit* the `EXEC` command in the query and specify the `StoredProcedure` command type:

```
conn.Query<User>(
    "dbo.ProcedureBasic", 
    new { @email = "info@davidemauri.it" }, 
    commandType: CommandType.StoredProcedure
);
```

## That’s it

This all you need to get started with Dapper .NET. Working samples of all the aformentioned methods are available on GitHub:

[yorek/dapper-samples](https://github.com/yorek/dapper-samples)

## What’s Next?

Next topic will be about a Dapper feature called “Multiple Execution”

