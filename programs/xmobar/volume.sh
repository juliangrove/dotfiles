volume=$(wpctl status | grep "\*.*vol" | sed -E 's/.*\[vol: ([0-9.]+).*/\1/' | awk '{print int($1*100)}' | sed -n '1p')

mute=$(wpctl status | grep "\*.*\(Speaker\|Headphones\).*vol" |  sed -E 's/.*\[vol: [0-9.]+ ([A-Z]+).*/\1/' | grep "MUTED")

if [[ "$mute" == "MUTED" ]]
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
