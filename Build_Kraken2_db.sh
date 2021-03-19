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

usage="$(basename "$0") [-db kraken2_db] [-t threads]\nPossible choices for kraken2_db: archaea, bacteria, plasmid, viral, human, fungi, plant, protozoa, nr, nt, UniVec, UniVec_Core"

while :
do
    case "$1" in
      -h | --help)
          echo -e $usage
          exit 0
          ;;
      -db)
           kraken2_db=$2
           shift 2
           echo "Kraken2 db: $kraken2_db"
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

DB_name=$(echo $kraken2_db"_db" | sed 's/ /_/g')
kraken2-build --download-taxonomy --db $DB_name
kraken2-build --download-library $kraken2_db --db $DB_name
kraken2-build --build --db $DB_name --threads $threads
