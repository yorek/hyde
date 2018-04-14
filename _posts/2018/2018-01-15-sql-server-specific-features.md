---
layout: post
title: "SQL Server Specific Features"
subtitle: "Table-Valued parameters, Spatial and HiearchyID data types are all supported"
tag: dapper .net micro-orm orm column-mapping sql-server
---

## SQL Server Specific Features

### Table-Valued parameters, Spatial and HiearchyID data types are all supported

If you are a SQL Server or Azure SQL user, you’ll be happy to learn that Dapper support some very specific (and very nice) SQL Server Features:

* Table-Valued Parameters
* Spatial Data Types
* HiearchyID Data Type

support to these features is really simple and straightforward as you’ll see.

## Table-Valued Parameters

TVP are surely one of the nicest feature of SQL Server that aims to solve the problem of passing an entire table as input parameter for a Stored Procedure or a Function. They offer great performance and flexibility. If you’re not using them, take a look here:

[Table-Valued Parameters](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql/table-valued-parameters)

Using them with Dapper is embarrassingly simple. Once you have created an `IEnumerable` or a `DataTable` that is compatible with the defined TVP you can use the `AsTableValuedParameter` extension to, guess what?, pass it to your Stored Procedure or Function that expect a TVP as input.

So, say you have defined the following TVP on SQL Server:

![](/public/images/2018-01-15/image-01.png)

in your .NET application all you have to do is to create a DataTable that is compatible with the table type schema and fill it with data:

![](/public/images/2018-01-15/image-02.png)

and once this is done you can just pass it as a parameter using the `AsTableValuedParameter` extension method to inform Dapper that such DataTable must be mapped to the TVP:

![](/public/images/2018-01-15/image-03.png)

This just work smoothly in .NET Framework. **In .NET Core, the mentioned extension method has not been added yet**, as of Dapper version 1.50.4…so the way to solve the problem is to _extend_ Dapper and create a custom query parameter. I’ve learned this technique by studying Dapper code itself. No guarantee it will work in future, but it works now, and that’s enough. I’m sure that in future version Dapper will support the nice extension method also in .NET Core natively.

Here’s a sample code for the custom parameter:

![](/public/images/2018-01-15/image-04.png)

Once this class is in place, the query invocation will just need a small change:

![](/public/images/2018-01-15/image-05.png)

Done, the TVP is working as expected also in .NET Core, as the SQL Server Profiler confirms:

![](/public/images/2018-01-15/image-06.png)

## Spatial Data Types

Bad news first. The [SqlGeometry](https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.types.sqlgeometry.aspx?f=255&MSPPError=-2147217396) and [SqlGeography](https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.types.sqlgeography.aspx) data types are not yet supported by .NET Core. So, even via Dapper, you can use them only in the “legacy” .NET version, also known as .NET Framework.

Beside this, the good news is that Dapper is completely transparent to the fact that this is not a native type (which is exactly what we could expect from a micro ORM). After having added the package `Microsoft.SqlServer.Types` via [NuGet](https://www.nuget.org/packages/Microsoft.SqlServer.Types), all is needed to do is to use the Spatial Data Types:

![](/public/images/2018-01-15/image-07.png)

## HiearchyID Data Type

Same as before, [HierachyID](https://docs.microsoft.com/en-us/sql/t-sql/data-types/hierarchyid-data-type-method-reference) is supported only in .NET Framework and not in .NET Core, and it is provided by the `Microsoft.SqlServer.Types` package.

Same as before, all you need to do is to add the NuGet package and you’re good to go. Using it is straightforward, since nothing special needs to be done in order to use it as a parameter or as the result of a query:

![](/public/images/2018-01-15/image-08.png)

## A note on `Microsoft.SqlServer.Types`

Reality is that you may have some troubles having the types provided by `Microsoft.SqlServer.Types` to work correctly, mainly because .NET will try to load the `Microsoft.SqlServer.Types` version `10.0.0.0` anyway, even if you have installed the latest version, the `14.0.0.0`, on your machine. The latest version can be obtained via SQL Server Feature Pack:

[Microsoft® SQL Server® 2016 Feature Pack](https://www.microsoft.com/en-us/download/details.aspx?id=52676)

and then download the “SQLSysClrTypes.msi” file:

![](/public/images/2018-01-15/image-09.png)

Once this has been installed, you just have to make sure your application correctly look for it, using the Assembly Binding feature. This means that you have to put the following code in your app.config file:

![](/public/images/2018-01-15/image-10.png)

## Samples

As usual samples are available on GitHub:

[Dapper .NET Samples](https://yorek.github.io/dapper-samples/)

I’ve changed the samples to support both .NET Core 2.0 and .NET Framework 4.5.2, so that you can also play with the features not yet supported by .NET Core 2.0. Look in the _readme_ to see how to execute the samples against one or another framework.

## Conclusion

Support to native SQL Server feature is native and works just right out of the box. TVP support is a great thing, since performance wise [TVP can offer great benefits](https://blogs.msdn.microsoft.com/sqlcat/2013/09/23/maximizing-throughput-with-tvp/). In the .NET Core bits of Dapper is not yet there, but it was easy to extend Dapper to support it.

## What’s Next

Extending Dapper is the topic of the next articles: how to customize Dapper behavior to make sure it can handle all possible scenarios, even the most exotic ones.
