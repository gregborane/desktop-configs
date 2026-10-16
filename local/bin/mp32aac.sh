#!/bin/bash

#!/bin/bash

for song in *.flac; do
    echo $song
    ffmpeg -i "$song" -c:a aac -vn "${song%.flac}.m4a"
done
