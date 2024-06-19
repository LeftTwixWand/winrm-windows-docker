$TAG = "winrm:ltsc2022"
$NAME = "winrm_server"
$USERNAME = "User"
$PASSWORD = "Password12345!"

# docker network create --subnet=172.18.0.0/16 mynetwork

# docker network create --subnet=172.18.0.0/16 --driver nat mynetwork

# Write-Host "[+] Building docker image" -ForegroundColor green
docker build -t $TAG .

# Write-Host "[+] Running container" -ForegroundColor green
docker run --net mynetwork --ip 172.18.0.22 -d --name $NAME $TAG

Write-Host "[+] Connecting to container via WinRM" -ForegroundColor green
# $IP = docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" $NAME
$IP = '172.18.0.22'
$CRED = New-Object PSCredential $USERNAME, (ConvertTo-SecureString -String $PASSWORD -AsPlainText -Force)
Enter-PSSession -Credential $CRED -ComputerName $IP -Authentication Basic -UseSSL -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck)


# $USERNAME = "User"
# $PASSWORD = "Password12345!"
# $IP = 172.18.0.22
# $CRED = New-Object PSCredential $USERNAME, (ConvertTo-SecureString -String $PASSWORD -AsPlainText -Force)
# Enter-PSSession -Credential $CRED -ComputerName $IP -Authentication Basic -UseSSL -SessionOption (New-PSSessionOption -SkipCACheck -SkipCNCheck)