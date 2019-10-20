---
layout: post
title: "SQL Server Interpreter for Apache Zeppelin 0.6.2"
subtitle: "What’s new in this release?"
tags: apache zeppelin sql-server azure-sql azure-dw
published: true
---

I’ve updated the code-base to Apache Zeppelin 0.6.2 and I’ve also finished a first simple-but-working support to autocomplete (you can activate it using CRTL + .). Right now the autocomplete is based on the keywords specified here:

[Reserved Keywords (Transact-SQL)](https://msdn.microsoft.com/en-us/library/ms189822.aspx)

is not much, I know, but is something, at least. Next steps will be to read schemas, tables and columns from SQL Server catalogs table. And maybe extract the list of keywords from….somewhere else, to have a more complete coverage.

I’ve also removed additional Interpreter that may not be useful if you just plan to use it against T-SQL/TDS compatible engines (SQL Server, Azure SQL and Azure DW), and configured the defaults so that it is ready to use SQL Server right from the beginning.

The code — along with compilation/install/basic usage instructions — is available on GitHub:

[yorek/zeppelin](https://github.com/yorek/zeppelin/tree/v0.6.2?source=post_page-----e72f40c8591d----------------------)

Right now I’ve tested it only on Ubuntu Linux 16.04 LTS 64bits. It should also work on native Windows, but since I haven’t tried it yet on that platform, I don’t know the challenge you may face in order to have the full stack (Java, Maven, Node, ecc. ecc.) working in order so that you can be able to compile and run it.

 I’ll release a small tutorial to show how you can use Apache Zeppelin for SQL Server also on your Windows machine using Docker. I plan to do a few tutorials on the subject, since I find Apache Zeppelin very useful and I’m sure it will be loved also by many other SQL Server guys once they start to play with it.

At some point I’ll will also release only the *bin* package so that one doesn’t have to compile it himself (but hey, do we love Linux right now, don’t we?) and so that it can just run on Windows, but for now I find the Docker container approach so much better than anything else (it “just runs” and I can do anything via GitHub and Docker Hub), that I’ll stay with this for a while.

