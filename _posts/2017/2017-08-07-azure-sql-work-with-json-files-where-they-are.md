---
layout: post
title: "Azure SQL: Work with JSON files where they are"
subtitle: "Access and manipulate JSON files with Azure SQL without moving them"
tags: sql-server json azure-sql
---

Dealing with CSV or JSON data today is more and more common. I do it on
daily basis, since the [our
application](http://www.sensoriafitness.com/run) send data to our
microservice gateway backend is in a (compressed) JSON format.

Sometimes, especially when debugging or developing a new feature, I need
to access that JSON data, before is sent to any further microservices
for processing or, after that, being stored in the database.

So far I usually used [CloudBerry
Explorer](https://www.cloudberrylab.com/explorer/microsoft-azure.aspx)
to locate and download the JSON I was interested into and that a tool
like [Notepad++](https://notepad-plus-plus.org/) with
[JSON-Viewer](https://github.com/kapilratnani/JSON-Viewer) plugin or
[Visual Studio Code](https://code.visualstudio.com/docs/languages/json)
to load and analyze the content.

Being Azure SQL or main database, I spend a lot of time working with
T-SQL, so I would really love to be able to query JSON directly from
T-SQL, without even have the need to download the file from the Azure
Blob Stored where it is stored. This will make my work more efficient
and easier.

I would love to access JSON where it is, just like Hadoop or Azure Data
Lake allows you to do

Well, you can. I just find out that with the latest additions (added
since SQL Server 2017 CTP 1.1 and already available on Azure SQL v
12.0.2000.8) it is incredibly easy.

First of all the [Shared Access Signature](https://docs.microsoft.com/en-us/azure/storage/storage-dotnet-shared-access-signature-part-1)
needs to be created to allow Azure SQL to access the Azure Blob Store
where you have your JSON files. This can be done using the Azure Portal,
from the Azure Storage Blade

![](/public/images/2017-08-07/image-01.png)

SAS Signature Creation Window

or you can also do it via the Azure CLI 2.0 as described here:

[Azure CLI 2.0: Generate SAS Token for Blob in Azure Storage](https://buildazure.com/2017/05/23/azure-cli-2-0-generate-sas-token-for-blob-in-azure-storage/)

Once you have the signature a [Database Scoped Credential](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-database-scoped-credential-transact-sql)
that points to the created Shared Access Signature needs to be created
too:

![](/public/images/2017-08-07/image-02.png)

If you haven’t done it before you will be warned that you need to create
a [Database Master Key](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-master-key-transact-sql)
before being able to run the above command.

![](/public/images/2017-08-07/image-03.png)

After that credentials are created, it’s time to point to the Azure Blob
Account where your JSON files are stored by creating a *External Data Source*:

![](/public/images/2017-08-07/image-04.png)

Once this is done, you can just start to play with JSON files using the
[OPENROWSET](https://docs.microsoft.com/en-us/sql/t-sql/functions/openrowset-transact-sql)along
with
[OPENJSON](https://docs.microsoft.com/en-us/sql/t-sql/functions/openjson-transact-sql):

![](/public/images/2017-08-07/image-05.png)

and *voilà*, JSON content are here at your fingertips. For example, I
can access to all activity data contained in our “running session” json:

![](/public/images/2017-08-07/image-06.png)

This is just amazing: now my work is much simpler, especially when I’m
traveling and, maybe, I don’t have a good internet access. I can process
and work on my JSON file without even have them leaving the cloud.

## What about CSV?

If you have a CSV file the technique is very similar, and it is already
documented in the official Microsoft documentation:

[Examples of Bulk Access to Data in Azure Blob Storage](https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-access-to-data-in-azure-blob-storage)

## What about on-premises ?

The same approach is doable also via SQL Server 2017 ([now in CTP 2.1](https://blogs.technet.microsoft.com/dataplatforminsider/2017/05/17/sql-server-2017-ctp-2-1-now-available/)).
You can also access file not stored in the cloud, but on your
on-premises storage. In such case, of course, you don’t specify the
*Shared Access Signature* as an authentication methods, since SQL Server
will just rely on Windows Authentication. Here Jovan showed a sample
usage:

- [Importing JSON files into SQL Server using OPENROWSET (BULK)](https://blogs.msdn.microsoft.com/sqlserverstorageengine/2015/10/07/bulk-importing-json-files-into-sql-server/)
- [Parsing 4GB JSON with SQL Server](https://blogs.msdn.microsoft.com/sqlserverstorageengine/2017/02/14/parsing-4gb-json-with-sql-server/)

## Is the code available ?

Sure, there is a Gist for that:

[https://gist.github.com/yorek/59074a4c4176191687d6a17dabb426ed](https://gist.github.com/yorek/59074a4c4176191687d6a17dabb426ed)
