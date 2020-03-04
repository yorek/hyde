---
layout: post
title: "10K Request per Second: REST API with Azure SQL, Dapper and JSON"
subtitle: "Create and deploy scalable REST API in just a few lines of code"
tags: sql-server azure-sql azure developers rest dotnet netcore json dapper web-api
published: true
---
In the previous article I described how easy is to create a [REST API with Python and Azure SQL](https://dev.to/yorek/building-rest-api-with-python-flask-and-azure-sql-18p4). But what about .NET? Would that be as easy as well? Absolutely yes: the native support to JSON offered by Azure SQL will also help a lot again. In addition to that, the Micro-ORM Dapper will make the interaction with database a breeze, and the new `System.Text.Json` will take care of manipulating that developer-friendly format. Sounds too good and easy to be true? Well, let’s prove it!

I started creating a WebAPI project using .NET CLI (I’m using .NET Core 3):

```
dotnet new webapi
```

and then I added the following packages

 - Dapper
 - Microsoft.Data.SqlClient
 - System.Text.Json

via

```
dotnet add package
```

to add the libraries mentioned before.

Dapper is an amazing MicroORM, that removes all the plumbing code needed to connect and query a database, so that you can focus more one the really important code. It is battle tested, as it is used by StackOverflow itself, and very recommended. If you want to have a kickstart, there is a 10 post tutorial here: [Dapper.NET @ Medium](https://medium.com/dapper-net), along with full source code for all described features. From a database perspective I’m using almost the same code I used to build the same sample with Python, leveraging as much as possible the native support to JSON the Azure SQL provides:

```
CREATE OR ALTER PROCEDURE web.get_customer
@Id
 INT
AS
SET NOCOUNT ON;
SELECT 
 [CustomerID], 
 [CustomerName], 
 [PhoneNumber], 
 [FaxNumber], 
 [WebsiteURL],
 [DeliveryAddressLine1] AS ‘Delivery.AddressLine1’,
 [DeliveryAddressLine2] AS ‘Delivery.AddressLine2’,
 [DeliveryPostalCode] AS ‘Delivery.PostalCode’ 
FROM 
 [Sales].[Customers] 
WHERE 
 [CustomerID] = @Id
FOR JSON PATH
GO
```

Thanks to the FOR JSON PATH clause, the result will be like the following:

```
[{
 "CustomerID": 123,
 "CustomerName": "Tailspin Toys (Roe Park, NY)",
 "PhoneNumber": "(212) 555–0100",
 "FaxNumber": "(212) 555–0101",
 "WebsiteURL": "
http://www.tailspintoys.com\/RoePark
",
 "Delivery": {
  "AddressLine1": "Shop 219",
  "AddressLine2": "528 Persson Road",
  "PostalCode": "90775"
 }
}]
```

Since the result is a JSON string, all it’s needed to turn it into an object is to deserialize it. In the sample on GitHub I decided to keep the JSON as JSON as I want to take advantage of its flexibility as much as possible, but that’s of course up to you.

Using Dapper you literally need just two lines of code:

```
var qr = await conn.ExecuteScalarAsync<string>(
 sql: procedure, 
 param: parameters, 
 commandType: CommandType.StoredProcedure
);
```

And you’re done. In the result variable you’ll have the JSON ready to be used. If you are creating a REST API, you can just return it to the client and…well, nothing else: done!

As usual the full source code is available on GitHub for you to play with:

[Azure-Samples/azure-sql-db-dotnet-rest-api](https://github.com/Azure-Samples/azure-sql-db-dotnet-rest-api)

To make the sample easily reusable, I wrapped the logic that execute the request to the database into the `ControllerQuery` base class, so it will be very easy to derive from there to create more specialized controller classes.

![](/public/images/2020-02-24/image-01.png)

On the database side, I created a convention for stored procedure naming so that code can automatically call the correct procedure for the correct verb and controller:

```
web.<verb>_<controller> [@id], [@payload]
```

For example, the `Get` method for the `CustomersController` will call the stored procedure `web.get_customers` behind the scenes, and is something like:

```
[HttpGet]
public async Task<JsonElement> Get()
{
  return await this.Query(“get”, this.GetType());
}
```

`id` and `payload` are two optional parameters that can be used to target a specific row via its own id and the payload is the JSON document that will be passed to the database for [further manipulation](https://github.com/yorek/azure-sql-db-samples/tree/master/samples/03-json-support).

Honestly, that’s amazing. Clean code, very lean, maintainable, flexible and fast. Fast? Yeah, what about performances? There will be a dedicated post on this subject, but let’s just say that with this configuration:

 - Azure SQL Hyperscale HS_Gen5_2
 - Web App Linux DotNet Core 3.1, P1V1, 1 node

I was able to execute **1100** Requests Per Seconds with a median response time of 20msec. If you can accept a bit higher latency, you can also reach **1500 RPS** but the median response time becomes 40msec and the 95 percentile is set at 95msec. Database usage never goes above 20% in such cases…and in fact the bottleneck is the Web App (better, the Web App Plan) and more specifically the CPU. Time to scale up or out the Web App Plan.

By scaling up and out a bit, I was able to reach almost **10.000** request per second with just an HS_Gen5_4. Quite impressive.

![](/public/images/2020-02-24/image-02.png)

If you’re wondering what solution I used to create load test, you can find all details, along with deployable code, here: [Running Locust On Azure](/@mauridb/running-locust-on-azure-516eb2487d18).

Now, the solution could seem complete already…but it really is? Not really, when working with the cloud, we *always* need to take think about resiliency.

Luckily for us, the .NET SqlClient driver already does quite a good job for us as it automatically handles [Idle Connection Resiliency](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-connectivity-issues#net-sqlconnection-parameters-for-connection-retry).

For now, it’s more than enough. I’ll discuss Connection Resiliency in detail in a future post, as it is a topic that deserves an article on its own.

In the meantime, have fun, with Azure SQL, .NET, Python or any language you want to use :)
