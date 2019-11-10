---
layout: post
title: "Apache Zeppelin 0.6.2 for SQL Server Docker Image updated"
subtitle: "Using volumes to persist notebooks and interpreters configurations"
tags: apache zeppelin sql-server azure-sql azure-dw
published: true
---
In order to be able to keep created notebooks *and* interpreters configurations when upgrading the docker image to a newer version, I changed the *dockerfile* to use docker *volumes*

[Manage data in containers](https://docs.docker.com/engine/tutorials/dockervolumes/?source=post_page-----f9bba4f89a0c----------------------)

to run the container, now, the command is

```
docker run --name zeppelin -p 8080:8080 -v /zeppelin-sqlserver/notebook -v /zeppelin-sqlserver/conf -d yorek/zeppelin-sqlserver:v0.6.2
```

The *-v* does the trick and will be very useful the first time a new image will be released, so that you’ll be able to keep all your notebooks without having to export them before and, in addition, also interpreter configurations will be preserved.

The solution used until now (sharing a volume with the host) works nice, but unfortunately works only for notebooks. If you have a lot of different interpreter configured (like me) re-configuring them every time the image is updated is really time consuming and boring.

To be sure that your container is using volumes, you can check it using the *inspect* command:

```
docker inspect zeppelin
```

The output is a JSON with detailed information on the container. Look for the *Mounts* node:

![](/public/images/2017-01-05/image-01.png)

If you are using a previous version of the image, my recommendation is to download this updated one so that you’ll be ready for future updates.

If you’re not using Apache Zeppelin yet, you should really start. No matter if you are a Data Scientists or a DBA, Zeppelin is *really* useful to create nice visualization and dashboard just using T-SQL:

![](/public/images/2017-01-05/image-02.png)

