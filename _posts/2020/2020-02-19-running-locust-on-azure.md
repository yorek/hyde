---
layout: post
title: "Running Locust on Azure"
subtitle: "An easy and cheap way to massively call HTTP endpoints"
tags: azure locust testing test 
published: true
---
![](/public/images/2020-02-19/image-01.png)

If you are a developer that works in a field where you are asked to create or maintain REST API as your daily job, you’ll surely have found yourself in the need of testing API performance at some point.

I’ve found a very nice and simple tool to do that: Locust.

[Locust - A modern load testing framework](https://locust.io/)

Locust has several nice features that I really like:

In order to use Locust in Azure in the simplest and easiest way possble, I’ve create a docker image on Docker Hub:

[https://hub.docker.com/repository/docker/yorek/locustio](https://hub.docker.com/repository/docker/yorek/locustio)

As I really wanted some really easy and simple to use, I decided to go for [Azure Container Instances](https://azure.microsoft.com/en-us/services/container-instances/), and the repo with the script code to deploy Locust is available here:

[yorek/locust-on-azure](https://github.com/yorek/locust-on-azure)

If you are more inclined to use a more complex but more complete container orchestrator, of course Kubernetes could be better option.

In the mentioned repo, the script will take care of everything needed to run Locust on Azure:

Easy and nice, I can now run test for stability and performance my API.
