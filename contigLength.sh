#!/bin/bash
# ---------------------------------------------------------------------------
# contigLength.sh - returns the length of contigs in a .fasta file

# Copyright 2015, Rylan Shearn,,, <rylan@umr5558-15746>
  
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.

# Usage: contigLength.sh [-h|--help] [-n|--names] [-l|--list] input.fasta output.txt

# Revision history:
# 2015-11-26 Created by newscript ver. 3.3
# ---------------------------------------------------------------------------

PROGNAME=${0##*/}
VERSION="0.1"
input=$2 #input fasta file
output=$3 #output fasta file

clean_up() { # Perform pre-exit housekeeping
  return
}

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  clean_up
  exit 1
}

graceful_exit() {
  clean_up
  exit
}

signal_exit() { # Handle trapped signals
  case $1 in
    INT)
      error_exit "Program interrupted by user" ;;
    TERM)
      echo -e "\n$PROGNAME: Program terminated" >&2
      graceful_exit ;;
    *)
      error_exit "$PROGNAME: Terminating on unknown signal" ;;
  esac
}

usage() {
  echo -e "Usage: $PROGNAME [-h|--help] [-n|--names] [-l|--list] input.fasta output.txt"
}

help_message() {
  cat <<- _EOF_
  $PROGNAME ver. $VERSION
  returns the length of contigs in a .fasta file

  $(usage)

  Options:
  -h, --help  Display this help message and exit.
  -n, --names  lists names before each contig length
  -l, --list  lists contig lengths without names

_EOF_
  return
}

# Trap signals
trap "signal_exit TERM" TERM HUP
trap "signal_exit INT"  INT



# Parse command-line
while [[ -n $1 ]]; do
  case $1 in
    -h | --help)
      help_message; graceful_exit ;;
    -n | --names)
      echo "listing names before each contig length" ; print="; print" ;;
    -l | --list)
      echo "listing contig lengths without names" ; print="" ;;
    -* | --*)
      usage
      error_exit "Unknown option $1" ;;
    *)
      echo "Argument $1 to process..." ;;
  esac
  shift
done

# Main logic

awk "/^>/ {if (seqlen){print seqlen}$print ;seqlen=0;next; } { seqlen = seqlen +length($1)}END{print seqlen}" $input > $output

graceful_exit

