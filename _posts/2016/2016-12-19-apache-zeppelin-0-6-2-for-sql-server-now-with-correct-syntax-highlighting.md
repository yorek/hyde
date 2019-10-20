---
layout: post
title: "Apache Zeppelin 0.6.2 for SQL Server now with correct Syntax Highlighting"
subtitle: "The new release add syntax highlighting to SQL Server support"
tags: apache zeppelin sql-server azure-sql azure-dw
published: true
---
After a little bit of work I’ve managed to have syntax highlight for T-SQL in Apache Zeppelin 0.6.2 working correctly.

The tricky part is that the [Ace Editor](https://ace.c9.io/#nav=about) already supports T-SQL specific syntax highlighting from v 1.2.0, but Apache Zeppelin is still using version v 1.1.9.

Moving the v 1.2.0 doesn’t work since it creates some compatibility issues so the only way to go was to manually patch and tweak Apache Zeppelin to use the highlighting file for T-SQL available in version 1.2.0.

Said and done, now T-SQL is beautifully highlighted:

![](/public/images/2016-12-19/image-01.png)

SQL Server 2016 and vNext aren’t supported yet but I’ll work on this in future for sure.

Both the [GitHub repository](https://github.com/yorek/zeppelin/tree/v0.6.2) and the [Docker Hub](https://hub.docker.com/r/yorek/zeppelin-sqlserver/) are already updated. To update your docker image, if you already have downloaded it before, just do the usual pull:

```
docker pull yorek/zeppelin-sqlserver:v0.6.2
```

 Then go for

```
docker stop zeppelin
docker rm zeppelin
docker run -p 8080:8080 — name zeppelin -d yorek/zeppelin-sqlserver:0.6.2
```

