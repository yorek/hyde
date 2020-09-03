---
layout: post
title: "Azure SQL & .bacpac the easy way"
subtitle: "A kickstart to import/export database in Azure SQL"
tags: azure-sql azure developers bacpac import export backup restore
published: true
canonical-url: "https://devblogs.microsoft.com/azure-sql/azure-sql-bacpac-the-easy-way/"
---

Restoring a sample database is always useful, not matter if you are an experienced developer or a new one. It will help you to have comfortable playground where you can do all the test you need to improve your skills without the need to spend time creating new data and models from scratch, so that you can focus on learning. Also, usually samples you can find around the web use [well-known sample databases](https://docs.microsoft.com/en-us/sql/samples/sql-samples-where-are), so having it available quickly always comes handy. Long story short, restoring a database in Azure SQL is very simple, but if that's a new thing for you, you may benefit from some script I prepared so that you can skip the trial-and-error phase and just go directly to the coding phase:

[Restore Database in Azure SQL](https://github.com/yorek/azure-sql-db-samples/tree/master/samples/01-restore-database)

That's all you need to know to get started with Azure SQL sample databases. But if - and you should - you want to learn a bit more around backup and restore in Azure SQL, read on.

## Automatic Backups

Azure SQL automatically takes care of backup for you. That's a great feature: as a developer I know I can rely on this native support to make sure I always have the ability to restore my database in case sometime goes wrong, but I don't have the burden of managing this extremely important but really-not-a-dev-thing operation. If you are a full-stack developer or a back-end developer that also needs to take care of data, I'm sure you'll love this ability as basically it means you get all the benefits with no drawbacks. Hard to ask for more!

In case you want to get a bit deeper into how automatic backups are done, there are a couple of very interesting videos

- [Azure SQL - Automated Backups (Part 1)](https://www.youtube.com/watch?v=m45GCf50KD0)
- [Azure SQL - Automated Backups (Part 2)](https://www.youtube.com/watch?v=Vk2LEMtCbmU)

## .BacPacs?

Native automatic backup and restore is great, but on Azure SQL this also means that you cannot use it to import and export data from or to a non Azure SQL database. For example you cannot take a SQL Server backup and restore it to Azure SQL or the other way round. (You *can* restore a SQL Server backup on [Azure SQL Managed Instance](https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview), which is a "special" edition of Azure SQL that specifically aim to simplify lift-and-shift migrations)

So what if you need to export the entire database from Azure SQL to share it with a SQL Server running on premises or on a VM or with another Azure SQL? We have the Import/Export feature for this, that allows you to package your database, schema and data into a _.bacpac_ file.

## Import/Export

Creating a .bacpac (Export) or "restoring" a database from a .bacpac (Import) can be easily done from the Azure Portal, but many times you will probably need to do that using a script, for example to include the database into your CI/CD pipeline.
To help everyone, from new developers to experienced ones, as said at the very beginning of this post, I have created a set of sample scripts to show how to import a .bacpac using Powershell commands, AZ CLI with Bash or the SqlPackage tool (that works on any platform):

[Restore Database in Azure SQL](https://github.com/yorek/azure-sql-db-samples/tree/master/samples/01-restore-database)

## Conclusion

Now that you know how to backup/restore or import/export Azure SQL databases, you can try to use sample database to create some cool stuff with Azure SQL, for example [10K RPS REST API with Azure SQL, Dapper and JSON](./2020/02/24/10k-request-per-second-rest-api-with-azure-sql-dapper-and-json/). And stay tuned as more cool stuff will come this way very soon!
