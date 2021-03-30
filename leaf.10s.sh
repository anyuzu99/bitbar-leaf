#!/bin/sh
#
# <bitbar.title>Leaf Proxy</bitbar.title>
# <bitbar.version>0.1</bitbar.version>
# <bitbar.author>sayo melu</bitbar.author>
# <bitbar.author.github>sayomelu</bitbar.author.github>
# <bitbar.desc>Config Leaf proxy with bitbar.</bitbar.desc>
# <bitbar.abouturl>https://github.com/sayomelu/bitbar-leaf</bitbar.abouturl>
#
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# state=$(launchctl print system/bitbar.leaf | grep state)

interface="wi-fi"
state=$(networksetup -getsocksfirewallproxy $interface | grep No)

toggle() {
	if [ -n "$state" ]; then
		networksetup -setsocksfirewallproxystate $interface on
	else
		networksetup -setsocksfirewallproxystate $interface off
	fi
}

config() {
	open /usr/local/share/leaf/config.conf
	exit
}

update() {
	# leaf
	curl --tlsv1.2 -LO https://github.com/eycorsican/leaf/releases/latest/download/leaf-x86_64-apple-darwin.gz
	gzip -df leaf-x86_64-apple-darwin.gz
	chmod +x leaf-x86_64-apple-darwin
	mv leaf-x86_64-apple-darwin leaf

	# assets
	curl --tlsv1.2 -o site.dat https://cdn.jsdelivr.net/gh/v2fly/domain-list-community@release/dlc.dat
	curl --tlsv1.2 -o geo.mmdb https://cdn.jsdelivr.net/gh/Hackl0us/GeoIP2-CN@release/Country.mmdb

	osascript -e 'display notification "Service Updated" with title "Leaf Proxy"'
	exit
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

service_uninstall() {
	rm /usr/local/bin/leaf
	rm -rf /usr/local/share/leaf
	osascript -e 'display notification "Service Uninstalld" with title "Leaf Proxy"'
	exit
}

# run param
$1

if [ "$state" ]; then
	state="Enable"
	icon=":leaf:"
else
	state="Disable"
	icon=":leaf.fill:"
fi

# echo
echo "$icon"
echo "---"
echo "$state Leaf | bash=$0 param1=toggle refresh=true terminal=false"
echo "View Config | bash=$0 param1=config terminal=false"
echo "Check for Updates... | bash=$0 param1=update terminal=false"
echo "Service"
echo "-- Install | bash=$0 param1=service_install"
echo "-- Uninstall | bash=$0 param1=service_uninstall terminal=false"
