#!/bin/bash

./aptpac.sh

mkdir -p $HOME/.config
cp -r ./dotfiles/* $HOME/.config
ln -s $HOME/.config/tmux.conf ~/.tmux.conf

cp -r ./bash $HOME/.local
cp -f .profile .bashrc .gaussianrc .XCompose $HOME

cp ./scripts/mpip $HOME/.local/bin

./scripts/python/conda.sh
./scripts/python/python.sh
