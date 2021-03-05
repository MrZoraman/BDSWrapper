$ErrorActionPreference = "Stop"

$NamesFile = "names.txt"

$Version = Get-Content -Path VERSION
$ImageName = "bds:$Version"

docker build -t $ImageName .

if (Test-Path -Path $NamesFile -PathType leaf)
{
    $names = Get-Content $NamesFile
    ForEach ($name in $names)
    {
        $imageName = ($name + ':' + $Version)
        docker image tag $ImageName ($name + ':' + $Version)
    }
}