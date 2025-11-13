#!/bin/bash

./aptpac.sh

mkdir -p $HOME/.config
cp -r ./dotfiles/* $HOME/.config

cp -r ./bash $HOME/.local

cp ./scripts/mpip $HOME/.local/bin

./scripts/python/conda.sh
./scripts/python/python.sh
