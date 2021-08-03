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
		etc/skel/xdg/autostart

{
	printf "%s %s\n" \
        touchegg.conf	"https://raw.githubusercontent.com/NayamAmarshe/ToucheggKDE/main/touchegg.conf"
} | {
	while read name url; do
		axel -a -n 2 -q -k -U "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.72 Safari/537.36" "$url" -o etc/skel/.config/touchegg/$name
	done
}

sed -i 's+Expose+Parachute+g' etc/skel/.config/touchegg/touchegg.conf
ls -l etc/skel/.config/touchegg/touchegg.conf
cat etc/skel/.config/touchegg/touchegg.conf

### Autostart TouchEgg in daemon mode

>> etc/skel/xdg/autostart/touchegg-start-as-daemon.desktop printf "%s\n" \
	'[Desktop Entry]' \
	'Comment=' \
	'Exec=touchegg --daemon' \
	'GenericName=' \
	'Icon=preferences-desktop' \
	'MimeType=' \
	'Name=touchegg (daemon)' \
	'Path=' \
	'StartupNotify=true' \
	'Terminal=false' \
	'TerminalOptions=' \
	'Type=Application' \
	'X-DBUS-ServiceName=' \
	'X-DBUS-StartupType=' \
	'X-DBUS-SubstitueUID=false' \
	'X-DBUS-Username=' \
	'' 

cat etc/skel/xdg/autostart/touchegg.desktop

### Autostart TouchEgg in client mode

>> etc/skel/xdg/autostart/touchegg.desktop printf "%s\n" \
	'[Desktop Entry]' \
	'Comment=' \
	'Exec=touchegg' \
	'GenericName=' \
	'Icon=preferences-desktop' \
	'MimeType=' \
	'Name=touchegg' \
	'Path=' \
	'StartupNotify=true' \
	'Terminal=false' \
	'TerminalOptions=' \
	'Type=Application' \
	'X-DBUS-ServiceName=' \
	'X-DBUS-StartupType=' \
	'X-DBUS-SubstitueUID=false' \
	'X-DBUS-Username=' \
	'' 

cat etc/skel/xdg/autostart/touchegg.desktop


echo

### Build Deb
mkdir source
mv ./* source/ # Hack for debuild
cd source
debuild -b -uc -us