#!/bin/bash

for EXT in jpg png; do
	find ./static/images/moments/ -type f -name "*.${EXT}" \
		| grep -v thumb \
		| while read SRC; do
			DST="$(echo ${SRC} | sed "s/${EXT}\$/thumb.${EXT}/")"
			if [ ! -e "${DST}" ]; then
				convert ${SRC} -resize "200x200" -gravity center -background white -extent 200x200 ${DST}
			fi
		done
done
