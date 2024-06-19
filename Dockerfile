FROM mcr.microsoft.com/windows/servercore:ltsc2022

LABEL name="WinRM Windows Container"
LABEL description="This container is a Windows container designed to run a WinRM server."
LABEL maintainer="Peco602 <giovanni1.pecoraro@protonmail.com>"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN $ip = 'localhost'; \
    $cert = New-SelfSignedCertificate -DnsName $ip -CertStoreLocation Cert:\LocalMachine\My; \
    New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $cert.Thumbprint -Force; \
    winrm set winrm/config/service/Auth '@{Basic=\"true\"}'
    
    # winrm create winrm/config/Listener?Address=*+Transport=HTTPS ('@{Hostname=\"'"$ip"'"\; CertificateThumbprint=\"' + $cert.Thumbprint + '\"}'); \
    # winrm create winrm/config/Listener?Address=*+Transport=HTTPS ('@{Hostname=\"dontcare\"; CertificateThumbprint=\"' + $cert.Thumbprint + '\"}'); \
RUN net user User Password12345! /add ; \
    net localgroup Administrators User /add

CMD [ "ping", "localhost", "-t" ]