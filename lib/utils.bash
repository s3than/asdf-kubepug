#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for kubepug.
GH_REPO="https://github.com/rikatz/kubepug"
TOOL_NAME="kubepug"
TOOL_TEST="kubepug --help"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if <YOUR TOOL> is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # TODO: Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if <YOUR TOOL> has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local url=$(get_download_url $version)

  echo "* Downloading $TOOL_NAME release $version..."
  echo $url
  echo $filename
  wget --quiet "$url" -O "$filename" || fail "Could not download $url"
}

get_download_url() {
  local version="$1"
  local platform="$(get_platform)"
  local arch="$(get_arch)"
  # https://github.com/rikatz/kubepug/releases/download/v1.3.2/kubepug_linux_amd64.tar.gz
  echo "$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${platform}_${arch}.tar.gz"
}

get_platform() {
  uname | tr '[:upper:]' '[:lower:]'
}

get_arch() {
  local arch=$(uname -m)
  [ "$arch" = "x86_64" ] && arch="amd64"
  echo "$arch"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path/bin"
    cp -r "$ASDF_DOWNLOAD_PATH/$TOOL_NAME" "$install_path/bin/"

    # TODO: Asert <YOUR TOOL> executable exists.
    local tool_cmd
    tool_cmd="$TOOL_TEST"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
