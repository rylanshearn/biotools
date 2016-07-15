#!/usr/bin/env python

def fastadiff(file1, file2):
    '''
    takes two text files as input (only tested on fasta format)
    checks whether sequence names in one file are present
    in the other
    Assumes that there is only one line per sequence in 
    the input files
    usage:
    ./fastadiff file1.fasta file2.fasta output.txt
    '''
    #make count 0
    count = 0
    #number of oddline
    oddcount = 0
    #number of matches
    matchcount = 0
    #open file1 line by line (avoid clogging memory)
    with open(file1) as f1:
        #for every line
        for line in f1:
            #add to count
            count +=1
            #if line number is not even:
            if count % 2 != 0:
                #add to oddcount
                oddcount += 1
                #iterate through file2
                with open(file2) as f2:
                    for line2 in f2:
                        #if a line matches comparison in file 2
                        if line == line2:
                            #add to match count
                            matchcount += 1
                            print line,
    print 'Summary:'
    print str(matchcount) + ' out of ' + str(oddcount) + ' sequence names in file 1 were present in file 2'

#load sys module (for passing arguments from cmd line)
import sys

#output file
out = open(sys.argv[3], 'w')
#run function with first two arguments	
fastadiff(sys.argv[1], sys.argv[2])
