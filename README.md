# biotools
- Scripts for analysis and manipulation of sequence data
- detailed descriptions are given for each script below

##randfasta.pl
###Description
- Takes in a fasta file and returns a subset based on the number of sequences specified 
- Obviously you need to know how many sequences are in the original file with `wc -l filename.fasta`

###Usage
```sh
./randfasta.pl seqNumber < input.fasta > output.fasta
```

##contigLength.sh
###Description
- Takes a fasta file and returns a list of numbers that represent the lengths of each sequence in the fasta file
- It's an awk based script so if you need to pipe it elsewhere, just grab the awk command'

###Usage
```sh
./contigLength.sh [-h|--help] input.fasta output.txt
```
##fastaOneLinePerSequence.pl
###Description
- Takes a fasta file and returns the same fasta file, only with one line per sequence
- You only need to specify an input file, the output file will be generated in the same direcory with the **.propre** suffix

###Usage
```sh
./fastaOneLinePerSequence.pl input.fasta
```

##pickContigs.sh
###Description
- Takes a list of contig names and pulls them out of a fasta file
- The fasta file should have one line per sequence (if not see the above script!)
- The list should be a plain text file, with each line representing the name of the sequence you want from the fasta file
- For example:
```
sequence1
sequence2
sequence3
sequence4
sequence5
```

###Usage
```sh
./pickContigs.sh [-h|--help] inputFile contigList outputFile
```

##subsetfastq.py
###Description
- Takes illumina paired end fastq files, and randomly picks sequences to be put into two subset files based on the fraction of the file you want to keep
- Although sampling is random, each pair is always maintained

###Requirements
- For this script to run, you need to have a number of python packages installed. Assuming you are running Ubuntu, do:
```sh
sudo apt-get install build-essential python2.7-dev python-numpy python-matplotlib
```

###Usage
```sh
python /path/to/subsetfastq.py fraction(0-1) forward.fastq reverse.fastq forward.sub.fastq reverse.sub.fastq
```
