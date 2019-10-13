---
layout: post
title: "Using NLog with Azure Functions"
subtitle: 
tags: "azure-functions nlog logging"
published: true
---

I’ve using Azure Function quite a lot lately and I’m really becoming a fan of [serverless architecture](http://martinfowler.com/articles/serverless.html). One of the things I love is that one can create an assembly (talking of .NET, of course) that does something — in my case take data from Elastic Search and move it to SQL Azure — and then put it on an [Azure Function](https://azure.microsoft.com/en-us/documentation/articles/functions-reference/) so that it can be called via a [Web-Hook](https://azure.microsoft.com/en-us/documentation/articles/functions-bindings-http-webhook/) or via [ServiceBus Queue,](https://azure.microsoft.com/en-us/documentation/articles/service-bus-dotnet-get-started-with-queues/) writing the smallest amount of code to do this two things. After all I’m interested in taking data from one source, process it, and store it in another one, so I don’t really want to spend too much time in everything is not specifically related to such task.

I have created my assembly that does everything I want, I deployed it on Azure Functions (using the nice Continuous Integration feature) and it just works.

Works with the exception of logging. I have used [NLog](http://nlog-project.org/) in my assembly, but Azure Functions have their own logging infrastructure which, of course, is not aware of the fact that I already have one.

I need to be able to redirect NLog logging to Azure Function logs so that they I can take advantage of the existing infrastructure. Luckily this is quite easy to do: Azure Functions provides a TraceWriter class for logging, so all is needed to be done is to instruct NLog to use such TraceWriter. This can be done by creating a new NLog Target and then using it. At the end of the day something like this will be exactly what I need:

After that all NLog calls will be sent to the Azure Function logging infrastructure:

![](/public/images/2016-10-24/image-01.png)

so all the log call already present in my assembly will now gracefully show in Azure Functions monitor and dashboard. Job done!

A working code sample is available here:

[https://github.com/yorek/AzureFunctionNLog](https://github.com/yorek/AzureFunctionNLog)

To setup the sample all you have to do is create an Azure Function project from Azure Portal and then deploy the files. If you want you can do it right from GitHub:

[Continuous deployment for Azure Functions](https://azure.microsoft.com/en-us/documentation/articles/functions-continuous-deployment/?source=post_page-----70992d0d391f----------------------)

Since Azure Functions are still in preview, you can create a new Function App using the dedicated portal:

[Get started with Azure Functions](https://functions.azure.com/signin?correlationId=f765bb56-2e57-4428-b55f-edef91460e1b)

and you may also want to take a look at

[Azure Functions Templates](https://github.com/Azure/azure-webjobs-sdk-templates)

to have some additional ready-to-use samples

Enjoy!

## PS

I know many are surely wondering why I need to move data from Elastic Search to SQL Server. It’s a complex story and I’ll surely tell it once is almost done, for now suffice to say that Elastic Search is our Data Lake, so it makes sense to have it working behind the scenes, leaving to SQL Azure the front-face role.

