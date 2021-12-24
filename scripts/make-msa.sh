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
blast_evalue=10e-5
#blast_num_iterations=3

# Run blast+
#psiblast \
blastp \
-query             $blast_input \
-db                $blast_db \
-evalue            $blast_evalue \
-seg               yes \
-outfmt            "6 sseqid" \
-out               blast.output
#-num_iterations    $blast_num_iterations \
#-inclusion_ethresh $blast_evalue \

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
-c 0.7

# Overwrite the input file (query sequence) to 'cdhit.output.fasta'
cat $1 >> cdhit.output.fasta

# Define MAFFT output filename.
mafft_output=`echo "aligned_"$blast_input`
echo $mafft_output

# Construct MSA with MAFFT
mafft \
--auto \
cdhit.output.fasta > $mafft_output 

echo "\n'"$mafft_output"' was generated in '"$directory_output"' directory !!!"
