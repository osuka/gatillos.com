#!/bin/bash
mplayer -user-agent Mozilla "https://translate.google.com/translate_tts?tl=en&q=$(echo $* | sed 's#\ #\+#g')" > /dev/null 2>&1 ;
