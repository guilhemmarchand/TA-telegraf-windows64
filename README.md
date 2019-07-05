# Sample Splunk Technical Addon to run Telegraf as a Splunk application on Windows 64 bits

## This is an example of a ready to use Splunk Technology Addon to run Telegraf published as a Splunk application

Telegraf deployment as Splunk application deployed by Splunk (TA)
-----------------------------------------------------------------

You can publish Telegraf through a Splunk application deployed using a Splunk deployment server.

This means that you can create a custom Technology Addon (TA) that contains both the Telegraf binary and the telegraf.conf configuraton files.

**This method has several advantages:**

- If you are a Splunk customer already, you may have the Splunk Universal Forwarder deployed on your servers, you will NOT need to deploy an additional collector independently from Splunk

- You get benefit from the Splunk centralisation and deploy massively Telegraf from Splunk

- You can maintain and upgrade Telegraf just as you do usually in Splunk, all from your Splunk Deployment Server. (DS)

**To achieve this, you need to:**

- Create a package in your Splunk Deployment Server, let's call it "TA-telegraf-windows-64", if you have more than this architecture to maintain, just reproduce the same steps for other processor architectures. (arm, etc)

```
    $SPLUNK_HOME/etc/deployment-server/TA-telegraf-windows-64
                                                        /bin
                                                        /local/telegraf.conf
                                                        /metadata/default.meta
```

- The "bin" directory contains the Telegraf binary

- The "local" directory hosts the telegraf.conf configuration file

- The "metadata" directory is a standard directory that should contain a default.meta which in the context of the TA will contain:

*default.meta*

```
    # Application-level permissions
    []
    owner = admin
    access = read : [ * ], write : [ admin ]
    export = system
```

- Download the last Telegraf version for your processor architecture (here amd64), and extract its contain in the "bin" directory, you will get:

```

    bin/telegraf/telegraf.exe
```

- On Windows platforms, Telegraf needs to run as a service, we create a simple bat script that will be started by Splunk startup:

```
    bin/init.bat
```

This simple bat script does the following actions:

- Verifies if the telegraf service exists, if it does not exist the service gets created by calling the telegraf binary with the -service install argument, then starts the service
- If the service exists and is started, it will be stopped and started

**Finally, create a very simple local/inputs.conf configuration file:**

*local/inputs.conf*

```
    # This simple bat wrapper will stop/start the service if exists, install/start the service if not existing yet
    [script://.\bin\init.bat]
    disabled = false
    interval = -1
```

**Upgrades:**

To upgrade Telegraf binary to a new version, simply extract the new zip release in the "bin" directory, and reload your Splunk Deployment server.

Splunk will automatically restart the Telegraf process after Splunk startup.

**Configuration updates:**

If you need to perform a modification of the telegraf.conf configuration, when the deployment server is reloaded, the Splunk client instance automatically detects a change and will download a new copy of the TA.

As long as the application is configured to be restarting Splunk when it is reloaded (restart splunkd box), any configuration change on the deployment server will be detected and applied on all clients.
