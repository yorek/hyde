---
layout: post
title: "SSIS Dashboard: Docker and ADF v2 support"
---

I’ve worked a little on my SSIS Dashboard project lately and I’ve been able to reach two important milestones for the project:

    Support Docker deployment
    Support SSIS running on Azure Data Factory v2

# Docker Support

If you are not confident with Python installation and configuration, or you just want to have a SSIS Dashboard running in couple of minutes without bothering to download and install all the attached strings, now you can just use the following docker image:

[SSIS Dashboard @ GitHub](https://hub.docker.com/r/yorek/ssis-dashboard/)

The full Dockerfile is available here, in case you prefer to built the image on your own or you want to hack it to better suit your needs:

[SSIS Dashboard Dockerfile](https://github.com/yorek/ssis-dashboard/blob/master/Dockerfile)

The image has been created using Ubuntu 16.04 as base image. Python 3.6 and SQL Server ODBC Drivers 13 (or latest) are installed during image building process.

Detailed instruction on how to configure and run the SSIS Dashboard with Docker are available on the GitHub site too:

[Install, Configure & Run SSIS Dashboard on Docker](https://github.com/yorek/ssis-dashboard/blob/master/docs/docker-support.md)

If you want to monitor your package running in the cloud, of course you can also run the container right on Azure, as explained here (but more detail on this in the next section):

[Use the Azure Docker VM Extension](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/dockerextension)

# Monitor SSIS Running on ADF v2

If you have moved your packages on Azure Data Factory v2, you’ll be happy to know that SSIS Dashboard works perfectly fine also in that scenario.

[Provision an SSIS integration runtime by using Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-create-azure-ssis-runtime-portal)

Honestly, I didn’t had to do really anything special to have it working on ADF v2, since a SSISDB database is used and made accessible to be queried, just like it happens with the on-premises version, and it was really nice to see it running at first attempt.

Please note that I did run some test for a while, and I haven’t found any problem so far, but of course there may be situation that I didn’t checked and that may generates error so, please, if you notice that something is not working as it should, please report the feedback opening in issue on the GitHub page.

The docker image mentioned before is just perfect in this scenario since it makes monitoring SSIS execution a very simple task.

Just spin up a VM with Docker extensions, and return the FQDN:

{% highlight bash %}
az group create --name SSISMON --location eastus

az group deployment create --resource-group SSISMON --template-uri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/docker-simple-on-ubuntu/azuredeploy.json

az vm show --resource-group SSISMON --name myDockerVM --show-details --query [fqdns] --output tsv
{% endhighlight %}

In a bash shell, SSH into the VM:

{% highlight bash %}
ssh <created-username>@<server>.eastus.cloudapp.azure.com
{% endhighlight %}

After having logged in the VM, a config file with the connection string pointing to the SSISDB needs to be created (check out the documentation available on GitHub to have more info on this):

{% highlight bash %}
echo -e 'CONNECTION_STRING = { \t "main": "DRIVER={ODBC Driver 13 for SQL Server};SERVER=<...>;DATABASE=SSISDB;UID=<...>;PWD=<...>" \t }' > config.cfg
{% endhighlight %}

and finally the docker image can be run:

{% highlight bash %}
docker run -d -p 5000:5000 --name ssis-dashboard -e DASHBOARD_CONFIG=config.cfg -v ~/config.cfg:/usr/src/app/dashboard/config.cfg yorek/ssis-dashboard
{% endhighlight %}

You can check that everything is running fine via docker logs:

and here’s the dashboard running:

As usual, enjoy!