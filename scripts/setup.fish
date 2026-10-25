#!/usr/bin/env fish

chmod +x ./scripts/packages.fish
chmod +x ./scripts/config.fish
chmod +x ./bin/symlinker-linux-amd64

source ./scripts/packages.fish
source ./scripts/config.fish

./bin/symlinker-linux-amd64 ./links.json
