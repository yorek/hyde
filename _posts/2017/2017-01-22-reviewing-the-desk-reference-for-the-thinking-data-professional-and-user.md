---
layout: post
title: "Reviewing the “Desk Reference For The Thinking Data Professional And User”"
subtitle: ""
tags: book review
published: false
---
I’ve just finished reading the latest work of [Fabian Pascal](https://en.wikipedia.org/wiki/Fabian_Pascal), titled

**THE DBDEBUNK GUIDE TO MISCONCEPTIONS ABOUT DATA FUNDAMENTALS — A DESK REFERENCE FOR THE THINKING DATA PROFESSIONAL AND USER**

which is a collection of updated selected posts from his [website](http://www.dbdebunk.com/), where misconceptions about the Relational Data Model, its purpose, usage and purported limitations are debunked.

I know Fabian personally and I really love his books: his ability to clearly explain the importance and the details of the Relational Data Model is really amazing and eyes-opening. His latest work is a book that everyone, let me say it again — everyone — who is in the IT field and for one reason or another need to deal with data, should read. No matter if using the Relational Data Model or not, my strong recommendation is to read this book.

Just keep in mind that is not going to be an easy read, I tell you. Fabian is very critical of all current major (read SQL Server, Oracle, DB2) Relational Data Model implementations. He even claims they are very far from Codd’s Relational Data Model, and he is right about that. But business is business and we don’t just live in a perfect world. So, don’t be surprised, if every here and then you’ll find sentence that reminds you how the current implementation of the relational model is poor and flawed, and how there is a lack of education about it.

*Education* is the key. Understanding what’s wrong with the current implementations helps to know what we can expect DBMS products to do and what we must program applications to do, which means that then we know when it will be worth to spend time writing code and when it’s better to just go and rely on the features already available in current SQL DBMS implementations.

Such knowledge is very important. Let me show you why: if you know how the [relational division](http://www.slideshare.net/davidemauri/schema-less-table-dynamic-schema-44295422/27?src=clipshare) should work and why and where it should be used, the fact that it is not directly implemented in any of the current existing product it becomes just a minor problem, not a blocking one. Even better, just by the fact that you know it exists, it will help you to avoid to spend tons of time solving a problem already solved and well known, but just not implemented for you. You just have to implement it. And the solution is just there. It is a huge difference.

So just go beyond critics when you find one and you’ll find gems truly worth reading. If you ever had the idea that the topics like

are obscure, utterly complex and not useful, or if you think that the buzzword of the last years — “unstructured data” — has real meaning, then his book is for you.

In the book, you’ll find clear answers to such topics with additional references where you can even get more details on it. Maybe at some point you’ll even have the desire to just start to study the set theory and logic behind the Relational Data Model, which is totally amazing. It helps to understand much better the whole idea and concept of database, and figure out whether, why and when we need to depart from the current SQL implementations (that is, SQL Server, Oracle, Postgres, MySQL and the like) to move towards purely non-relational systems (NoSQL, XML, etc) or not. Such acquired knowledge will help you to understand if you’re making an architectural decision based on a wrong idea you have about databases, or if you’re really hitting a limit and, thus, it make sense to go into something more exotic and new.

The book will help you to understand, that, as developer, DBA or BI guy, you need to learn theory a bit so that you can do a much better job. A better job not only means that your manager will praise you more frequently, but that you can just have the peace of mind that your architecture is based on solid foundations (mathematics and logic foundations, what is more solid than that?) and so you can be sure you will to get the performance, the correctness and the robustness you’re looking for, to make the next killer-app. And, despite Fabian critic of vendors, thanks to that latest improvement in their SQL implementations, to scale out very easily.

It will spark in you the curiosity to know more. This at least is what happened to me when I started to read posts on his website. If you really love development, I’m sure it will happen to you as well. You’ve surely already realized that we the world we live in is all about data and information and knowing how to handle it correctly can really make a difference between a good and a superstar developer/DBA/BI guy. It’s all about education. And education confers knowledge. And knowledge is power.

Read the book especially if you’re not using any SQL DBMS right now. Almost all of them (with rare exceptions) are “reverting” to SQL, even if you don’t realize it, so the more you know about the Relational Data Model, the better for you and your career: knowing more is always better then knowing less. It puts you in the position of being able to make an informed choice. And with the huge amount of technologies we have at our hand today this is a key factor.

So, do yourself a favor, go and buy the book:

[BOOKS - DATABASE DEBUNKINGS](http://www.dbdebunk.com/p/blog-page_17.html?source=post_page-----a79685d3dd66----------------------)

