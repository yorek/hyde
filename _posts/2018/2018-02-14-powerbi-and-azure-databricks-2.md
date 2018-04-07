---
layout: post
title: "PowerBI and Azure Databricks — 2"
subtitle: "Easier configuration and DirectQuery support with the Spark Connector"
tags: powerbi azure databricks spark direct-query
---

Just a couple of days after I published the article that describes how to connect to [Azure Databricks with PowerBI via the ODBC](https://medium.com/@mauridb/powerbi-and-azure-databricks-193e3dc567a) connector, I received an email from friends ([Yatharth](https://www.linkedin.com/in/yatharth) and [Arvind](https://www.linkedin.com/in/arvindsh)) in the Azure Databricks and AzureCAT team that told me that a better and easier way now available to connect PowerBI to Azure Databricks was possible.

Not only this new way is way simpler and lightweight, but it also enables usage of DirectQuery to offload processing to Spark, which is perfect when you have a real huge amount of data, that doesn’t make sense to be loaded into PowerBI, or when you want to have (near) real-time analysis.

The PowerBI connector to be used to go this way is, as you may have guessed, the Spark connector:

![](https://cdn-images-1.medium.com/max/800/1*Un83FYnq5tuBFlpfuxQu3Q.png)

Configuring the connector, compared to all the setup needed with ODBC, is really a breeze. All you have to specify is the server and the protocol. Protocol must be set to `HTTP`:

![](https://cdn-images-1.medium.com/max/800/1*MMJdRZ4BIhi5AsccUmm4Tw.png)

Setting the server is _just a bit tricky_. Information can be found in the JDBC/ODBC pane available in the Configuration page of your Azure Databricks Spark cluster:

![](https://cdn-images-1.medium.com/max/800/1*U8VXKeplFfOMHaniZNW6Ow.png)

The url needs to be constructed following this procedure:

1.  from the JDBC url take the hive2 server address, excluding the database name. In the shown example would be: `hive2://eastus.azuredatabricks.net:443/`
2.  Replace `hive2` with `https` so that the url becomes: `[https://eastus.azuredatabricks.net:443/](https://eastus.azuredatabricks.net:443/)`
3.  Now concatenate that string you the other one you can find the in HTTP Path box. In the sample is:  
    `[sql/protocolv1/o/6132794369297039/0214-200557-viols339](https://eastus.azuredatabricks.net:443/sql/protocolv1/o/6132794369297039/0214-200557-viols339)  
    `or  
    `[sql/protocolv1/o/6132794369297039/dmdbtest](https://eastus.azuredatabricks.net:443/sql/protocolv1/o/6132794369297039/0214-200557-viols339)`

The final url would be:

`[https://eastus.azuredatabricks.net:443/sql/protocolv1/o/6132794369297039/0214-200557-viols339](https://eastus.azuredatabricks.net:443/sql/protocolv1/o/6132794369297039/0214-200557-viols339)`

Now just insert it into the Server textbox of PowerBI Spark connector configuration window, as mentioned before, and you’re almost done.

Credentials are issued and managed via the Personal Token, exactly as explained in the [ODBC article](https://medium.com/@mauridb/powerbi-and-azure-databricks-193e3dc567a). So just insert the `token` user name (remember that you really have to literally insert “`token`” as username) and then the generated token as password:

![](https://cdn-images-1.medium.com/max/800/1*CRGx0klbg_m-2LOGBTeuUw.png)

After that it will just works, now also with DirectQuery:

![](https://cdn-images-1.medium.com/max/800/1*St-7ze-A667Mm_UkOTo8Tg.png)

Here a glimpse of what’s happening behind the scenes, with the SQL queries sent to Spark when DirectQuery is used:

![](https://cdn-images-1.medium.com/max/800/1*apczL0MAtwqEHVNLsV_j3w.png)

Official documentation will be updated soon, in the meantime, for all those like me who are eager to play with Azure Databricks and PowerBI, I hope this helps.
