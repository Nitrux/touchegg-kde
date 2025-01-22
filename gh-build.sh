#!/bin/bash

### Basic Packages
apt -qq update
apt -qq -yy install axel equivs git devscripts lintian --no-install-recommends

### Install Dependencies
mk-build-deps -i -t "apt-get --yes" -r

### Add configuration for TouchEgg

echo

mkdir -p \
        etc/skel/.config/touchegg \
		etc/xdg/autostart

{
	printf "%s %s\n" \
        touchegg.conf	"https://raw.githubusercontent.com/Nitrux/storage/refs/heads/master/Other/touchegg.conf"
} | {
	while read -r name url; do
		axel -a -n 2 -q -k -U "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.72 Safari/537.36" "$url" -o etc/skel/.config/touchegg/$name
	done
}

touchegg_conf_file='etc/skel/.config/touchegg/touchegg.conf'

sed -i 's+Expose+Overview+g' $touchegg_conf_file

### Check files.

ls -l \
	$touchegg_conf_file \

cat \
	$touchegg_conf_file \

echo

### Build Deb
debuild -b -uc -us

### Move Deb to current directory because debuild decided
### that it was a GREAT IDEA TO PUT THE FILE ONE LEVEL ABOVE
mv ../*.deb .
