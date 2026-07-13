#!/usr/bin/env bash
# Build the CurseForge upload zip for the standalone AchievementRarity addon.
# Mirrors how-rare's scripts/release.sh, with one difference: this repo's ROOT is
# the addon (TOC at top level), so the addon folder the zip must contain is staged
# first. Zip = AchievementRarity/ { TOC, Libs/LibStub, the versioned lib folder,
# LICENSE.txt }. The version comes from the TOC — stamped with the snapshot date by
# how-rare's publish-data.sh on every data publish.
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(grep -m1 '^## Version:' AchievementRarity.toc | awk '{print $3}')
out="AchievementRarity-${version}.zip"
rm -f "$out"

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
mkdir -p "$stage/AchievementRarity"
cp AchievementRarity.toc "$stage/AchievementRarity/"
cp -R AchievementRarity-1.0 "$stage/AchievementRarity/"
cp -R Libs "$stage/AchievementRarity/"
# Ship the license inside the addon folder; repo-root LICENSE is the source of truth.
cp LICENSE "$stage/AchievementRarity/LICENSE.txt"

(cd "$stage" && zip -qr "$OLDPWD/$out" AchievementRarity -x '*.DS_Store')
echo "$out"
