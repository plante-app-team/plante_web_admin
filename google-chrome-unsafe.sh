#!/bin/sh

# Perform ...
# export CHROME_EXECUTABLE=/home/blazern/git/plante_web_admin/google-chrome-unsafe.sh
# ... and then run `android-studio`

/usr/bin/google-chrome-stable --disable-web-security --user-data-dir="A-TEMP-LOCATION" $*
