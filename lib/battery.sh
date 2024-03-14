#!/bin/bash
echo $(pmset -g ps | grep -Eo '\d+\%')
