---
layout: post
title: "SQL Server 2016 Temporal Tables"
subtitle: "Natively keep track of changed data with Temporal Tables"
tags: sql-server temporal-tables
published: true
---

I have delivered a talk about “SQL Server 2016 Temporal Tables” for the Pacific Northwest SQL Server User Group at the beginning of October . Slides are available on SlideShare here:

[SQL Server 2016 Temporal Tables](http://www.slideshare.net/davidemauri/sql-server-2016-temporal-tables)

and the demo source code is — of course — available on GitHub:

[yorek/PNWSQL-201610](https://github.com/yorek/PNWSQL-201610?source=post_page-----d0bc9c5a8a0----------------------)

The ability of automatically keep previous version of data is really a killer feature for a database since it lift the burden of doing such really-not-so-simple task from developers and bakes it directly into the engine, in a way it won’t even affect existing applications, if one needs to use it even in legacy solutions.

The feature is useful even for really simple use cases, and it allows to open up a nice set of analytics options. For example I’ve just switched the feature on for a table where I need to store that status of an object that needs to pass through several steps to be processed fully. Instead of going through the complexity of managing the validity interval of each row, I’ve just asked the developer to update the row with the new status and that’s it. Now querying the history table I can understand which is the status that takes more time, on average, to be processed.

That’s great: with less time spent doing technical stuff, more time can be spend doing other more interesting activities (like optimizing the code to improve performance where analysis shows they are not as good as expected).

