Set-PowerCLIConfiguration -InvalidCertificateAction Prompt

# this will prompt for credentials
Connect-VIServer -Server yourserver.yourdomain # Enter in your vCenter Server FQDN or IP
