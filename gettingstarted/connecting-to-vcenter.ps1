Set-PowerCLIConfiguration -InvalidCertificateAction Prompt

# this will prompt for credentials
Connect-VIServer -Server vmvcenter.vmlab.local
