---
layout: post
title: "Run Apache Zeppelin 0.6.2 for SQL Server"
subtitle: "How to run Apache Zeppelin with SQL Server with Docker"
tags: apache zeppelin sql-server azure-sql azure-dw docker
published: true
---
As promised here is the first post that aim to show how to use Apache Zeppelin with SQL Server. First thing first: installation. Or maybe not.

The first thing to do, usually, is installing the product. Since we’re talking Java here, things may get a little bit long and complex if, like me, you’re more a .NET guy. Even worse if your not a Java nor .NET guy. You’re just a DBA or a Data Scientist. Well [Docker] (http://www.docker.com)is here to help.

Download and install Docker. It’s very easy an takes a few minutes only.

[Get Docker](https://www.docker.com/products/overview?source=post_page-----f9f484341e74----------------------)

Once it is running, open a console where you can send docker commands (any terminal if on Linux or macOS, PowerShell if running on Windows, Docker Quickstart Terminal if running using the Docker Machine toolbox) and go for the followin commands:

```
docker pull yorek/zeppelin-sqlserver:v0.6.2
docker run -p 8080:8080 --name zeppelin -d yorek/zeppelin-sqlserver:v0.6.2
```

The first download the docker image (depending on your connection speed it may take a while) and the second run the docker container with Apache Zeppelin inside. It also expose the port 8080 so that it can be used to reach the contained Apache Zeppelin process.

That’s it. Now you can connect to your local machine and start using Apache Zeppelin:

```
http://localhost:8080
```

If you’re still using the “old” Docker Machine (maybe because, like me, you also need to use VMWare and cannot then install Hyper-V), you have to connect to your Docker Machine instead of localhost. To get the IP Address of your Docker Machine simply do

```
docker-machine ip
```

From the Docker Quickstart Terminal.

To view the entire process in just a minute, here’s a short video:

[Install Apache Zeppelin for SQL Server in 1 minute](https://vimeo.com/193654694)

Next stop: Configure Apache Zeppelin and run your first query against SQL Server.

