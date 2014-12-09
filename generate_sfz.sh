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
TOTO="tu"

if [[ -d $1 ]]
then
	cd $SAMPLES_DIR
	if [[ ! -d "$HYDROGEN_DIR/$NAME" ]]
	then
		mkdir -p $HYDROGEN_DIR/$NAME
  fi
 
  regionlist=""
  placeholders=""
  golbal_placeholders=""
  (IFS='
'
  OLD_IFS="$IFS"
  cmpt=0
  for file in $(ls | grep -Ei '\.(ogg|wav|flac)'); do
        IFS='-'
        placeholders=""
        p_array=( ${file%.*} )
        for (( i=0 ; i<${#p_array[*]} ; i++ )) ; do
            echo ${p_array[$i]}
            placeholders=$placeholders";s#"${p_array[$i]%:*}"=[^ ]*#"${p_array[$i]%:*}"="${p_array[$i]#*:}"#g"
        done
        IFS=$OLD_IFS
        global_placeholders="s#__SAMPLE__#"$file"#g"$placeholders
        echo $global_placeholders
	regionlist="$regionlist `cat $SCRIPT_DIR/templates/region.txt | sed -e "$global_placeholders"`"
  done
    echo $regionlist;
  cat $SCRIPT_DIR/templates/group.txt > $OUTPUT
  printf "%s" "$regionlist" >> $OUTPUT
)
else
	echo "Directory $1 is not valid."
  echo "usage: $0 [--key=value] [SAMPLE_DIR] [NAME_OF_DRUMKIT]"
fi
