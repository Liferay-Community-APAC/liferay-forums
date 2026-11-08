#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

[[ ${TAG} =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]] || { echo "${TAG} isn't a version tag, such as v1.0.1." >&2; exit 1; }

version=${TAG#v}
notes=release-notes/${version}.md
dist=$(mktemp --directory)

[[ -f ${notes} ]] || { echo "Missing ${notes} on main. Add the release notes, then run the workflow again." >&2; exit 1; }

echo "Building ${TAG}."

(cd "${SOURCE_DIR}" && ./gradlew build --no-daemon --quiet)

[[ -z $(git -C "${SOURCE_DIR}" status --porcelain) ]] || { echo "The build changed files in the source. Fix the build, then tag again." >&2; git -C "${SOURCE_DIR}" status --short >&2; exit 1; }

for file in liferay-forums-batch liferay-forums-etc-spring-boot liferay-forums-site-initializer
do
	cp "${SOURCE_DIR}/client-extensions/${file}/dist/${file}.zip" "${dist}/"
done

cp "${SOURCE_DIR}/scripts/generate-site-initializer-zips.sh" "${dist}/"

source_root=$(mktemp --directory)

git -C "${SOURCE_DIR}" archive HEAD --prefix="liferay-forums-${version}/" LICENSES LICENSING.md build.gradle client-extensions configs gradle gradle.properties gradlew gradlew.bat platform.bndrun scripts settings.gradle | tar --extract --directory "${source_root}"

cat > "${source_root}/liferay-forums-${version}/README.md" <<README
# Liferay Forums ${version} Source

The source of Liferay Forums ${version}'s three client extensions, as a Liferay Workspace. You need it to install on Liferay PaaS, to build a site initializer for each additional forum site, or to add the forum to your own Liferay Workspace.

- \`client-extensions/liferay-forums-batch\`: the forum's data model, notification templates, and search blueprint
- \`client-extensions/liferay-forums-etc-spring-boot\`: the forum's microservice
- \`client-extensions/liferay-forums-site-initializer\`: the forum site
- \`scripts/generate-site-initializer-zips.sh\`: copies of the site initializer zip for several sites, on Liferay Self-Hosted

Documentation: https://liferay-community-apac.github.io/liferay-forums/

Licensing: see \`LICENSING.md\`.
README

(cd "${source_root}" && zip --quiet --recurse-paths -X "${dist}/liferay-forums-${version}-source.zip" "liferay-forums-${version}")

(cd "${dist}" && sha256sum -- * > SHA256SUMS && cat SHA256SUMS)

if [[ ${DRY_RUN:-} == true ]]
then
	echo "Dry run: the release files are in ${dist}."

	exit 0
fi

prerelease=()

[[ ${version} == *-* ]] && prerelease=(--prerelease)

if gh release view "${TAG}" > /dev/null 2>&1
then
	echo "Updating the release ${TAG}."

	gh release upload "${TAG}" "${dist}"/* --clobber
	gh release edit "${TAG}" --notes-file "${notes}" --title "Liferay Forums ${version}"
else
	echo "Creating the release ${TAG}."

	gh release create "${TAG}" "${dist}"/* --notes-file "${notes}" --target "${GITHUB_SHA}" --title "Liferay Forums ${version}" "${prerelease[@]}"
fi

echo "Published: ${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/releases/tag/${TAG}"
