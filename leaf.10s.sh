#!/bin/sh
#
# <bitbar.title>Leaf Proxy</bitbar.title>
# <bitbar.version>0.1</bitbar.version>
# <bitbar.author>sayo melu</bitbar.author>
# <bitbar.author.github>sayomelu</bitbar.author.github>
# <bitbar.desc>Config Leaf proxy with bitbar.</bitbar.desc>
# <bitbar.abouturl>http://github.com/sayomelu/bitbar-leaf</bitbar.abouturl>
#
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>

toggle() {
	if [ "$state" = 'Enable' ]
	then
		state="Disable"
		icon=":leaf.fill:"
	else
		state="Enable"
		icon=":leaf:"
	fi
	exit
}

config() {
	open /usr/local/share/leaf/config.conf
}

service_install() {
	mkdir /usr/local/share/leaf/
	cd /usr/local/share/leaf/

	# leaf
	curl --tlsv1.2 -LO https://github.com/eycorsican/leaf/releases/latest/download/leaf-x86_64-apple-darwin.gz
	gzip -df leaf-x86_64-apple-darwin.gz
	chmod +x leaf-x86_64-apple-darwin
	mv leaf-x86_64-apple-darwin leaf

	# assets
	curl --tlsv1.2 -o site.dat https://cdn.jsdelivr.net/gh/v2fly/domain-list-community@release/dlc.dat
	curl --tlsv1.2 -o geo.mmdb https://cdn.jsdelivr.net/gh/alecthw/mmdb_china_ip_list@release/Country.mmdb
	touch config.conf

	# launchctl
	curl --tlsv1.2 -LO /Library/LaunchDaemons/bitbar.leaf.plist https://cdn.jsdelivr.net/gh/sayomelu/bitbar-leaf/bitbar.leaf.plist
	launchctl load /Library/LaunchDaemons/bitbar.leaf.plist

	osascript -e 'display notification "Service Installed" with title "Leaf Proxy"'
	exit
}

service_update() {
	# leaf
	curl --tlsv1.2 -LO https://github.com/eycorsican/leaf/releases/latest/download/leaf-x86_64-apple-darwin.gz
	gzip -df leaf-x86_64-apple-darwin.gz
	chmod +x leaf-x86_64-apple-darwin
	mv leaf-x86_64-apple-darwin leaf

	# assets
	curl --tlsv1.2 -o site.dat https://cdn.jsdelivr.net/gh/v2fly/domain-list-community@release/dlc.dat
	curl --tlsv1.2 -o geo.mmdb https://cdn.jsdelivr.net/gh/alecthw/mmdb_china_ip_list@release/Country.mmdb

	osascript -e 'display notification "Service Updated" with title "Leaf Proxy"'
}

service_remove() {
	rm /usr/local/bin/leaf
	rm -rf /usr/local/share/leaf
	osascript -e 'display notification "Service Removed" with title "Leaf Proxy"'
	exit
}

# run param
$1

# echo
state="Enable"
icon=":leaf:"
echo "$icon"
echo "---"
echo "$state | bash=$0 param1=toggle refresh=true terminal=false"
echo "Config | bash=$0 param1=config terminal=false"
echo "Service"
echo "-- Install | bash=$0 param1=service_install"
echo "-- Update | bash=$0 param1=service_update"
echo "-- Remove | bash=$0 param1=service_remove terminal=false"
