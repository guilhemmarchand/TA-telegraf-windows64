@Echo Off
Set ServiceName=telegraf
Set SplunkHome=%SPLUNK_HOME%

SC queryex "%ServiceName%"|Find "does not exist">Nul&&(
        Echo "%ServiceName%" is not installed yet, doing now
        if not exist "%SplunkHome%\var\run\telegraf" mkdir "%SplunkHome%\var\run\telegraf"
        xcopy "%SplunkHome%\etc\apps\TA-telegraf-windows64\local\telegraf.conf" "%SplunkHome%\var\run\telegraf\" /K /D /H /Y
        xcopy "%SplunkHome%\etc\apps\TA-telegraf-windows64\bin\telegraf\telegraf.exe" "%SplunkHome%\var\run\telegraf\" /K /D /H /Y
        "%SplunkHome%\var\run\telegraf\telegraf.exe" -service install -config "%SplunkHome%\var\run\telegraf\telegraf.conf"
        echo %ServiceName% has been installed
        echo Start %ServiceName%
        Net start "%ServiceName%"
        echo %ServiceName% has been started
        exit /b 0
)
SC queryex "%ServiceName%"|Find "STATE"|Find /v "RUNNING">Nul&&(
    echo %ServiceName% is not running, starting now
    if not exist "%SplunkHome%\var\run\telegraf" mkdir "%SplunkHome%\var\run\telegraf"
    xcopy "%SplunkHome%\etc\apps\TA-telegraf-windows64\local\telegraf.conf" "%SplunkHome%\var\run\telegraf\" /K /D /H /Y
    xcopy "%SplunkHome%\etc\apps\TA-telegraf-windows64\bin\telegraf\telegraf.exe" "%SplunkHome%\var\run\telegraf\" /K /D /H /Y
    echo Start %ServiceName%
    Net start "%ServiceName%"
    echo %ServiceName% has been started
    exit /b 0
)||(
    echo "%ServiceName%" is started, stopping now
    Net stop "%ServiceName%"
    if not exist "%SplunkHome%\var\run\telegraf" mkdir "%SplunkHome%\var\run\telegraf"
    xcopy "%SplunkHome%\etc\apps\TA-telegraf-windows64\local\telegraf.conf" "%SplunkHome%\var\run\telegraf\" /K /D /H /Y
    xcopy "%SplunkHome%\etc\apps\TA-telegraf-windows64\bin\telegraf\telegraf.exe" "%SplunkHome%\var\run\telegraf\" /K /D /H /Y
    Net start "%ServiceName%"
    echo %ServiceName% has been started
    exit /b 0
)
