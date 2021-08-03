#!/bin/bash

set -x

apt -qq update
apt -qq -yy install equivs git

### Install Dependencies
apt-get -qq --yes update
apt-get -qq --yes install devscripts lintian axel
mk-build-deps -i -t "apt-get --yes" -r

### Add configuration for TouchEgg

echo

mkdir -p \
        etc/skel/.config/touchegg

{
	printf "%s %s\n" \
        touchegg.configuration	"https://raw.githubusercontent.com/NayamAmarshe/ToucheggKDE/main/touchegg.conf"
} | {
	while read name url; do
		axel -a -n 2 -q -k -U "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.72 Safari/537.36" "$url" -o etc/skel/.config/touchegg/$name
	done
}

echo

ls -l \
     etc/skel/.config/touchegg/touchegg.conf

echo

### Build Deb
mkdir source
mv ./* source/ # Hack for debuild
cd source
debuild -b -uc -us