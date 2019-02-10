#!/bin/bash

# Sample command to create Pixlr-compatible sprite sheets
# 
# Usage: ./build-sprite-sheet.sh <sprite sheet name> <source folder>

TexturePacker --texture-format png --format pixlr --sheet "$1.png" --data "$1.json" --classfile-file "$1.swift" $2
