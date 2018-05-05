---
layout: post
title: "Calling Azure REST API via cUrl"
subtitle: "A strightforward post to invoke Azure REST API via simple HTTP calls"
tags: azure rest api oauth2 cli curl
published: true
---

In these days I needed to call Azure REST API directly, without having the possibility to use some nice wrapper like [AZ CLI](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest) or [.NET SDK or Python SDK or whatever](https://azure.microsoft.com/en-us/downloads/), since the REST API I needed to call was not included in any of the mentioned tools.

I decided to use [curl](https://curl.haxx.se/) since it is one of the easiest way to issue HTTP requests. But it turned out to be a little more complex that I what I could have expected at the beginning, especially while dealing with the authentication phase. The entire process is pretty simple as you'll see, documentation is just a bit scattered all around...so it may be difficult to quickly understand the path you must follow to get everything working nicely.

Azure API security, and thus authentication (which is based on [OAuth2](https://oauth.net/2/)) is a pretty broad topic as you can see from the long documentation available here:

I read throughout all the documentation, hyperlinks included and at the end I was still confused. There are so many options and each one have quite a number of prerequisites that requires even more reading. So, for my future reference and for all those who just need a straightforward way to solve the problem, here's the list of all steps required.

## Create a Service Principal

In order to access resources a Service Principal needs to be created in your Tenant. It is really convenient to do it via AZ CLI:

    az ad sp create-for-rbac --name [APP_NAME] --password [CLIENT_SECRET]

for *much* more details and options see the documentation:

What is happening here is that you're registering your application in order to be able to be recognized by Azure (more precisely: from the AD tenant that is taking care of your subscription). Exactly like when you register your application to access Twitter or Facebook in order to be able to read and write posts/tweets/user data and so on.

## Request the Access Token

As said before authentication used the OAuth2 protocol, and this means that we have to obtain a token in order to authenticate all subsequent request. We need to use the [client_credential](https://www.oauth.com/oauth2-servers/access-tokens/client-credentials/) flow:

    curl -X POST -d 'grant_type=client_credentials&client_id=[APP_ID]&client_secret=[PASSWORD]&resource=https%3A%2F%2Fmanagement.azure.com%2F' https://login.microsoftonline.com/[TENANT_ID]/oauth2/token

all the three required information:

* APP_ID
* PASSWORD
* TENANT_ID

can be obtained from the previous step. You already have the `PASSWORD` since you used it to create the Service Principal. The `TENANT_ID` and the `APP_ID` will be returned by the `az ad sp create-for-rbac` command you executed before. Otherwise you can execute the following `az` command to find it the tenant id:

    az account list --output table --query '[].{Name:name, SubscriptionId:id, TenantId:tenantId}'

And the following to get the `APP_ID`:

    az ad sp list

The result of the curl call will be an Authorization Token that looks like the following:

    eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImlCakwxUmNxemhpeTRmcHhJeGRacW9oTTJZayIsImtpZCI6ImlCakwxUmNxemhpeTRmcHhJeGRac
    [...]
    hkSFwruPWvkE15zzleYir_SsSVveaRlMUq9q7GOEr87aGvOVB3QManIn_jIo1cnDCUJZ3WX7hcMvq0dLE8Ap1ZL_HQqOzLbJfpnSCDfs2X2pBmqB3JH5rzrCAzeL1mYL5TOgC8k3s1Z_vvTqxD2XrO7QOGhGfxqxxDWJAXiblUtafHg

## Call Azure REST API

The obtained token that needs to be used in the Authorization HTTP header as the `Bearer Token` to make sure your HTTP call will be authorized:

    curl -X GET -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json" https://management.azure.com/subscriptions/[SUBSCRIPTION_ID]/providers/Microsoft.Web/sites?api-version=2016-08-01

And that's it. Is really easy at the end. And once you have the token it is also easy to use it in your preferred REST client tool, be it
[Postman](https://www.getpostman.com/) or [Insomnia](https://insomnia.rest/).

If you want learn more on how to use the OAuth2 authentication protocol to access Azure, just go here:

[Azure Active Directory v2.0 and the OAuth 2.0 client credentials flow](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols-oauth-client-creds)