$VERSION = "0.0.1"

$TMPDIR = "builds/cargo-icbm_$VERSION"

New-Item -ItemType "Directory" -Force $TMPDIR
Remove-Item -Recurse $TMPDIR/*

Copy-Item info.json $TMPDIR
Copy-Item control.lua $TMPDIR

Compress-Archive -Path $TMPDIR -DestinationPath "$TMPDIR.zip" -Force

Copy-Item "$TMPDIR.zip" C:\Users\alexa\AppData\Roaming\Factorio\mods\