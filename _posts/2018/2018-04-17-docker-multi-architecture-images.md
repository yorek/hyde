---
layout: post
title: "Docker Multi-Architecture Images"
subtitle: "Let docker figure the correct image to pull for you"
tags: docker multi-arch
---

In one of the projects I'm working on, we're targeting both Linux and Windows system. Of course we're using Docker to containerize the whole application and make it easy to work on both systems: we created two docker images one for each supported system, and after that what we needed was to make sure that if someone would be pulling the my-cool-image:latest from a Unix-based machine, the Linux image would be returned, while if doing the pull from a Windows machine (using Windows containers), then the windows-based image would be used.

Both for developers and user, being able to abstract the image from the architecture it will be running on is a great thing. You reach the level of abstraction where you don't really care where the solution will be executed. It will just run. Say that you want to execute the

```
yorek/multiarch-hello-world
```

beautiful containerized application on your system. You should expect to just run the usual docker run commands and that's it, it will work. No matter if you're on Ubuntu, Mac OSX or Windows (Containers), right?

Right! Good news is that it is totally possible, and, as developers, to do this we need to leverage a nice feature of Docker called [Manifest List](https://docs.docker.com/registry/spec/manifest-v2-2/), also known as Multi-Architecture, shortened to multi-arch for friends.

## Create two images

Let's first of all create two very simple images that will serve two different architectures. Here's the "Hello World" for Windows:

```
FROM microsoft/nanoserver:latest
CMD echo "Hello World from Windows"
```

and here's the dockerfile for "Hello World" using Linux:

```
FROM alpine:latest
CMD echo "Hello World from Linux"
```

let's build the two images and let's call them multiarch-hello-world:windows and multiarch-hello-world:linux respectively, and push them to your Docker repository.

## Enable manifest command

Docker now [support the ability to work with image manifest natively](https://docs.docker.com/edge/engine/reference/commandline/manifest/). The feature is still in development and thus if you just try to run it

```
docker manifest
```

you'll get the following message:

```
docker manifest is only supported when experimental cli features are enabled
```

To enable the manifest feature, the *experimental CLI* options needs to be set in the config file in .docker home folder. Here's how your config.json file should look like

```
{
    "experimental": "enabled",
    "credsStore": "wincred",
    "auths": {
        "https://index.docker.io/v1/": {}
    }
}
```

once this is done, you can run the docker manifest command without problems.

## Create a manifest list

The first step to create a multi-architecture image is to create a [*manifest list](http://(https://docs.docker.com/registry/spec/manifest-v2-2/#manifest-list))*. The manifest list will be seen as a "virtual image" but it will actually contain an index of available images with their relative supported architecture. With that information the docker client will now be able to actually pull the image for the correct architecture.

Since the manifest list is seen as a virtual image, the usual naming convention should be used too. For example in my repository on Docker Hub, I have created a repository called multiarch-hello-world, and I want make sure that everyone who will pull the *latest* tag will automatically get the correct image for the architecture being used. So my manifest list needs to be named as

```
yorek/multiarch-hello-world:latest
```

and it needs to index the

* yorek/multiarch-hello-world:linux

* yorek/multiarch-hello-world:windows

images. The docker manifest command uses the following syntax

![](/public/images/2018-04-17/image-01.png)

so here's the command for the mentioned sample:

```
docker manifest create
    yorek/multiarch-hello-world:latest
    yorek/multiarch-hello-world:linux
    yorek/multiarch-hello-world:windows
```

once the manifest list is created, it can be pushed like an image:

```
docker manifest push yorek/multiarch-hello-world:latest
```

and it will be available in your repository, just like (again) a standard image:

![](/public/images/2018-04-17/image-02.png)

and, just like a standard image it can be used:

![](/public/images/2018-04-17/image-03.png)

Et voila', multi-architecture support: done.

## Inspect a manifest list

Well, you can actually inspect manifest list *and *manifests for single images. For example if you run

```
docker manifest inspect yorek/multiarch-hello-world:windows
```

you'll get the details about that image:

![](/public/images/2018-04-17/image-04.png)

while if you do it on a manifest list, you'll get the manifest list you created before (look at the mediaType property):

![](/public/images/2018-04-17/image-05.png)

as you can see in the manifest list there are references to the images (well, their manifests), via their digest value, along with the information on the supported architecture. A list of supported operating systems and architectures is available here, in the "$GOOS and $GOARCH" section:
[Installing Go from source - The Go Programming Language](https://golang.org/doc/install/source#environment)

Yes, the link points to a Go Language help page, and that's correct (I think it is related to the fact that the original tool that supported manifest list was written in GoΓÇªcheck next section for this).

## Want to know more ?

If you're interested in the topic and want to know more, you can start learning from the historical background behind the multi-architecture feature here (thanks [@druttka](https://twitter.com/druttka?lang=en) for the link ):

[Multi-arch All The Things - Docker Blog](https://blog.docker.com/2017/11/multi-arch-all-the-things/)

and also take a look at the original support for manifest lists via the manifest-tool:

[estesp/manifest-tool](https://github.com/estesp/manifest-tool)

and finally, you may want to take a look at the manifest API:

[HTTP API V2](https://docs.docker.com/registry/spec/api/#manifest)

and the manifest specs:

[Image Manifest V 2, Schema 2](https://docs.docker.com/registry/spec/manifest-v2-2/)
