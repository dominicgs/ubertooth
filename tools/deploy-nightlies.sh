#!/bin/bash
REPO=greatscottgadgets/ubertooth-nightlies
PUBLICATION_BRANCH=gh-pages
set -x
# Checkout the branch
git clone --branch=$PUBLICATION_BRANCH https://${GITHUB_TOKEN}@github.com/$REPO.git publish
cd publish
# Update pages
cp $ARTEFACT_BASE/$BUILD_NAME.tar.xz .
# Write index page
echo "
<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">
<html><head>
	<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">
	<title>Ubertooth Nightly Builds</title>
</head>
<body>
" > index.html

URL=https://greatscottgadgets.github.io/ubertooth-nightlies/

for i in `ls -tr | grep -v index.html`; do
    echo "<a href=\"$URL\$i\">$i</a>" >> index.html
done

echo "
</body></html>
" >> index.html

# Commit and push latest version
git add $BUILD_NAME.tar.xz index.html
git config user.name  "Travis"
git config user.email "travis@travis-ci.org"
git commit -m "Build products for $SHORT_COMMIT_HASH, built on $TRAVIS_OS_NAME, log: $TRAVIS_BUILD_WEB_URL"
if [ "$?" != "0" ]; then
    echo "Looks like the commit failed"
fi
git push -fq origin $PUBLICATION_BRANCH