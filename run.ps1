New-Item -Path 'world' -ItemType Directory -Force

$world = Join-Path -Path (Convert-Path .) -ChildPath "world"

docker run `
    --interactive `
    --tty `
    --rm `
    --name bds `
    --mount "type=bind,source=$world,target=/opt/bds/worlds" `
    -p 127.0.0.1:19132:19132/udp `
    bds:latest