#!/bin/bash
#jekyll

cd ..
if [ -d "_site" ] ; then
  rsync -avz --delete -e ssh _site/ mapgog@gatillos.com:gatillos.com/yay
else
  echo "Site (_site/) directory not found - aborting."
fi

if [ ! -f "$(which say)" ] ; then
  say(){ mplayer -user-agent Mozilla "https://translate.google.com/translate_tts?tl=en&q=$(echo $* | sed 's#\ #\+#g')" > /dev/null 2>&1 ; }
fi

say "Uploaded."
