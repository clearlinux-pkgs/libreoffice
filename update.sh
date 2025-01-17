#!/bin/bash
set -e -o pipefail

PKG=libreoffice
RELEASE_URL="https://www.libreoffice.org/download/download-libreoffice/"
MANUAL_VERSION="$1" # Optional version to build

errexit() {
	local ret=1
	echo "Error: $1"
	if [[ -n "$2" ]]; then
		ret=2
	fi
	exit $ret
}

echo -n "Pulling package repo changes: "
git pull --ff-only

# Look for the latest Sourcecode release
echo "Checking latest released version at ${RELEASE_URL}"
TARS=$(mktemp)
trap "rm -f $TARS" EXIT
curl --silent --show-error --fail "$RELEASE_URL" | (grep --perl-regex --only-matching "${PKG}-\d+(?:\.\d+)+(?:\.[a-z]+)+" ||:) | sort --reverse --unique > $TARS
if ! grep -q "^${PKG}" $TARS && [[ "" == "${MANUAL_VERSION}" ]]; then
	errexit "no ${PKG} source tarballs found at ${RELEASE_URL}"
fi
NEW_VERSION=$(perl -pe "s|^${PKG}-(\d+(?:\.\d+)+).*|\$1|" "${TARS}" | head -1)
CURRENT_VERSION="$(rpmspec --srpm -q --qf="%{VERSION}" $PKG.spec)"

echo "Our current version:     ${CURRENT_VERSION}"
echo "Latest released version: ${NEW_VERSION}"

if [[ "" != "${MANUAL_VERSION}" ]]; then
	echo "Manual version specified: ${MANUAL_VERSION}"
	NEW_VERSION="${MANUAL_VERSION}"
elif [[ "$1" != "--force" ]]; then
	# Check whether new version is greater than current version
	if (echo ${NEW_VERSION}; echo ${CURRENT_VERSION}) | sort --version-sort --check=silent; then
		echo "Not rebuilding. Run the script directly with --force to override:"
		echo "$0 --force"
		exit
	fi
fi

# Drop the last component of the version number for the directory name
NEW_VERSION_DIR=${NEW_VERSION%.*}

# Update the version for source and archive tarballs in Makefile
echo "Updating Makefile."
perl -pi -e 's/('"${PKG}"'-(?:\w+-)?)\d+\.\d+\.\d+\.\d+/${1}'${NEW_VERSION}'/g; s|(/)\d+\.\d+\.\d+(/)|${1}'${NEW_VERSION_DIR}'${2}|g' Makefile

# Remove archives from options.conf; otherwise autospec will fail
echo "Updating options.conf."
perl -pi -e 's/^(archives\s*=).*/$1/' options.conf

# Check whether anything changed. Should have been caught above, so this is
# probably a script failure.
if git diff-index --quiet HEAD --; then
	echo "Weird, nothing changed."
	exit 1
fi

# Download and cache the new tarballs, since they could take longer than
# autospec allows
echo "Downloading and caching the new tarballs to avoid autospec timeouts."
git diff Makefile | grep '^+' | grep -oE 'https?://(\S+)' | wget -N -i - || :

# Build the new version
echo "Running autospec."
make autospec

# Update lang sorting
echo "Checking language subpackages for changes."
./move_langs_to_extras.pl

# check whether any lang- extras files were changed or added
if git status | grep -qE '^\s+modified:\s+lang-'; then
	# We need to re-autospec to re-package the language files
	echo "Rebuilding to update language subpackages."
	make autospec
	git commit --amend -m 'Rebuild to update language subpackages'
fi

echo "Sending to Koji."
make koji-nowait
