---
layout: post
title: "Machine Learning on the Edge with Docker"
subtitle: "Using Anaconda distribution with Docker and the Azure IoT Edge Python SDK"
tags: iot iot-edge docker python anaconda miniconda machine-learning
---

[Anaconda](https://www.anaconda.com/download/) is a very well-known Python (and lately R) distribution, specifically created for Data Science and Machine Learning purposes (even though it can be used for more generic development). With the IoT Edge request on the rise, having Anaconda running on the edge is becoming a common request.

If you just want to start to play with ML on the Edge, there is a very nice tutorial that show how to leverage the Azure ML Workbench and IoT Edge here:

[Deploy Azure Machine Learning with Azure IoT Edge](https://docs.microsoft.com/en-us/azure/iot-edge/tutorial-deploy-machine-learning)

But what if you already have a Machine Learning environment and you'd like to be able to do your experiments on the cloud and then, once found the model you like, run in the Edge? To do that you need to have the two environments — Edge and Cloud — as similar as possible. Even better if they could be exactly the same environment: moving ML models from one to another would be almost seamless. That is exactly what I had recently: here's some notes on what I've learned.

## Anaconda or Miniconda?
Anaconda is the full-flagged distribution with hundreds of packages already installed and ready to be used. If you don't need all the packages and want to make sure you only install what you need, in order to keep the space used at the minimum (which could be the case if you're running on small devices), just install Miniconda. It comes only with Python and *conda*, the package manager. After that all you have to do to install the package you need is 

```
conda install <package>
```

In case you're wondering yes, you can also use PIP if the package you want is not available in the Anaconda repository. More details here:

[https://docs.anaconda.com/anaconda/](https://docs.anaconda.com/anaconda/)

## Running *conda on Docker
### Ubuntu and Windows Server
This is usually pretty easy, especially if you go with Ubuntu or Windows Server Core as a base image. There's really not much to say here: install needed packages if  on Ubuntu (`wget curl bzip2 libpython3-dev libboost-python-dev`), download the installation package, run it and you're good to go.

### Nano Server
Since the idea is to have the image working on the Edge, chances are that it needs to work on a somehow constrained environment, so it is usually a good practice to keep the image size as small as possible. For that reason the [Nano Server](https://docs.microsoft.com/en-us/windows-server/get-started/getting-started-with-nano-server) Windows edition (distribution?) is just perfect. Nano server is an heavy optimized and stripped down version of Windows, [perfect for being executed in a container](https://cloudblogs.microsoft.com/windowsserver/2016/02/10/exploring-nano-server-for-windows-server-2016/). 

Using Nano Server has some challenges, though. *There is no way to run an application, or even a setup, the tries to open up a GUI*. The executable will just quit without any errors, but even without doing anything. That's what happened when I tried to install both Anaconda and Miniconda. You run the setup and it just end immediately, no errors given, no work done. While there is a "silent" installation option that won't open any GUI, that is not enough. The setup program just won't work.

It took a while to figure out what was happening (given that there were no errors reported at all), but at the and the solution was found.

The trick here is to install Anaconda or Miniconda on the host machine and then copy the files in the image and update the correct path. Another option, that my fellow colleague [James Sturtevant](http://www.jamessturtevant.com/) showed me is to use the [multistage build]() feature that Docker offers.

Here you can find Dockerfiles for Ubuntu, Windows Server Core and Windows Nano Server, ready to be used, with Anaconda or Miniconda installed.

[yorek/docker-anaconda](https://github.com/yorek/docker-anaconda)

The Dockerfiles will run IPython if Anaconda has been installed, otherwise the shell will be executed:

```
docker run -it ubuntu-miniconda
```

![](/public/images/2018-03-20/image-1.png)

```
docker run -it nanoserver-miniconda
```

![](/public/images/2018-03-20/image-2.png)

James also created a Dockerfile to run the full Anaconda on Nano Server:

[jsturtevant/dockerfiles-windows](https://github.com/jsturtevant/dockerfiles-windows/tree/master/Anaconda)

### Images Size
Thanks to Nano Server the final Windows Container image is much smaller than the one with Windows Server Core and opens up a lot of scenarios that would have been otherwise precluded. 

Here's the resulting images size for images with Miniconda. Of course the full anaconda version will be bigger.

![](/public/images/2018-03-20/image-3.png)

## Running IoT Edge Python SDK with Anaconda
Now that Anaconda is installed, you may want to have the container used in a IoT Edge scenario and for this reason you'll need to install the Azure IoT Hub Device Client SDK:

[azure-iothub-device-client]()

If you're using Ubuntu or Windows Server Core based images you will just be able to run the SDK, but if you're on the Nano Server images...things are a little bit more complex. The SDK needs to use a .dll that it is NOT available (at the time of writing) in Nano Server and it will cause Python to generate the generic — and very unfriendly — error:

```
ImportError: DLL load failed: The specified module could not be found.
```

![](/public/images/2018-03-20/image-4.png)

Armed with patience (a lot) and the [Process Explorer]() I used my host machine to simulate the environment and analyzed what .dll were accessed by the SDK. Eventually I was able to identify the following .dll was missing in Nano Server:

![](/public/images/2018-03-20/image-5.png)

I changed the Dockerfile for Nano Server to COPY the above .dll in the `C:\Windows\System32` image folder, and after that, the SDK was running nicely.

>**Please note** that the SDK is still not working as expected on Windows Containers since full support to certificate is not yet there and thus MQTT doesn't work, but it will be there soon (and I'll update this post accordingly).

## Docker on Windows an Networking problems
While creating and testing the Dockerfiles I had to switch back and forth between Linux containers and Windows containers. Not sure if this was caused the problem or it just happened for who-knows-the-reason, at some point none of my containers was able to connect to internet anymore. 

After some time lost in googling around the web I found an official Microsoft Github repository that provided the solution. Here's the link:

[MicrosoftDocs/Virtualization-Documentation]()

There are several script in the repository that will help you fixing networking problem. I had to used the drastic one that basically completely wiped all existing Virtual Network configurations and recreated them from scratch. But that fixed the problem.