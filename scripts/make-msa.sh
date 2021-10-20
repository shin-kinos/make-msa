#!/bin/zsh -eu

#########################################################################################
# Full path of blast+ database. [e.g.] blast_db=/Users/username/blast+/database/swissprot
blast_db=

#########################################################################################

# Check parameter set.
if [ $# -ne 1 ]; then
    echo "ERROR : One paramator set."
    exit 1
fi

if [ -f $1 ]; then
    echo "Input filename : "$1
else
    echo "ERROR : The input file does not exist."
    exit 1
fi

# Make an directory for output data.
directory_output=`date "+%Y%m%d%H%M"`
mkdir $directory_output

# Copy the input file into $directory_output
cp $1 ./$directory_output

cd ./$directory_output

# blast+ arguments.
blast_input=$1
blast_num_iterations=3
blast_evalue=10

# Run blast+
psiblast \
-query             $blast_input \
-db                $blast_db \
-num_iterations    $blast_num_iterations \
-evalue            $blast_evalue \
-seg               yes \
-outfmt            "6 sseqid" \
-inclusion_ethresh $blast_evalue \
-out               blast.output

# Remove duplication of 'blast.output'.
blastdbcmd_input=`cat blast.output | sort | uniq`
echo $blastdbcmd_input > blast.output
#cat blast.output

# Get Multi-FASTA file by using blastdbcmd.
blastdbcmd \
-dbtype      prot \
-db          $blast_db \
-entry_batch blast.output \
-out         blast.output.fasta

# Reduce redundancy with CD-HIT.
cd-hit \
-i blast.output.fasta \
-o cdhit.output.fasta \
-c 0.9

# Define MAFFT output filename.
mafft_output=`echo "aligned_"$blast_input`
echo $mafft_output

# Construct MSA with MAFFT
mafft \
--auto \
cdhit.output.fasta > $mafft_output 

echo "\n'"$mafft_output"' was generated in '"$directory_output"' directory !!!"
