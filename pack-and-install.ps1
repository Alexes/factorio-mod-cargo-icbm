if (-not (Test-Path .env)) {
    Write-Error "Please copy .env.in and set the values inside"
    exit 1
}
Get-Content .env | Foreach-Object {
    $name, $value = $_.split('=')
    Set-Variable $name $value -Scope Local
}

$VERSION = (Get-Content -Raw info.json | ConvertFrom-Json).version
$MODNAME = (Get-Content -Raw info.json | ConvertFrom-Json).name
$PACKAGE_NAME = "${MODNAME}_${VERSION}"

$TMPDIR = "builds/$PACKAGE_NAME"
New-Item -ItemType "Directory" -Force $TMPDIR
Remove-Item -Recurse $TMPDIR/*

Copy-Item info.json $TMPDIR
Copy-Item control.lua $TMPDIR
Copy-Item thumbnail.png $TMPDIR

cd builds
&$7ZIP_BINARY a -r "$PACKAGE_NAME.zip" $PACKAGE_NAME
cd ..

Copy-Item "builds/$PACKAGE_NAME.zip" $LOCAL_MODFOLDER