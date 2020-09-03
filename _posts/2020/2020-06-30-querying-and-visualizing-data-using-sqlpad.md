---
layout: post
title: "Querying and visualizing data using SQLPad"
subtitle: "A free tool to easily query and explore data in Azure SQL"
tags: sql-server azure-sql azure developers query visualization tool
published: true
canonical-url: "https://devblogs.microsoft.com/azure-sql/querying-and-visualizing-data-using-sqlpad/"
---

SQLPad is an amazing free, open source, tool to run SQL Queries against a broad spectrum of popular databases, without the need to install and run something on-premises. It’s lightweight, simple and just perfect if you need a no-frills tool to query and visualize data, to do some data exploration.

![](/public/images/2020-06-30/image-01.png)

As a developer, especially if you are not that much into data, you probably don’t always need all the features that full-fledged product like SQL Server Management Studio or other on-premises tool provides. You need something lean and simple. But not too simple. And in addition to that, you may want to use a cloud tool to query data that lives in the cloud. I’ve found a very nice community driven and open source tool that hits this sweet spot, at this tool is SQLPad.

This is of course not a substitute for SQL Server Management Studio or Azure Data Studio, but I find it very handy when I don’t need all the complexity of those tools. Also, when I’m on low-bandwidth connections (yeah, not everywhere you have the luxury to have a broadband) this is really a super useful tool.

Completely written in Node, it uses Sequelize to abstract from any vendor-specific requirements so that you can query anything from Azure SQL to Vertica, going through Postgres, MySQL, MariaDB and so on. Just perfect if you are working on a modern solution where different services may use different database and you need one place to run your queries.

Up until today, SQLPad couldn’t easily run on Azure, as it was using SQLite to store all its metadata, and SQLite doesn’t really work well, yet, with Azure Storage File Share. Since I didn’t see the point of use SQLite when Azure SQL could be used, since probably you are already using it for some project, I helped the maintainer of the project and added support to Azure SQL (and, more in general, to other databases).

I’m pretty happy, as I helped both the Sequelize project and the SQLPad project…and give than when I started I really had almost zero knowledge of Node…well I’m pretty happy about myself 🙂 I have learned something, and at the same time I helped a community project. That’s a win-win! But enough with self-gratification now, the most important result is that now you can run SQLPad using Azure Container Instances.

## Spinning Up SQLPad

All you need to do to run SQLPad is making sure you have an Azure SQL database ready to be used to store metadata, and then you just need to create a new Azure Container:

```bash
az container create -g <resource-group> -n <container-name> \
	--image sqlpad/sqlpad \
	--ports 3000 \
	--ip-address "Public" \
	--secure-environment-variables SQLPAD_BACKEND_DB_URI='mssql://<user>:<password>@<server>.database.windows.net/<database>?options={"encrypt":true}' \
	--cpu 2 \
	--memory 4
```

and in just a minute or less, thanks to the SQLPAD_BACKEND_DB_URI environment variable and the Sequelize support to URI connection string, you’ll have SQLPad up and running.

You can get the IP Address of the running container via the Azure Portal or using the following command:

```bash
az container show -g <resource-group> -n <container-name> --query "ipAddress.ip" -o tsv
```

Then you can connect to SQLPad at `http://<ip-address>:`3000`

## Accessing SQLPad the first time

The first time you’ll try to access SQL you need to sign-up, and this first account will also be set as the administrative account.

![](/public/images/2020-06-30/image-02.png)

There are several options for authenticating users, all described in the guide. After you have defined the administrative account, you can login with the newly created account and then start to create a connection.

## Querying data using SQLPad

After you logged you, you need to create a connection or use an existing one.

![](/public/images/2020-06-30/image-03.png)

Once the connection is selected you can start querying. Once you are done, if you don’t want to spend money while you are not using SQLPad, you can destroy the container using the following command:

```bash
az container delete -g <resource-group> -n <container-name> -y
```

We you'll need to use SQLPad again, you can run the command you used to deploy SQLPad the first time. Thanks to Sequelize and the defined migrations, database metadata will not be created, so you will find all the defined connections, users and query ready for you to be operative in no time.