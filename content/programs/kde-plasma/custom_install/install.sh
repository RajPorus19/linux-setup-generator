#!/bin/bash
set -e
echo "Installing KDE Plasma..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        opensuse*|suse*) sudo zypper install -y -t pattern kde kde_plasma ;;
        alpine) echo "Alpine: KDE Plasma is available via 'setup-desktop plasma'" && exit 0 ;;
        *) echo "Unknown distro for KDE Plasma. Try your package manager." && exit 1 ;;
    esac
fi
