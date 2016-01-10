#!/bin/sh

INRES="1280x720" # input resolution
FPS="30" # target FPS
GOP="60" # i-frame interval, should be double of FPS, 
GOPMIN="30" # min i-frame interval, should be equal to fps, 
THREADS="2" # max 6
CBR="2000k" # constant bitrate (should be between 1000k - 3000k)
QUALITY="ultrafast"  # one of the many FFMPEG preset
AUDIO_SRATE="44100"
AUDIO_CHANNELS="2" # 1 for mono output, 2 for stereo
AUDIO_ERATE="96k" # audio encoding rate
SERVER="live-fra" #  http://bashtech.net/twitch/ingest.php for list
source ./secret.sh

ffmpeg -v 0 -f x11grab -s "$INRES" -r "$FPS" -i :0.0 \
  -f alsa -i pulse \
  -f flv -ac $AUDIO_CHANNELS -b:a $AUDIO_ERATE -ar $AUDIO_SRATE \
  -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR \
  -maxrate $CBR -vf "format=yuv420p"\
  -preset $QUALITY -acodec libmp3lame -threads $THREADS -strict normal \
  -bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"
