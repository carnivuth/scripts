#!/bin/bash
ollama list | tail -n +2 | awk -F' ' '{print $1}' | while read model; do ollama rm "$model"; done
