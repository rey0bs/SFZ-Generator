SFZ soundfont generator
===========================

SFZ Generator is a simple bash script to generate basics sfz soundfonts libraries.

Usage
---------------
    ./generate_sfz.sh /path/to/samples/dir/ /path/to/samples/dir/file.sfz

Configuration
---------------
SFZ Generator configuration is based on files names.
Each file contains its own parameters.

Examples :
If your file is named `/dir/N:HiHat-lokey:62-hikey:64-pitch_keycenter63.wav` :
- `lokey:62` will surcharge "lokey" value in templates/group.txt to generate output sfz.
- `hikey:64` will surcharge "hikey" value in templates/group.txt to generate output sfz.

Each parameters in group.txt can be overridden by this. Each value must be separated by "-" in file name.
