#!/bin/sh

RED='\033[0;31m'
NC='\033[0m'

make 2> make-log.log

[ "$?" != 0 ] && echo "${RED}This is unbuildable, please check the output of make in make-log.log${NC}" && exit 1 || exit 0
