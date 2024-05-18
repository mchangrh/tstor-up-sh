#!/usr/bin/env bash

SEARCHDIR="/plugins"

function has_update() {
    local plugin_namespace=$1
    local plugin_name=$2
    local plugin_version=$3
    local plugin_url="https://thunderstore.io/api/experimental/package/${plugin_namespace}/${plugin_name}/"
    api_response=$(curl -s "$plugin_url")
    latest_version=$(echo "$api_response" | jq -r '.latest.version_number')
    if [[ "$plugin_version" != "$latest_version" ]]; then
        echo "Plugin $plugin_name has update: $plugin_version -> $latest_version"
        # download and unzip latest version
        download_url=$(echo "$api_response" | jq -r '.latest.download_url')
        echo "Downloading $download_url"
        wget -q -O /tmp/dl.zip "$download_url"
        unzip -o -q /tmp/dl.zip -d "$SEARCHDIR/$plugin_namespace-$plugin_name-$latest_version"
        # cleanup
        rm /tmp/dl.zip
        rm -rf "$SEARCHDIR/$plugin_namespace-$plugin_name-$plugin_version"
    fi
}

function main() {
    plugin_arr=$(find $SEARCHDIR -type d -maxdepth 1 -exec basename {} \;)
    for plugin_name in ${plugin_arr}; do
        # parse plugin name
        IFS='-' read -ra plugin_vars <<< "$plugin_name"
        echo "Checking for updates for ${plugin_vars[*]}"
        has_update "${plugin_vars[@]}"
    done
}
main