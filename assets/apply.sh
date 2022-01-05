#!/bin/sh

set -e -o pipefail

MOUNT_TARGET="/usr/palm/applications/com.webos.app.screensaver/qml/main.qml"
QML_PATH="$(dirname "$(realpath "$0")")/screensaver-main.qml"

if [[ ! -f "$MOUNT_TARGET" ]]; then
    echo "[-] Target file does not exist: $MOUNT_TARGET" >&2
    exit 1
fi

if ! findmnt "$MOUNT_TARGET"; then
    mount --bind "$QML_PATH" "$MOUNT_TARGET"
    echo "[+] Enabled succesfully" >&2
else
    echo "[~] Enabled already" >&2
fi
