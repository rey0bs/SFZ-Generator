#!/bin/bash
declare -A replaces
while [ $# -gt 0 ]
do
      case "$1" in
              --*)  parameter=${1#--}
                    key=${parameter%=*}
                    value=${parameter#*=}
                    replaces[${key}]=${value}
                    ;;
              -*)
                echo >&2 \
                   "usage: $0 [--key=value] [SAMPLES_DIR] [OUTPUT_FILE]"
                exit 1;;
              *)  break;;
      esac
      shift
done

SAMPLES_DIR=$1
OUTPUT=$2
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

toMidi() {
    if [ "$1" ]
    then
        re='^[0-9]+$'
        if [[ $1 =~ $re ]] ; then
            echo "$1"
        else
            declare -A notes
            notes["C"]=0
            notes["C#"]=1
            notes["Db"]=1
            notes["D"]=2
            notes["D#"]=3
            notes["Eb"]=3
            notes["E"]=4
            notes["F"]=5
            notes["F#"]=6
            notes["Gb"]=6
            notes["G"]=7
            notes["G#"]=8
            notes["Ab"]=8
            notes["A"]=9
            notes["A#"]=10
            notes["Bb"]=10
            notes["B"]=11
            note=$(echo $1 | sed 's/[0-9]*//g')
            octave=$(echo $1 | sed 's/[^0-9]*//g')
            echo $((${notes[$note]}+12*(2+$octave)))
        fi
    fi
}

if [[ -d $1 ]]
then
	cd $SAMPLES_DIR
	if [[ ! -d "$HYDROGEN_DIR/$NAME" ]]
	then
		mkdir -p $HYDROGEN_DIR/$NAME
  fi
 
  placeholders=""
  (IFS='
'
  OLD_IFS="$IFS"
  cmpt=0
  cat $SCRIPT_DIR/templates/group.txt > $OUTPUT
  for file in $(ls | grep -Ei '\.(ogg|wav|flac)'); do
        IFS='-'
        placeholders=""
        p_array=( ${file%.*} )
        for (( i=0 ; i<${#p_array[*]} ; i++ )) ; do
            echo ${p_array[$i]}
            if [ "${p_array[$i]%:*}" == "K" ]
            then
                for ph in lokey hikey pitch_keycenter ; do
                    note=$(toMidi "${p_array[$i]#*:}")
                    placeholders=$placeholders";s/"$ph"=[^ ]*/"$ph"="$note"/g"
                done
            else
                placeholders=$placeholders";s/"${p_array[$i]%:*}"=[^ ]*/"${p_array[$i]%:*}"="${p_array[$i]#*:}"/g"
            fi
        done
        IFS=$OLD_IFS
        placeholders="s/__SAMPLE__/"$file"/g"$placeholders
        printf "%s" "`cat $SCRIPT_DIR/templates/region.txt | sed -e "$placeholders"`"$'\r\n\r\n' >> $OUTPUT
  done
  cat $OUTPUT
)
else
	echo "Directory $1 is not valid."
  echo "usage: $0 [--key=value] [SAMPLE_DIR] [OUTPUT_FILE]"
fi
