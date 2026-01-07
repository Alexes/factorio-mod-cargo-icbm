$VERSION = (Get-Content -Raw info.json | ConvertFrom-Json).version

$TMPDIR = "builds/cargo-icbm_$VERSION"

New-Item -ItemType "Directory" -Force $TMPDIR
Remove-Item -Recurse $TMPDIR/*

Copy-Item info.json $TMPDIR
Copy-Item control.lua $TMPDIR
Copy-Item thumbnail.png $TMPDIR

Compress-Archive -Path $TMPDIR -DestinationPath "$TMPDIR.zip" -Force
# TODO: replace with 7zip to avoid backslashes in paths, which Factorio.com doesn't accept

Copy-Item "$TMPDIR.zip" C:\Users\alexa\AppData\Roaming\Factorio\mods\