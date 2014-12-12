SFZ soundfont generator
===========================

SFZ Generator is a simple bash script to generate basics sfz soundfonts libraries.

##Usage
    ./generate_sfz.sh /path/to/samples/dir/ /path/to/samples/dir/file.sfz

##Configuration
SFZ Generator configuration is based on files names.
Each file contains its own parameters.

###Basic parameters
If your file is named `/dir/HiHat__lokey=62__hikey=64__pitch_keycenter=63.wav` :
- `lokey=62` will surcharge "lokey" value in templates/group.txt to generate output sfz.
- `hikey=64` will surcharge "hikey" value in templates/group.txt to generate output sfz.

Each parameters in group.txt can be overridden by this. Each value must be separated by `"__"` (two `'_'`) in file name.

###Special parameters
* **K** : Note key. Can be a MIDI number (like '60') or a note (like 'C#3'). This will be override 'lokey', 'hikey' and 'pitch_keycenter' values.

###Examples
`
/
├── samples/
│   ├── drum/
│   │   ├── Kick__K=C2.wav
│   │   ├── Kick2__K=C#2.wav
│   │   ├── Snare__K=D2.wav
│   │   ├── HiHatClosed__K=F#2.wav
│   │   ├── HiHatOpen__K=G#2.wav
│   ├── piano/
│   │   ├── K=C2.wav
│   │   ├── K=C#2.wav
│   │   ├── K=D2.wav
...
`
`./generate_sfz.sh /samples/drum/ /samples/drum/drum.sfz`
`./generate_sfz.sh /samples/piano/ /samples/drum/piano.sfz`



