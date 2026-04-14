#!/bin/bash

# This script is to take an input file and make it compatible video for different platform and the 2nd argument as the output video file name

ffmpeg -i $1 -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p -c:a aac -ac 2 -b:a 128k -movflags +faststart $2

