#!/bin/sh
# Apply (or remove) the custom screensaver.
#
# Two generations of the stock screensaver are supported:
#
#  - qml (legacy): the screensaver app ships qml/main.qml and we bind our
#    screensaver-main.qml over it. This is the historical mode.
#
#  - flutter (webOS 10 and later): the screensaver app is a native flutter
#    bundle with no qml/ at all, so there is nothing to bind over. Instead we
#    stage a full qml app (the stock appinfo converted to type qml plus our
#    screensaver-main.qml) in /var/lib/webosbrew/custom-screensaver/ and bind
#    the whole staged directory over the app directory.
#
# Both paths are idempotent and revertible: `apply.sh remove` unmounts our
# bind and restores the stock screensaver without a reboot.
#
# Usage: apply.sh [apply|remove]

set -e

APP=/usr/palm/applications/com.webos.app.screensaver
STAGE=/var/lib/webosbrew/custom-screensaver
MARKER="$STAGE/.applied"
QML_PATH="$(dirname "$(realpath "$0")")/screensaver-main.qml"
APPINFO="$APP/appinfo.json"

is_bound() {
    # true when something is bind-mounted over the app directory
    mount | grep -F " on $APP " >/dev/null 2>&1
}

# Best effort: ask sam to re-read the screensaver app so the switch takes
# without a restart. Harmless no-op where the bus or the methods are absent.
refresh_sam() {
    command -v luna-send >/dev/null 2>&1 || return 0
    luna-send -n 1 luna://com.webos.applicationManager/blockSystemApp \
        '{"id":"com.webos.app.screensaver","forceBlockSystemApp":false}' \
        >/dev/null 2>&1 || true
    sleep 1
    luna-send -n 1 luna://com.webos.applicationManager/unblockSystemApp \
        '{"id":"com.webos.app.screensaver","forceBlockSystemApp":false}' \
        >/dev/null 2>&1 || true
}

do_remove() {
    if [ ! -f "$MARKER" ]; then
        echo "[~] Not applied (no $MARKER); nothing to remove" >&2
        exit 0
    fi
    if is_bound; then
        # A bind over qml/main.qml (legacy mode, or ours stacked over a foreign
        # dir bind) must come off before the directory bind will release.
        umount "$APP" 2>/dev/null || {
            umount "$APP/qml/main.qml" 2>/dev/null || true
            umount "$APP" 2>/dev/null || {
                echo "[-] Could not unmount $APP" >&2
                exit 1
            }
        }
    fi
    rm -f "$MARKER"
    refresh_sam
    echo "[+] Stock screensaver restored"
    exit 0
}

[ "$(id -u)" = 0 ] || { echo "[-] needs root" >&2; exit 1; }
[ -f "$QML_PATH" ] || { echo "[-] Replacement file does not exist: $QML_PATH" >&2; exit 1; }
[ -f "$APPINFO" ] || { echo "[-] Screensaver appinfo not found: $APPINFO" >&2; exit 1; }

case "${1:-apply}" in
    remove) do_remove ;;
    apply|"") ;;
    *) echo "usage: $0 [apply|remove]" >&2; exit 2 ;;
esac

if [ -f "$MARKER" ] && is_bound; then
    echo "[~] Enabled already" >&2
    exit 0
fi

if is_bound && [ ! -f "$MARKER" ]; then
    # A foreign overlay (e.g. another screensaver manager) owns the bind.
    # Ours stacks on top of it; removing ours reveals theirs.
    echo "[!] Something is already bound over $APP; stacking on top of it" >&2
fi

if [ -f "$APP/qml/main.qml" ]; then
    # ---- legacy qml screensaver: bind over main.qml, as before
    if ! mount | grep -F " on $APP/qml/main.qml " >/dev/null 2>&1; then
        mount --bind "$QML_PATH" "$APP/qml/main.qml"
    fi
    mkdir -p "$(dirname "$MARKER")"
    echo "legacy" > "$MARKER"
    echo "[+] Enabled (legacy qml): $APP/qml/main.qml" >&2
    exit 0
fi

# ---- flutter screensaver (webOS 10 and later): stage a qml app and bind the
# whole directory. The stock appinfo belongs to the flutter bundle; sam
# accepts a qml-typed copy of it (verified on webOS 10.3.1, OLED77B2PUA,
# fw 33.31.61).
mkdir -p "$STAGE/qml"
cp "$APPINFO" "$STAGE/appinfo.json.tmp"
sed -e "s/\"type\": *\"flutter\"/\"type\": \"qml\"/" \
    -e "s|\"main\": *\"[^\"]*\"|\"main\": \"qml/main.qml\"|" \
    "$STAGE/appinfo.json.tmp" > "$STAGE/appinfo.json"
rm -f "$STAGE/appinfo.json.tmp"
cp "$QML_PATH" "$STAGE/qml/main.qml"
chmod 644 "$STAGE/appinfo.json" "$STAGE/qml/main.qml"

mount --bind "$STAGE" "$APP"
mkdir -p "$(dirname "$MARKER")"
echo "flutter" > "$MARKER"
refresh_sam

echo "[+] Enabled (staged qml over flutter): $STAGE -> $APP" >&2
