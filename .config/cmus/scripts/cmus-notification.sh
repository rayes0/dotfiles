#!/bin/bash
script_name=${BASH_SOURCE[0]}
for pid in $(pidof -x $script_name); do
    if [ $pid != $$ ]; then
        kill -9 $pid
    fi 
done

unset ART

TITLE=$(cmus-remote -Q | grep "tag title " | sed "s/tag title //")

ALBUM=$(cmus-remote -Q | grep "tag album " | sed "s/tag album //")

ARTIST=$(cmus-remote -Q | grep "tag artist " | sed "s/tag artist //")

TRACKNUMBER=$(cmus-remote -Q | grep "tag tracknumber " | sed "s/tag tracknumber //")

FOLDER=$(cmus-remote -Q | grep "file" | sed "s/file //" | rev | cut -d"/" -f2- | rev)

FILE=$(cmus-remote -Q | grep "file" | sed "s/file //")

FLIST=$( find "$FOLDER" -type f )

if echo "$FLIST" | grep -i ".jpeg\|.png\|.jpg" &>/dev/null; then
        ART=$( echo "$FLIST" | grep -i "cover.jpg\|cover.png\|front.jpg\|front.png\|folder.jpg\|folder.png" | head -n1 )
else
        ffmpeg -i "$FILE" "$FOLDER/cover.jpg"
        ART="$FOLDER/cover.jpg"
fi

SUMMARY="$ALBUM
By $ARTIST"

sec2min() { printf "%d:%02d" "$((10#$1 / 60))" "$((10#$1 % 60))"; }

TOT_TIME=$( sec2min $(cmus-remote -Q | grep "duration" | cut -d' ' -f2) )

for i in {1..5}
   do
	CUR_TIME=$( sec2min $(cmus-remote -Q | grep "position" | cut -d' ' -f2") )

	TIME="$CUR_TIME/$TOT_TIME"
	
	notify-send -t 1100 -h string:x-canonical-private-synchronous:cmus-notification -i "$ART" "♪ Now Playing:

$TRACKNUMBER - $TITLE" "$SUMMARY

$TIME"
	sleep 0.9
done
