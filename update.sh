#!/bin/bash
curl_path="/usr/bin/curl"
minecraft_dir="/opt/minecraft"
plugin_dir="$minecraft_dir/data/plugins"
geyser_remote="https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/build/libs"
geyser_name="Geyser-Spigot.jar"
floodgate_remote="https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/build/libs"
floodgate_name="floodgate-spigot.jar"
is_necessary_update=false

geyser_remote_bytes=`$curl_path --silent --head --compressed $geyser_remote/$geyser_name|grep content-length|awk '{printf "%d\n", $2}'`
floodgate_remote_bytes=`$curl_path --silent --head --compressed $floodgate_remote/$floodgate_name|grep content-length|awk '{printf "%d\n", $2}'`
geyser_local_bytes=`ls -al $plugin_dir/$geyser_name | awk '{print $5}'`
floodgate_local_bytes=`ls -al $plugin_dir/$floodgate_name | awk '{print $5}'`

echo "	$geyser_name	$floodgate_name"
echo "local :	$geyser_local_bytes	$floodgate_local_bytes"
echo "remote:	$geyser_remote_bytes	$floodgate_remote_bytes"

if [ $geyser_local_bytes != $geyser_remote_bytes ]; then
	echo "Update prepare"
	is_necessary_update=true
fi
if [ $floodgate_local_bytes != $floodgate_remote_bytes ]; then
	echo "Update prepare"
	is_necessary_update=true
fi
if [ $is_necessary_update != false ]; then
	echo "Update required - $is_necessary_update"
	cd $minecraft_dir
	docker-compose down
	sleep 3;
	docker-compose up -d
else
	echo "Update not necessary"
fi
