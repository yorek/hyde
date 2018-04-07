---
layout: post
title: "Custom Type Handling"
subtitle: "Go beyond Dapper limits and map arbitrary complex class"
tags: dapper .net micro-orm orm custom-handling
published: false
---

To map — or better - deserialize data coming from your database into a complex custom object Dapper supports a feature named “Custom Handlers”.
As you know with simple object you don’t have to do anything special since Dapper automatically maps database columns to properties with the same name. If you only need to change this mapping logic you can do that using Custom Mappers. If you need to completely control how database data is mapped your object that you need a Custom Handler.

## Custom Handling

Work in progress...