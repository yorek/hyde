---
layout: post
title: "Querying Azure Stream Analytics results in real time using Azure SQL"
subtitle: "Testing Stream Analytics queries for correctness can be hard, but with an help from Azure SQL you can do it"
tags: azure-stream-analytics azure-sql real-time query debug test
published: true
---

You've been assigned to task to write several [Azure Stream
Analytics](https://azure.microsoft.com/en-us/services/stream-analytics/) queries
and before signing them off for production you, or someone from your team, needs
to test the queries and make sure results are correct.

You've already downloaded *some sample data* and used it with Visual Studio to
create and test the queries locally:

or from the portal:

But now you are ready to test it against the streaming data source. And here
comes the problem…how can you do that? If queries are complex you need to be
able to query the results in order to make sure they are correct. For example,
let's say that one of your queries must "save the streamed value if and only if
is different than the previous one". While you can surely do some test using the
sampled data you downloaded, it would be great if you could also *query* the
result of the Stream Analytics Job when running on *real* data.

Using a bit of [lateral
thinking](https://en.wikipedia.org/wiki/Lateral_thinking)* *(yes, again!), the
problem can be solved quite easily, using Azure SQL and a tool like [SQL Server
Management
Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017)
or [SQL Server Operation
Studio](https://docs.microsoft.com/en-us/sql/sql-operations-studio/download?view=sql-server-2017)
or [Apache Drill](https://drill.apache.org/).

Let's save Apache Drill for another post, and let's focus on the Azure SQL
approach.

## Create a JSON Output

In order to see what's doing in real time your Azure Stream Analytics, a
dedicated output to monitor it is needed. Since we're following the Azure SQL
road to solve our little problem, we need to use a JSON output that we can
consume lately from Azure SQL.

Here's how the Job Output needs to be configured. You need to choose a "[Blob
Storage
Sink](https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-define-outputs#blob-storage)"
and configure it so that it will write a JSON Array:

A sample Azure Stream Analytics query could be like the following:

As you can see, beside sending processed data to the 'OutputStream', whatever it
may be, I'm also sending data to the 'OutputMonitor'. The query has been
organized and written so that when I don't need to monitor the output I can jut
comment out the last line.

After the job is started you will see a .json file in the configured Azure Blob
Store:

## Query the JSON file

It's now really easy to query that JSON via 'OPENROWSET' for any Azure SQL
Database, even the free tier!

Note that the CTE add a closing square bracket to the read JSON data. This is
needed because we selected to have a JSON array as output, but we're querying
the data *while* it is being written, so the JSON array is not closed yet, and
we so we need to do it manually to correctly read it.

If you never configured your Azure SQL to read from a Blob Store, just read the
post I wrote some times ago to be up and running in minutes:

Problem solved!

Just keep in mind that you are reading data right from a JSON file…so if it gets
big, performance will be quite slow.

## What's Next?

Another option, as mentioned before, if you're not into Azure SQL and its tools,
is to use Apache Drill. I will talk about that in a couple of future posts. Stay
tuned if you're interested!