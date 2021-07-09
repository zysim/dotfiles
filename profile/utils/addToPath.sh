#!/usr/bin/env bash

if [[ $PATH != *"$1"* ]]; then
    export PATH=$PATH:$1
fi
