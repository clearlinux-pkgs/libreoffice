#!/bin/bash
set -e -o pipefail

PKG=libreoffice
RELEASE_URL="https://www.libreoffice.org/download/download-libreoffice/"

errexit() {
	local ret=1
	echo "Error: $1"
	if [[ -n "$2" ]]; then
		ret=2
	fi
	exit $ret
}

git pull --ff-only

# Look for the latest Sourcecode release
TARS=$(mktemp)
trap "rm -f $TARS" EXIT
curl -sSf "$RELEASE_URL" | grep -Po "${PKG}-\d+(?:\.\d+)+(?:\.[a-z]+)+" | sort -ru > $TARS
if ! grep -q "^${PKG}" $TARS; then
	errexit "no ${PKG} tarballs found"
fi
NEW_VERSION=$(perl -pe "s|^${PKG}-(\d+(?:\.\d+)+).*|\$1|" "${TARS}" | head -1)
NEW_VERSION_DIR=${NEW_VERSION%.*}
CURRENT_VERSION="$(rpmspec --srpm -q --qf="%{VERSION}" $PKG.spec)"

if [[ "$1" != "--force" ]]; then
	if [[ "${CURRENT_VERSION}" = "${NEW_VERSION}" ]]; then
		exit
	fi
fi

# Update the version for source and archive tarballs in Makefile
perl -pi -e 's/('"${PKG}"'-(?:\w+-)?)\d+\.\d+\.\d+\.\d+/${1}'${NEW_VERSION}'/g; s|(/)\d+\.\d+\.\d+(/)|${1}'${NEW_VERSION_DIR}'${2}|g' Makefile

# Remove archives from options.conf; otherwise autospec will fail
perl -pi -e 's/^(archives\s*=).*/$1/' options.conf

# Check whether anything changed. Should have been caught above, so this is
# probably a script failure.
if git diff-index --quiet HEAD --; then
	echo "Nothing changed."
	exit 1
fi

# Download and cache the new tarballs, since they could take longer than
# autospec allows
git diff Makefile | grep '^+' | grep -oE 'https?://(\S+)' | wget -N -i - || :

# Build the new version
make autospec

# Update lang sorting
./move_langs_to_extras.pl

# check whether any lang- extras files were changed or added
if git status | grep -qE '^\s+modified:\s+lang-'; then
	# We need to re-autospec to re-package the language files
	make autospec
fi

make koji-nowait
