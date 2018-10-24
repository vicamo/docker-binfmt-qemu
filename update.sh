#!/bin/bash
set -eo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */*/ )
fi
versions=( "${versions[@]%/}" )

travisEnv=
for version in "${versions[@]}"; do
	dist=${version%/*}
	suite=${version#*/}

	echo "$version: $dist/$suite"
	template="Dockerfile.template"
	target="$version/Dockerfile"
	mkdir -p "$(dirname "$target")"
	sed \
		-e 's!@DIST@!'"$dist"'!g' \
		-e 's!@SUITE@!'"$suite"'!g' \
		"$template" > "$target"
	travisEnv+='\n  - DIST='"$dist"' SUITE='"$suite"
done

travis="$(awk -v 'RS=\n\n' '($1 == "env:") { $0 = substr($0, 0, index($0, "matrix:") + length("matrix:"))"'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
