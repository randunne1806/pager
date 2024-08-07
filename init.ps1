[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet('amitron', 'local')]
    [string]$Mode,
    
    [Parameter()]
    [ValidateSet('ku')]
    [string]$KubernetesMode
)

$transmitterIpv4 = '192.168.2.240'
$stage1Ipv4 = '192.168.2.59'
$projects = @('pager-log', 'pager-relay', 'pager-view')

switch ($Mode) {
    'amitron' {
        $env:TRANSMITTER_IPV4 = $transmitterIpv4
        $env:REACT_APP_PAGER_LOG_BASE = "http://$stage1Ipv4:8080"
        $env:REACT_APP_PAGER_RELAY_BASE = "http://$stage1Ipv4:5000"
        $env:PAGER_LOG_DB_HOST = $stage1Ipv4
        $env:PAGER_LOG_DB_PORT = 5432
    }
    'local' {
        $env:TRANSMITTER_IPV4 = $transmitterIpv4
        $env:REACT_APP_PAGER_LOG_BASE = 'http://127.0.0.1:8080'
        $env:REACT_APP_PAGER_RELAY_BASE = 'http://127.0.0.1:5000'
        $env:PAGER_LOG_DB_HOST = 'pager-log-db'
        $env:PAGER_LOG_DB_PORT = 5432
    }
    default {
        Write-Host "Usage: $($MyInvocation.MyCommand.Name) -Mode {amitron|local|}"
        exit 1
    }
}

if ($KubernetesMode -eq 'ku') {
    $registryPort = 10000
    $registryBase = 'localhost'
    $registryName = 'local-registry'
    
    $localRegistryExists = docker container ls -a -f "name=$registryName"
    $localRegistryIsOn = docker ps -f "name=$registryName"
    
    if ($registryBase -eq 'localhost') {
        if ([string]::IsNullOrEmpty($localRegistryExists)) {
            docker run -d -p "$registryPort:5000" --name $registryName registry:2
        }
        elseif ([string]::IsNullOrEmpty($localRegistryIsOn)) {
            docker container start $registryName
        }
    }

    foreach ($p in $projects) {
        $imgName = "$registryBase\:$registryPort/$p\:latest"
        docker build -f "$p/Dockerfile" -t $imgName $p
        docker push $imgName
    }
}