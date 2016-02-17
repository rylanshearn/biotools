#!/bin/bash
# ---------------------------------------------------------------------------
# subsetfastq.sh - takes a random subset of paired reads from files

# Copyright 2016, Rylan Shearn,,, <rylan@umr5558-15746>
  
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.

# Usage: subsetfastq.sh [-h|--help] <forward fastq> <reverse fastq>

# Revision history:
# 2016-02-17 Created by newscript ver. 3.3
# ---------------------------------------------------------------------------

PROGNAME=${0##*/}
VERSION="0.1"
forward=$1 #forward reads fastq file
reverse=$2 #reverse reads fastq file

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
  echo -e "Usage: $PROGNAME [-h|--help] <forward fastq> <reverse fastq>"
}

help_message() {
  cat <<- _EOF_
  $PROGNAME ver. $VERSION
  takes a random subset of paired reads from files

  $(usage)

  Options:
  -h, --help  Display this help message and exit.

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
    -* | --*)
      usage
      error_exit "Unknown option $1" ;;
    *)
      echo "Argument $1 to process..." ;;
  esac
  shift
done

# Main logic

paste <(zcat $forward) <(zcat $reverse) |\ #merge the two fastqs
awk '{ printf("%s",$0); n++; if(n%4==0) { printf("\n");} else { printf("\t\t");} }' |\ #merge by group of 4 lines
shuf  |\ #shuffle
head |\ #only 10 records
sed 's/\t\t/\n/g' |\ #restore the delimiters
awk '{print $1 > "file1.fastq"; print $2 > "file2.fastq"}' #split in two files.


graceful_exit

