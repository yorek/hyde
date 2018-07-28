---
layout: post
title: "How to check your Anaconda version"
subtitle: "A simple way to view installed Anaconda and Python version"
tags: python anaconda miniconda
---

[Anaconda](https://conda.io/docs/glossary.html#anaconda-glossary) is a great Python distribution, and it is my favorite both for Data Science and for plain simple web development. It has so many packages already backed in, already compiled for Linux and Windows, that you can just forget the pain of having to compile a package yourself before using it.

Anaconda is also frequently updated, and I like to try to keep up with the updates to be sure I always have the best development experience possible. So checking which version of Anaconda you have is quite a common task.

## Packages and Meta-Packages

Task that may not be so easy at the beginning, since Anaconda is a quite complex beast. First of all Anaconda is the name of the _distribution_ that is also wholly contained in a _meta-package_ (a package of packages) with the same name.

So if you have already installed Anaconda and you want to check which version you have, all you need to do is to check the meta-package version. This can be done using _conda_, Anaconda’s package manager:

`conda list anaconda$`

this command will return only the package named “anaconda” (thanks to the $ and the end: yes it actually is a regular expression):

![](/public/images/2018-02-19/image-1.png)

As you can see I have the latest version (at time of writing, 5.1.0). You can use `conda list` to check installed version of any package within the distribution.

## Updating Anaconda

In case I need to update the distribution, it is better to first of all update the package manager:

`conda update conda`

and then update the meta-package

`conda update anaconda`

that will update all the anaconda distribution. Once “anaconda” meta-package is updated, you’ll have the latest Anaconda distribution.

*April 2018 Update*: If you want to update everything, not only python packages, but also additional software like anaconda-navigator and similar, you can go for an “update all”:

`conda update --all`

Please not the this action will update all packages to the latest version, which may be a different one than the one distributed with the anaconda metapackage. So, to summarize:

If you want *latest existing version of packages (despite what's in the anaconda metapackage)*: 

`conda update --all`

If you want the *latest version available in anaconda metapackage*: 

`conda update anaconda`

## Additional Anaconda Information

If you want to check which Python version Anaconda is using, and also on which platform it is running on, along with base paths for environment and packages just use

`conda info`

here’s the result with all the information needed:

![](/public/images/2018-02-19/image-2.png)

Yep, once you know the commands, is really that easy.