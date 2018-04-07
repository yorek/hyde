---
layout: post
title: "Custom Columns Mapping"
subtitle: "Go beyond the \"same name\" mapping"
tags: dapper .net micro-orm orm column-mapping
---

Automatic mapping by name is nice, and it makes everything easier especially at the beginning and whenever there are no complex mapping requirements, but sooner then later the need to define a custom mapping logic will emerge.

In fact this is really a common requirement even in very simple database. Let’s say we just have a Users and a Companies table and, like the following:

![](https://cdn-images-1.medium.com/max/800/1*iQr-Gcbd6c3c6Uv6DPLbHg.png)

If you need to join them, in order to return all the data you need with just one query (using, for example, the [Multiple Mapping](https://medium.com/dapper-net/multiple-mapping-d36c637d14fa) feature already discussed), you have make sure that the final result set doesn’t have duplicate column names. In the mentioned sample, columns named `Id` will be aliased to avoid conflicts. Here a possible result:

![](https://cdn-images-1.medium.com/max/800/1*Pr0i_ap06-1EbFKfVUrixA.png)

As you notice `Id` column from `Users` table has been aliased to `UserId`, and the same logic was applied to `Id` column in `Companies` table, aliasing it to `CompanyId`.

The application object model, though, have the properties named `Id` only, and there is no point in changing the properties names to `UserId` and `CompanyId.` Firstly, this may not be possible at all, since you may not be allowed to the change the object model as it may breaks existing code. Secondly, object model and database models have their own life, with their own pros and cons: changing one to look like the other is a stretch that doesn’t help to keep code clean, maintainable and easy to understand.

![](https://cdn-images-1.medium.com/max/800/1*BKJG24H0uQq4gfYLTFDwjw.png)

## Custom Mapping

Custom mapping is the feature that Dapper offers to manually define, for each object, which column is mapped to which property.

Custom mapping is configured via the `SetTypeMap` static method:

![](https://cdn-images-1.medium.com/max/800/1*o8Tr2gDh6eBDVmFUCzqCLg.png)

In the example above `SetTypeMap` tells Dapper that, whenever the object of the type passed as first parameter is created, mapping with the database result set must be taken care by the _Type Mapper_ specified as the second parameter. A Type Mapper is a class that implements `ITypeMap`. Dapper already provides one implementation for that via the `CustomPropertyTypeMap` class:

![](https://cdn-images-1.medium.com/max/800/1*en0dUAQPlrZ-8BA_N-SR7g.png)

The `CustomPropertyTypeMap` class needs two parameters. The type you want to map (yep, again), and a `Func` delegate that points to the function used to do the actual mapping. In the code above that function is set to be `mapper`:

![](https://cdn-images-1.medium.com/max/800/1*XOGreZW-rGda-XK8iDFLtA.png)

The code is very simple in this case, as you can see. The dictionary object stores the mapping between the column name and the property it will be mapped to. The mapping function returns information for the mapped column or, if there is no mapping, for a column with the same name of the object property.

That’s it. From now on `UserId` and `CompanyId` columns will be mapped to the `Id` property each time an `User` or `Company` object is returned.

## Fluent Mapping

The mapping problem is solved then. Unfortunately it requires to write quite a bunch of code. Code that is just plumbing code at the end of the day, so it would be nice to solve this mapping challenge once and forever, without having to do it again and gain each time we need it.

The solution is `Dapper.FluentMap` a nice Dapper extension that takes care of mapping configuration, also offering a lot of customization options.

[**henkmollema/Dapper-FluentMap**  
_Dapper-FluentMap - Provides a simple API to fluently map POCO properties to database columns when using Dapper._github.com](https://github.com/henkmollema/Dapper-FluentMap "https://github.com/henkmollema/Dapper-FluentMap")[](https://github.com/henkmollema/Dapper-FluentMap)

The easiest way to use FluentMap is to create a mapping class for each object that needs to use custom mapping. The class must inherit from the generic `EntityMap` and specify the type for which you’re creating the custom mapping. Here’s the code to define a custom mapping for `User` class:

![](https://cdn-images-1.medium.com/max/800/1*oZJNm57AYN_MnKVmWBz8Bw.png)

Clean, simple, easy to understand. Beautiful. Once the mapping class is in place, it just needs to be registered so that Dapper knows it has to use it:

![](https://cdn-images-1.medium.com/max/800/1*yZrXsFvNKr3V7Wh0xmRXhA.png)

Beside the described explicit class mapping technique, FluentMap allows the definition of mapping also via _conventions_, so that you can leverage an existing naming convention if you have one, and even supports the ability to apply complex _transformations_ so even if you have complex naming conventions you can use regular expression to match columns to property and vice-versa.

Definitely recommended!

## Samples

All samples, both for manual custom mapping and FluentMap are avaiable here:

[**Dapper .NET Samples**  
_Samples that shows how to use Dapper .NET_yorek.github.io](https://yorek.github.io/dapper-samples/ "https://yorek.github.io/dapper-samples/")[](https://yorek.github.io/dapper-samples/)

## Conclusion

Being able to hook into the mapping logic, enables quite a few interesting scenario. The simplest one is the one shown in the example, by using a dictionary to specific mapping rules.

## What’s Next

Going forward on the extensibility and customization path, next topic will be related to understand how to completely customize Dapper serialization and deserialization process, giving us full control on it. As you may imagine, this will open up a world of possibilities, allowing us to overcome almost any limitation that we may face while using Dapper.
