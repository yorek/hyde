---
layout: post
title: "Calling Azure REST API via cUrl"
subtitle: "A strightforward post to invoke Azure REST API via simple HTTP calls "
tags: azure rest api oauth2 cli curl
published: false
---

In these days I needed to call Azure REST API directly, without having the possibility to use some nice wrapper like AZ CLI or .NET SDK or Python SDK or whatever, since the REST API I needed to call was not included in one of the mentioned tools.

I decided to use cUrl since it is one of the easiest way to issue HTTP requests. It turned out to be a little more complex that I thought at the beginning, expecially while dealing with the authentication phase that.

Security, and thus authentication (which is based on OAuth2) is a pretty broad topic as you can see from the long documentation available here:

[Azure REST API Reference](https://docs.microsoft.com/en-us/rest/api/azure/#register-your-client-application-with-azure-ad)

I read throughout all the documentation, hyperlink included and at the end I was still confused. There are so many options and each one have quite a number of pre-requisites. So, for my future reference and for all those who just need a straightfoward way to solve the problem, here's the list of all steps required.

## Create a Service Principal
In order to access resources a Service Princiapal needs to be created in your Tenant. It is really convenient to do it via AZ CLI:

```
az ad sp create-for-rbac --name [APP_NAME] --password [CLIENT_SECRET]
```

for *much* more details and options see the documentation:

[Create an Azure service principal with Azure CLI 2.0](
https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?toc=%2Fazure%2Fazure-resource-manager%2Ftoc.json&view=azure-cli-latest)

What is happening here is that you're registering your application in order to be able to be recognized by Azure. Exactly like when you register your application to access Twitter or Facebook in order to be able to read and write posts/tweets/user data  and so on.

## Request the Access Token

As said before authentication used the OAuth2 protocoal, and this means that we have to obtain a token in order to authenticate all subsequent request. Since there is not Server-Side channel that we can use (we're just using a client application like cUrl), we need to use the client_credential flow:

```
curl -X POST -d 'grant_type=client_credentials&client_id=[APP_ID]&client_secret=[PASSWORD]&resource=https%3A%2F%2Fmanagement.azure.com%2F'https://login.microsoftonline.com/[TENANT_ID]/oauth2/token
```

all the three required information:
- APP_ID
- PASSWORD
- TENANT_ID

can be obtanied from he previous step. You already have the `PASSWORD` and the `APP_ID` sice you used it to create the Service Principal. The `TENANT_ID` will be returned by the `az ad sp create-for-rbac` you executed before.

The result of this call will be an Authorization Token that looks like the following:

```
eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImlCakwxUmNxemhpeTRmcHhJeGRacW9oTTJZayIsImtpZCI6ImlCakwxUmNxemhpeTRmcHhJeGRacW9oTTJZayJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuYXp1cmUuY29tLyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzcyZjk4OGJmLTg2ZjEtNDFhZi05MWFiLTJkN2NkMDExZGI0Ny8iLCJpYXQiOjE1MjUyMDY3MTAsIm5iZiI6MTUyNTIwNjcxMCwiZXhwIjoxNTI1MjEwNjEwLCJhaW8iOiJZMmRnWUJCODlNUC9TSnpmMzZqNkdYK2JwbjJiQkFBPSIsImFwcGlkIjoiYTlhMTAzNDItZDJmNS00NzM3LTk3ZWItYTFmZGEwNzBhYjBhIiwiYXBwaWRhY3IiOiIxIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3LyIsIm9pZCI6IjFiNmRhZThmLTc4ZjctNDI3Mi05Y2E0LTgyMDY5YjA1ZTE5NSIsInN1YiI6IjFiNmRhZThmLTc4ZjctNDI3Mi05Y2E0LTgyMDY5YjA1ZTE5NSIsInRpZCI6IjcyZjk4OGJmLTg2ZjEtNDFhZi05MWFiLTJkN2NkMDExZGI0NyIsInV0aSI6IlhjSGxPWFBLVWt1R3JhRE1ZUU1PQUEiLCJ2ZXIiOiIxLjAifQ.GdT8Oswpy0dSv86-iIS8dtSnJOkfzeI49v_LpH28SMXpop8v5gw0oC7WrSs13B5vVJ_wimfhuKjEETxWIPRQXl8f4ZHW2zoEnkiTvMyjRhm39u9zu8sPOouTYsGnWpQYEScWi_NelgOMXcJUIUBYeH_c58YJITUelicVAE-hkSFwruPWvkE15zzleYir_SsSVveaRlMUq9q7GOEr87aGvOVB3QManIn_jIo1cnDCUJZ3WX7hcMvq0dLE8Ap1ZL_HQqOzLbJfpnSCDfs2X2pBmqB3JH5rzrCAzeL1mYL5TOgC8k3s1Z_vvTqxD2XrO7QOGhGfxqxxDWJAXiblUtafHg
```

and that needs to be used in the Authorization HTTP header to make sure your HTTP call will be authorized.

Done! You can now use cUrl to make REST call to the Azure API:


or you can also use Insomina or Postman if you prefer some more advacned REST client.