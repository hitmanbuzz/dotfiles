#!/bin/bash

chmod +x ./scripts/packages.sh
chmod +x ./scripts/commands.sh
chmod +x ./symlinker

source ./scripts/packages.sh
source ./scripts/commands.sh

./symlinker-linux-amd64 ./links.json
