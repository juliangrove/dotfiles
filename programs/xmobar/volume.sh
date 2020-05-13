volume=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 2 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')

mute=$(pactl list sinks | grep '^[[:space:]]Mute:' |     head -n $(( $SINK + 2 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')

if [[ "$mute" == "	Mute: yes" ]]
then printf "<fc=#a89984></fc>"
else if (( $volume >= 75 ))
     then printf "<fc=#b8bb26></fc>"
     else if (( $volume >= 25 ))
	  then printf "<fc=#b8bb26></fc>"
	  else printf "<fc=#b8bb26></fc>"
	  fi
     fi
fi

printf " <fn=2><fc=#ebdbb2>"
printf $volume
printf "%%</fc></fn>"
