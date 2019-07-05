
@Echo Off
Set ServiceName=telegraf

SC queryex "%ServiceName%"|Find "does not exist">Nul&&(
        Echo "%ServiceName%" is not installed yet, doing now
        "$SPLUNK_HOME\etc\apps\TA-telegraf-windows64\bin\telegraf\telegraf.exe" -service install -config "C:\Program Files\SplunkUniversalForwarder\etc\apps\TA-telegraf-windows64\local\telegraf.conf"
        echo %ServiceName% has been installed
        echo Start %ServiceName%
        Net start "%ServiceName%"
        echo %ServiceName% has been started
        exit /b 0
)
SC queryex "%ServiceName%"|Find "STATE"|Find /v "RUNNING">Nul&&(
    echo %ServiceName% is not running, starting now
    echo Start %ServiceName%
    Net start "%ServiceName%"
    echo %ServiceName% has been started
    exit /b 0    
)||(
    echo "%ServiceName%" is started, stopping now
    Net stop "%ServiceName%"
    Net start "%ServiceName%"
    echo %ServiceName% has been started
    exit /b 0
)
