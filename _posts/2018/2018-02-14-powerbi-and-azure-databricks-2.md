---
layout: post
title: "PowerBI and Azure Databricks — 2"
subtitle: "Easier configuration and DirectQuery support with the Spark Connector"
tags: powerbi azure databricks spark direct-query
---

Just a couple of days after I published the article that describes how to connect to [Azure Databricks with PowerBI via the ODBC](https://medium.com/@mauridb/powerbi-and-azure-databricks-193e3dc567a) connector, I received an email from friends ([Yatharth](https://www.linkedin.com/in/yatharth) and [Arvind](https://www.linkedin.com/in/arvindsh)) in the Azure Databricks and AzureCAT team that told me that a better and easier way now available to connect PowerBI to Azure Databricks was possible.

Not only this new way is way simpler and lightweight, but it also enables usage of DirectQuery to offload processing to Spark, which is perfect when you have a real huge amount of data, that doesn’t make sense to be loaded into PowerBI, or when you want to have (near) real-time analysis.

The PowerBI connector to be used to go this way is, as you may have guessed, the Spark connector:

![](/public/images/2018-02-14/image-01.png)

Configuring the connector, compared to all the setup needed with ODBC, is really a breeze. All you have to specify is the server and the protocol. Protocol must be set to `HTTP`:

![](/public/images/2018-02-14/image-02.png)

Setting the server is _just a bit tricky_. Information can be found in the JDBC/ODBC pane available in the Configuration page of your Azure Databricks Spark cluster:

![](/public/images/2018-02-14/image-03.png)

The url needs to be constructed following this procedure:

1.  from the JDBC url take the hive2 server address, excluding the database name. In the shown example would be: `hive2://eastus.azuredatabricks.net:443/`
2.  Replace `hive2` with `https` so that the url becomes: `https://eastus.azuredatabricks.net:443/`
3.  Now concatenate that string you the other one you can find the in HTTP Path box. In the sample is:  
    `sql/protocolv1/o/6132794369297039/0214-200557-viols339`
    or  
    `sql/protocolv1/o/6132794369297039/dmdbtest`

The final url would be:

`https://eastus.azuredatabricks.net:443/sql/protocolv1/o/6132794369297039/0214-200557-viols339`

Now just insert it into the Server textbox of PowerBI Spark connector configuration window, as mentioned before, and you’re almost done.

Credentials are issued and managed via the Personal Token, exactly as explained in the [ODBC article](https://medium.com/@mauridb/powerbi-and-azure-databricks-193e3dc567a). So just insert the `token` user name (remember that you really have to literally insert “`token`” as username) and then the generated token as password:

![](/public/images/2018-02-14/image-04.png)

After that it will just works, now also with DirectQuery:

![](/public/images/2018-02-14/image-05.png)

Here a glimpse of what’s happening behind the scenes, with the SQL queries sent to Spark when DirectQuery is used:

![](/public/images/2018-02-14/image-06.png)

Official documentation will be updated soon, in the meantime, for all those like me who are eager to play with Azure Databricks and PowerBI, I hope this helps.
