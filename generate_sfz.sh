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
OUTPUT=$1/$2
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MIDI_PARAMS=(lokey hikey pitch_keycenter)

contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 1
        fi
    }
    echo "n"
    return 0
}

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

placeholdersFromFile() {
    if [ "$1" ]
    then
        file=$1
        delimiter='__'
        delimiter2=':'
        placeholders=""
        p_array=($(echo ${file%.*} | sed -e 's/'"$delimiter"'/\n/g' | while read line; do echo $line | sed 's/[\t ]/'"$delimiter"'/g'; done))
        for (( i = 0; i < ${#p_array[@]}; i++ )); do
            element=$(echo ${p_array[i]} | sed 's/'"$delimiter"'/ /')
            name=${element%$delimiter2*}
            value=${element#*$delimiter2}
            if [ "$name" == "K" ]
            then
                re='^[0-9A-Zb#]+-[0-9A-Zb#]+$'
                if [[ $value =~ $re ]] ; then
                    placeholders=$placeholders";s/lokey=[^ ]*/lokey="$(toMidi "${value%-*}")"/g"
                    placeholders=$placeholders";s/hikey=[^ ]*/hikey="$(toMidi "${value#*-}")"/g"
                else
                    for param in ${MIDI_PARAMS[@]} ; do
                        note=$(toMidi "$value")
                        placeholders=$placeholders";s/"$param"=[^ ]*/"$param"="$note"/g"
                    done
                fi
            else
                if [ $(contains "${MIDI_PARAMS[@]}" "$name") == "y" ]; then
                    value=$(toMidi "$value")
                fi
                placeholders=$placeholders";s/"$name"=[^ ]*/"$name"="$value"/g"
            fi
        done
        if ! [[ -d $1 ]]
        then
            placeholders="s|__SAMPLE__|"$2$file"|g"$placeholders
        fi
        echo $placeholders
    fi
}

generateSection() {
    if [[ -d $1 ]]
    then
        placeholders=$(placeholdersFromFile "$1")
        printf "%s" $'\r\n\r\n'"`cat $SCRIPT_DIR/templates/group.txt | sed -e "$placeholders"`"$'\r\n\r\n'
        for file in $(ls "$1"); do
            printf "%s" "$(generateSection "$file" "$1/")"
        done
    else
        re='\.(ogg|wav|flac|mp3)$'
        if [[ $1 =~ $re ]] ; then
            placeholders=$(placeholdersFromFile "$1" "$2")
            printf "%s" "`cat $SCRIPT_DIR/templates/region.txt | sed -e "$placeholders"`"$'\r\n\r\n'
        fi
    fi
}

if [[ -d $1 ]]
then
    cd $SAMPLES_DIR
    (IFS='
    '
    > $OUTPUT
    for file in $(ls "$1"); do
        sfz=$(printf "%s" "$(generateSection "$file")")
        printf "%s" "$sfz" >> $OUTPUT
        printf "%s" "$sfz"
    done
    )
else
    echo "Directory $1 is not valid."
    echo "usage: $0 [--key=value] [SAMPLE_DIR] [OUTPUT_FILE]"
fi
