SFZ soundfont generator
===========================

SFZ Generator is a simple bash script to generate basics sfz soundfonts libraries.

##Usage
    ./generate_sfz.sh /path/to/samples/dir/ file.sfz

`'file.sfz'` file will be placed in `'/path/to/samples/dir/'` folder to avoid relative path errors.

##Configuration
SFZ Generator configuration is based on files names.
Each file contains its own parameters.

###Basic parameters
If your file is named `/dir/HiHat__lokey:62__hikey:64__pitch_keycenter:63.wav` :
- `lokey:62` will surcharge `'lokey'` value in `templates/group.txt` to generate output sfz.
- `hikey:64` will surcharge `'hikey'` value in `templates/group.txt` to generate output sfz.

Each parameters in `group.txt` can be overridden by this. Each value must be separated by `"__"` (two `'_'`) in file name.

###Special parameters
* **K:<note>** : Note key. It can be a MIDI number (like '60') or a note (like 'C#3'). It will set `'lokey'`, `'hikey'` and `'pitch_keycenter'` values.
* **K:<note>-<note>** : Note range. It will set `'lokey'` and `'hikey'` values. If it is used for files, `'pitch_keycenter'` must be setted (`'__pitch_keycenter:<note>'`)

###Examples
```
/
├── samples/
│   ├── drum__K:C2-B2/
│   │   ├── Kick__K:C2.wav
│   │   ├── Kick2__K:C#2.wav
│   │   ├── Snare__K:D2.wav
│   │   ├── HiHatClosed__K:F#2.wav
│   │   ├── HiHatOpen__K:G#2.wav
│   ├── piano__K:C3-B3/
│   │   ├── K:C2.wav
│   │   ├── K:C#2.wav
│   │   ├── K:D2.wav
│   │   ├── K:D#2-G2__pitch_keycenter:E2.wav
...
```
`./generate_sfz.sh /samples/ mySoundFont.sfz`

