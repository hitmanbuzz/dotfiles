#!/bin/bash



sudo systemctl start warp-svc.service
sudo systemctl enable --now warp-svc.service
sudo systemctl status warp-svc.service

echo "Warp Service Started..."

warp-cli registration new

echo "warp-cli registration done"
