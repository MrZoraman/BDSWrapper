$ErrorActionPreference = "Stop"

$NamesFile = "names.txt"

$Version = Get-Content -Path VERSION

docker build -t "bds" .
docker image tag "bds" "bds:$Version"

if (Test-Path -Path $NamesFile -PathType leaf)
{
    $names = Get-Content $NamesFile
    ForEach ($name in $names)
    {
        $imageName = ($name + ':' + $Version)
        docker image tag "bds" ($name + ':' + $Version)
    }
}