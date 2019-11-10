---
layout: post
title: "Creating your first Dashboard with Apache Zeppelin and SQL Server/Azure SQL"
subtitle: "It's time to create a dashboard"
tags: apache zeppelin sql-server azure-sql azure-dw
published: true
---
Now that Apache Zeppelin has been downloaded and configured, it’s time to create a dashboard. It will be very easy: all you have to do is figure out which data you want to show, write the corresponding T-SQL query and then add some charts and information to make it perfect.

To create the first Apache Zeppelin dashboard, let’s use the new Wide World Imports sample database from Microsoft:

[Microsoft/sql-server-samples](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0?source=post_page-----3db80ca94090----------------------)

Take the “Standard” version so that you can use it also on a non-premium Azure SQL instance, if you want to try it on Azure.

Once you have restored the *WideWorldImportersStandard*database, run Apache Zeppelin 0.6.2 for SQL Server docker container:

```
docker run --name zeppelin -p 8080:8080 -v /zeppelin-sqlserver/notebook -v /zeppelin-sqlserver/conf -d yorek/zeppelin-sqlserver:v0.6.2
```

make sure you have configured an interpreter (call it “Azure” for example) with the connection information to point to *WideWorldImportersStandard*and than create a new note:

![](/public/images/2017-01-09/image-01.png)

And now it’s just a matter of writing the queries and turning the result into charts. As usual I’ve recorded a quick video (it’s just six-something minutes) to easily show how you can do that. (And I’ve also started from configuring the interpreter so that you can also review that part). Enjoy:

[My First Apache Zeppelin Dashboard with SQL Server](https://vimeo.com/198582184)

In the video I also show how the *markdown* interpreter can be used to add information to the dashboard.

The sample dashboard, that also includes the queries, can be downloaded here:

[My First Dashboard.json](https://1drv.ms/u/s!AiGvhxQ5oX43gbIKDFxY8cVp7BpHzg?source=post_page-----3db80ca94090----------------------)

If you prefer to download only the queries and then DIY, here’s a SQL file with all the used queries:

[My First Dashboard.sql](https://1drv.ms/u/s!AiGvhxQ5oX43gbIMn6VWfbyhkxYpLg?source=post_page-----3db80ca94090----------------------)

I really recommend you to start using Apache Zeppelin if you haven’t done it yet. It’s incredibly useful even for DBAs just to monitor SQL Server status. I’ll talk about this in a forthcoming post. Stay tuned!

