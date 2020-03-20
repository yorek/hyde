---
layout: post
title: "Dapper .NET: Multiple Executions"
subtitle: "A nice feature that is NOT as cool as it seems"
tags: dapper micro-orm azure-sql sql-server csharp
published: true
---
In Dapper .NET, Multiple execution is a convenient (or maybe not? make sure you read the article until the end!) way to execute the same query multiple times with different parameters values.

Let’s say for example that you have a shopping cart full of items and you want to save it into your database. The following code snipped shows how you can do it using the multiple execution feature:

![](/public/images/2017-12-04/image-01.png)

As you can see you just have to pass an `IEnumerable`of parameters, be it done using `DynamicParameters` or an array of anonymous objects, and you’re done. This is what gets executed on the database server (here I’m using the [SQL Profiler](https://docs.microsoft.com/en-us/sql/tools/sql-server-profiler/sql-server-profiler) to see what gets executed on SQL Server):

![](/public/images/2017-12-04/image-02.png)

Each statement looks like the following:

![](/public/images/2017-12-04/image-03.png)

While this could seem pretty cool, since it solves the problem of sending an array of values to the database, instead of passing it one-by-one manually, the reality is that it is not. In fact, if your database supports more clever ways of passing sets of values, you should use one of those instead of this feature.

Samples of Multiple Execution usage can be found here:

[yorek/dapper-samples](https://github.com/yorek/dapper-samples)

## Avoid using it, if you can

With SQL Server you have better options to send an array of values to the database. Using Table-Valued-Parameters or JSON, or even XML if you are a good-old fashioned lover boy, is just the way to go if you have a collection of up to a thousand — as general rule — values that needs to be sent to the database. And in case you have more, you should go for the BULK INSERT command instead.

What the multiple execution does behind the scenes, in fact, is just an iteration over the provided values. Yes, just a simple loop. And it couldn’t be different in order to make it work with any supported database connection.

But this approach sends every command as a single, stand-alone transaction, which may cause inconsistencies in case of error while executing one or more statements. The workaround here is to use an [IDBTransaction](https://docs.microsoft.com/en-us/dotnet/api/system.data.idbtransaction?view=netframework-4.7.1) object to create an explicit transaction that covers all the executions. Performances and scalability will be worse than executing just one command passing an array of objects (due to network latency and thus longer transactions), but at least consistency will be guaranteed.

But since Dapper supports [SQL Server’s Table-Valued-Parameters](https://docs.microsoft.com/en-us/sql/relational-databases/tables/use-table-valued-parameters-database-engine) and also [JSON](https://docs.microsoft.com/en-us/sql/relational-databases/json/json-data-sql-server) my recommendation is to use one of those if you need to pass an array of values to a parameter. I’ll discuss about them in future articles, so stay tuned.

Now, what about if you have to pass an array of, say, 10.000 values or more? The right choice, here, is to use a bulk load, and more specifically with SQL Server the [BULK INSERT](https://docs.microsoft.com/en-us/sql/t-sql/statements/bulk-insert-transact-sql) command, which is, unfortunately, not supported by Dapper natively. The workaround is to just use the regular [SqlBulkCopy](https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlbulkcopy)class here and you’re done.

## Conclusions

This feature could be nice if your database doesn’t offer anything specific way to handle array of data as parameter values. Keep in mind that all values are sent as separate commands, and if you want to group them all in a single transaction you have to do it explicitly. As a general rule, if the database you’re using has specific support to deal with arrays, use that feature instead of the Multiple Execution option.

## What’s Next?

Next topic will be on handling “Multiple Resultsets”