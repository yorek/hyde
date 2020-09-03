---
layout: post
title: "Practical Azure SQL Database for Modern Developers"
subtitle: "A book on Azure SQL for developers written by developers"
tags: azure-sql azure developers 
published: true
canonical-url: "https://devblogs.microsoft.com/azure-sql/practical-azure-sql-database-for-modern-developers/"
---

I'm super happy and excited to share with you all that a book I've been working on along with four other colleagues is now finished and will be available very soon in bookstores and eBooks format!

[![Practical Azure SQL Database for Modern Developers book](/public/images/2020-09-02/image-01.jpg)](https://www.apress.com/it/book/9781484263693)

The book is something I've wanted to write since long time ago, as I think SQL knowledge is of paramount importance for a modern full-stack or back-end developer. Data plays a central role in today's world, and the ability to manage and use it correctly is really a plus for anyone in the IT industry. 

![A developer with good SQL knowledge is like a superhero with superpowers](/public/images/2020-09-02/image-02.jpg)

**I wanted a book for developers, written by developers that would discuss and present Azure SQL from a developer perspective.** A book that could be enjoyed by developers who are not (yet!) passionate about data and database: it should have the correct mix of practical approach so that one could benefit from reading it right from day one, but also give enough information and references that, in case someone would like to know more, could find everything needed to start to dig deeper into database knowledge.

**As a developer, wondering why you should read this book?** Well, relational databases went through a *huge* evolution and revolution in the last decade, becoming truly post-relational entities. This book is great if you want to quickly get up to speed with all the goodness you may have missed and that can absolutely make a huge difference in terms of development, scalability, security and performance. 

I'm sure you're thinking I'm biased and a bit enthusiastic. Well, take a look a the table of contents, and the judge for yourself:

1. A database for the modern developer
1. Azure SQL Kickstart
1. Connecting and Querying Azure SQL
1. Developing with Azure SQL - Foundations
1. Developing with Azure SQL - Advanced
1. Practical Usage of Tables and Indexes
1. Scalability Consistency & Performances
1. Multi-Model Capabilities 
  - Columnstore, JSON, Graph, Key-Value, Geospatial
1. More Than Tables 
  - In-Memory Lock-Free Tables, Natively Compile Procedures
1. Monitoring and Debugging
1. DevOps with AzureSQL

I say that excitement is more than justified! **Also, beside SQL, you'll also find many samples and references to many different languages: .NET, Python, Java, Node and so on.** No matter which language and operating system you use, this book will be useful.

The book will be available in the next months, make sure to grab a copy as if you are working with Azure, I can promise it will change your developer life.

Yeah, that's a bold statement, I know. You can just trust me, and stop reading now or you can read the next section.

## A bit of history

I've been a developer (full-stack and back-end) for several years before joining Microsoft as a Software Engineer first and now as Program Manager. I just love coding: Assembler, C/C++, Visual Basic, Delphi, and now C#, Python and lately also Javascript/Typescript, are what I live and breathe every day. And of course SQL. SQL! As many developers I didn't like or care about SQL and data at the beginning. I have always been passionate about performances and optimizations. No wonder I started coding [demoscene](https://en.wikipedia.org/wiki/Demoscene) code, finding clever and super-optimized way to render [Julia and Mandelbrot fractals in real-time](https://github.com/yorek/memory-lane/blob/main/FMANIA/FM2.C), on a good old [486 DX2](https://en.wikipedia.org/wiki/Intel_80486) first and then [AMD K6](https://en.wikipedia.org/wiki/AMD_K6) processors. 

Then I started coding for a living and I still remember the weeks I spent trying to optimize code to make an application perform decently. It always worked amazingly, but with our biggest customer it was really showing embarrassing performances. It was a VB6 & VC++ application and the database used was Access at the very beginning then migrated to SQL Server 6.5 (and then SQL Server 2000). After several days looking at code, finding super clever and complex way to use the database the less possible, as it seemed that all performance issues came from there, I decided to finally start to take a closer look - a serious look - at it and figure out why it was not performing decently. 

I learned a great lesson. 

After taking some time to read couple of books on SQL Server I started to get a grasp on databases and I realized the many mistake we did in creating the database, but most importantly I realized how many features we were not using, basically trying to re-invent the wheel again and again. Indexes and transactions were the first thing I started using and with my great surprise they made the database perform so amazingly fast, that all the time I spent before, trying to optimize the application, was basically completely a waste. 

I realized that learning how to properly work with a database was as important as having learned how to do multiplications with bit-shifts when creating high-performing effects for demos. That was eye-opening for me.

From that moment on, I realized that learning well SQL and proper database modeling is important as learning C#, multithreading, parallel programming, OO modeling and other cool developer stuff.

"Well, it's just a story about 'reading the manual!'" you may be thinking, now. Well...no. It's more about the fact that a database is *part of the toolset* of a developer, and how fundamental is to realize this. Code and Data are equally important. Once realized that, then yes, one just needs to "read the manual". 

My hope is that this book will help as many developers as possible to realize this and take advantage of databases, Azure SQL in particular, as this will unlock to ability to become _even better_ developers. 

Enjoy!