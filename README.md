# make-msa 
A small Shell Script that constructs Multiple Sequence Alignment (MSA) from one amino acid sequence by using some command-line tools. 

## Description 

* This script is for making MSA automatically on your terminal. 
* It requires Local-BLAST [1], CD-HIT [2, 3] and MAFFT [4]. 

## Requirements 
This script uses **3** command-line tools below. Please make them executable by setting PATH.

### 1. Local-BLAST 

Version `2.11.0` (or more). 

* Local-BLAST ( https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/ ) 

### 2. CD-HIT 

Version `4.8.1` (or more). 

* CD-HIT ( http://weizhong-lab.ucsd.edu/cd-hit/ ) 

### 3. MAFFT 

Version `7.475` (or more). 

* MAFFT ( https://mafft.cbrc.jp/alignment/software/ ) 

## Workflow 

### 1. Input an amino acid sequence 

In  FASTA format. See some example input files in `demo` directory. 

### 2. Collect similar sequences 

It uses `psiblast` command to collect similar sequences with it's options as follows: 

* `-num_iterations` : 3 
* `-evalue` : 10 
* `-inclusion_ethresh` : 10
* `-seg` : yes 
* `-outfmt` : "6 sseqid"  

Then, based on the output file, Multi-FASTA file is constructed by `blastdbcmd` command.

### 3. Reduce redundancy 

By using CD-HIT, sequence redundancy in the Multi-FASTA file is reduced. All of the CD-HIT options are default.

### 4. Construct MSA 

Finally, MAFFT is executed with `--auto` option. 

## Usage 

### The PATH of Local-BLAST database 

Local-BLAST requires a database  for searching similar sequences. So please type full PATH of your Local-BLAST database to **line 5** of this script. 

```
#!/bin/zsh -eu

#########################################################################################
# Full path of blast+ database. [e.g.] blast_db=/Users/username/blast+/database/swissprot
blast_db= #Type your PATH here.

#########################################################################################

``` 

### Permission setting 

Give it execute permission with any methods.

[e.g.] 

```
% chmod a+x make-msa.sh
``` 
Then, you can run this script (just one parameter, input file name). 

[e.g.] 

```
% ./make-msa ace2_human.fasta
``` 

## References 

1. Altschul, Stephen F., et al. "Basic local alignment search tool." Journal of molecular biology 215.3 (1990): 403-410. 
2. Fu, Limin, et al. "CD-HIT: accelerated for clustering the next-generation sequencing data." Bioinformatics 28.23 (2012): 3150-3152.
3. Li, Weizhong, and Adam Godzik. "Cd-hit: a fast program for clustering and comparing large sets of protein or nucleotide sequences." Bioinformatics 22.13 (2006): 1658-1659. 
4. Katoh, Kazutaka, and Daron M. Standley. "MAFFT multiple sequence alignment software version 7: improvements in performance and usability." Molecular biology and evolution 30.4 (2013): 772-780.
