#!/bin/bash

source ~/dotfiles/scripts/packages.sh
source ~/dotfiles/scripts/commands.sh

chmod +x ./symlinker
./symlinker ./config.json
