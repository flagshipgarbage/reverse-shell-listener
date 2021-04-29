# reverse-shell-listener
A simple PowerShell reverse shell listener

# Usage
```PowerShell
.\reverse-shell-listener.ps1 192.168.1.1 443 # Listen Address and Port
.\reverse-shell-listener.ps1 -i 192.168.1.1  -p 443
.\reverse-shell-listener.ps1 -IPAddress 192.168.1.1 -Port 443

-IPAdress(or -i): Listening IP
-Port(or -p): Listening Port 
```
