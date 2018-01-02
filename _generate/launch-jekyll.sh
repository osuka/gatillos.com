#!/bin/bash

# The timezone can't change, otherwise post links can vary.
#
# example: if a post is set to 20/1/2011 22:00 UTC and your OS TZ is GMT+2,
# the generated post will be in day later, 21/1/2012. That's fine as long
# you launch the generation from a server that is always in the same TZ
# - hard to do if you travel a lot
# solution: force TZ

#if [ ! -d "_generate" ] ; then
#  cd ..
#fi

# i found this bug initially with this date
test="2010-08-15 22:26:09 +0200"
test="2010-08-15 22:26:09"
test1=`ruby -e "require 'date'; puts DateTime.parse('${test}').to_time.strftime('%Y/%m/%d')"`
test2=`TZ="CET" ruby -e "require 'date'; puts DateTime.parse('${test}').to_time.strftime('%Y/%m/%d')"`

echo "$test1 == $test2?"
if [ "$test1" != "$test2" ]; then
  echo "got you!"
  echo "- running jekyll with TZ should fix it..."
fi

#TZ="CET" jekyll $@
TZ="CET" jekyll build -s .. -d ../_site

if [ ! -f "$(which say)" ] ; then
  # https://www.commandlinefu.com/commands/view/8087/google-text-to-speech-in-mp3-format
  say(){ mplayer -user-agent Mozilla "https://translate.google.com/translate_tts?tl=en&q=$(echo $* | sed 's#\ #\+#g')" > /dev/null 2>&1 ; }
fi

say 'Done.'
