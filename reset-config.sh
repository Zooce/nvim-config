#!/bin/sh

rm -rf ~/.local/share/nvim.bak
mv ~/.local/share/nvim{,.bak} 2>/dev/null; true
rm -rf ~/.local/state/nvim.bak
mv ~/.lcoal/state/nvim{,.bak} 2>/dev/null; true
rm -rf ~/.cache/nvim.bak
mv ~/.cache/nvim{,.bak} 2>/dev/null; true
