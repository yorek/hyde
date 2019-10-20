---
layout: post
title: "Apache Zeppelin, SQL Server, SQL Azure and SQL Azure DW"
subtitle: "Apache Zeppelin what?"
tags: apache zeppelin sql-server azure-sql azure-dw
published: true
---
After a little pause, due to my [recent changes](/@mauridb/lets-start-again-86512919f40f), I’ve finally been able to work on my SQL Server Interpreter for Apache Zeppelin again. For those who never heard of it before, Apache Zeppelin is

> A web-based notebook that enables interactive data analytics. You can make beautiful data-driven, interactive and collaborative documents with SQL, Scala and more

Just like the other, (more?) famous web-based notebook “[Jupyter](http://jupyter.org/)”, is a must for everyone in the Data Science space. What I like of Apache Zeppelin is that it’s very simple and doesn’t require any developer skill or knowledge to be used. This it what make it different from Jupyter. To use Jupyter you need to know Python or R at least, which it make it *perfect* for Data Scientists and (Data-Wise) Developers…but what if you’re “just” a Data Guy or a DBA?

To play with data you would surely love too to have a nice place where write a query and easily turn it into a chart. And maybe make the query automatically refresh every *x*seconds. Uh yeah, and also add the capability to make some part of the query parametric, so that I can just select values from a drop-down list and change the value to a new one. And — wait, wait! — what if I could also add some markdown to give additional meaning to everything…and maybe then publish everything so that the end user can have a nice looking dashboard and all I did was just writing some simple queries?

Nice uh? Well, this is Apache Zeppelin exactly. Now, if you’re interested, you can learn more here:

[Zeppelin](https://zeppelin.apache.org/?source=post_page-----1706697bb54----------------------)

While this is very cool, the thing that’s not so cool is that it doesn’t offer native support to SQL Server, or SQL Azure or SQL Azure DW.

## Why you can’t just use the fantastic SQL Server Management Studio?

Yeah, right. Why? I actually do every day, I and I really love SSMS. But when you work with Azure, you start to look for a tool that supports Azure *natively,*and that it’s *cloud born*. In other word, I would like a web-based Management Studio with additional capabilities to, say, turns grid content into charts. Sounds familiar? And I would also love to be able to work on my SQL Azure instances where I am and without anything to be installed on premises, except for a Web Browser…so that I can close it in one office and reopen it in another one, without even having to think about firewall rules to update, files to save in a DropBox-like service and so on. I want to 100% cloud experience, with all its benefits (not to mention the ability to share with other people grids and charts).

And the users: they love dashboards. I love dashboard too! 

![](/public/images/2016-11-28/image-01.png)

In addition to everything just said, I find the lack of a web-based editor, exploration and visualization tool for SQL Azure and SQL Azure DW really limiting. Almost all databases (SQL or NoSQL) today have a web-based tool to easily do some data manipulation, exploration and visualization with native support to the local SQL dialect…and I just want it for SQL Server too.



I felt SQL Server was missing it.

So that’s why I decided to write a SQL Server Specific interpreter for Apache Zeppelin. Interpreters, in the Apache Zeppelin world, are the things that takes what you write, send it to the correct engine (SQL or anything else) and return the result in a format that Apache Zeppelin can handle.

## Got it. But why don’t just use the JDBC Interpreter?

Well, it works right. But it’s by far too generic. (Even though the existing version already allows you to configure specific options for specific drivers. So it’s generic but with a twist.) I understand that not everyone may need a specific JDBC interpreter and in such situations the generic JDBC is perfect. But to get the maximum out of your engine, you need something specific for it. And that’s why I decided to write a specific interpreter for SQL Server and the kind.

## Right, let’s try it!

Good. First things first: everything is done with Java here. So the best way to start, if you’re not into Java is to use a Docker container with the pre-compiled code. It will work just transparently and you’ll be able to connect to any SQL Server or SQL Azure instance.

Download and install [Docker](https://www.docker.com/). After that you can just *pull* the *zeppelin-sqlserver*image, following the instructions here:

[Apache Zeppelin for SQL Server Docker Image](https://hub.docker.com/r/yorek/zeppelin-sqlserver/)

And you’re ready to go, you have Apache Zeppelin running on your machine. Now you’re ready to start using SQL Server with Apache Zeppelin, as you can read here:

[Using Apache Zeppelin](https://github.com/yorek/zeppelin#using-zeppelin)

## What’s next?

The idea is to do quite a few post in the next days on Apache Zeppelin and how it can be used, used with SQL Server, installed on Windows, installed on Linux and so on.

## What are the plans for future improvements?

Well, there’s a lot to do, but ultimately I would like to be able to query all Azure data sources (Data Lake, DocumentDB, HDInsight, Stream Analytics and so on) with Apache Zeppelin.

## Hey, but no release in sight?

On the contrary! The working version for Apache Zeppelin 0.6.2 is here! I’ll do a specific post with all details in the next days (I just wanted to set the scene before starting to talk about it on my new blog), but if you really cannot wait, the GitHub repository — with all explanations needed to build it — is here:

[yorek/zeppelin](https://github.com/yorek/zeppelin?source=post_page-----1706697bb54----------------------)

Enjoy!

## Wait, Wait! Never heard of Power BI?

Yes I know it very well. But it’s not a substitute for Apache Zeppelin, just like Tableu or Qlik aren’t a substitute for Toad. I use PowerBI *and* Apache Zeppelin (and Jupyter) very frequently together. (Though I wish Apache Zeppelin, Cloudera Hue and Jupiter could converge into just one tool one day)

