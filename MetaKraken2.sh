
#
# Copyright 2021 Simone Maestri. All rights reserved.
# Simone Maestri <simone.maestri@univr.it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

#!/bin/bash


usage="$(basename "$0") [-f fastq_reads] [-db kraken2_db] [-t threads]"

while :
do
    case "$1" in
      -h | --help)
          echo $usage
          exit 0
          ;;
      -f)
          fastq_reads=$(realpath $2)
          shift 2
          echo "Fastq reads: $fastq_reads"
          ;;
      -db)
           kraken2_db=$2
           shift 2
           echo "Kraken2 indexed db: $kraken2_db"
           ;;
      -t)
           threads=$2
           shift 2
           echo "Threads: $threads"
           ;;

       --) # End of all options
           shift
           break
           ;;
       -*)
           echo "Error: Unknown option: $1" >&2
           ## or call function display_help
           exit 1
           ;;
        *) # No more options
           break
           ;;
    esac
done


SAMPLE_NAME=$(echo $(basename $fastq_reads) | sed 's/\.fast.*//')
WORKING_DIR=$(dirname $fastq_reads)
THREADS=$threads
KRAKEN2=kraken2
KRONA=ktImportTaxonomy

KRAKEN2_OUTPUT=$WORKING_DIR"/"$SAMPLE_NAME"_kraken2_output.txt"
KRAKEN2_REPORT=$WORKING_DIR"/"$SAMPLE_NAME"_kraken2_report.txt"
KRONA_REPORT=$WORKING_DIR"/"$(echo $(basename $KRAKEN2_OUTPUT) | sed 's/\.*$/_Krona_report.html/' | sed 's/\.txt//')

$KRAKEN2 --db $kraken2_db --output $KRAKEN2_OUTPUT --report $KRAKEN2_REPORT --threads $threads $fastq_reads
$KRONA -q 2 -t 3 -s 4 $KRAKEN2_OUTPUT -o $KRONA_REPORT
