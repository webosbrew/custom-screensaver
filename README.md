custom-screensaver
==================

Probably the only custom screensaver you'll ever need on webOS TV.

Requires root.

Features
--------

* Autostart registration
* Temporary apply
* Launch screensaver immediately for testing
* webOS 10+/flutter screensaver support (see below)
* Restore the stock screensaver without a reboot (`apply.sh remove`)

webOS 10 / flutter screensavers
-------------------------------

Newer firmware (webOS 10 and later, at least 10.3.1 / 33.31.61) ship a
flutter-based screensaver app with no `qml/` inside, so the historical
bind-over-`qml/main.qml` has nothing to attach to (see #14). On those TVs
apply.sh instead stages a full qml app in
`/var/lib/webosbrew/custom-screensaver/` — the stock appinfo converted to
`type: qml` plus this app's `screensaver-main.qml` — and bind-mounts the whole
staged directory over `/usr/palm/applications/com.webos.app.screensaver`.
Verified on an OLED77B2PUA, webOS 10.3.1 (fw 33.31.61).

Caveat: on webOS 10 the application manager only sometimes picks the type
change up from a block/release cycle; if the screensaver misbehaves after
toggling, one `systemctl restart sam.service` (or a reboot) settles it. The
staged copy survives reboots; `apply.sh remove` undoes everything.

Installation
------------
This should be downloadable in Homebrew Channel. Otherwise, there's an `ipk` in
GitHub releases to the right. You are on your own here.

Acknowledgments
---------------
- Original animation POC by an unnamed individual.
- According to WikiMedia Commons - DVD Video logotype does not meet the [threshold of originality](https://commons.wikimedia.org/wiki/Commons:Threshold_of_originality) needed for copyright protection, and is therefore in the public domain.
