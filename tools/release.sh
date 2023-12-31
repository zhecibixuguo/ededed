#!/bin/sh

LAST_VER=$(git tag -l | tail -n 1)
CURR_VER=$(python -c 'import gdspy; print(gdspy.__version__)')

if [ "$LAST_VER" = "v$CURR_VER" ]; then
    echo "Version $CURR_VER (from package) already tagged. Did you forget to update __version__?"
    exit 1
fi

if ! grep "### Version $CURR_VER (" README.md > /dev/null 2>&1; then
    echo "Version $CURR_VER not found in the release notes of README.md"
    exit 1
fi

git status
echo "Release version $CURR_VER [y/n]?"
echo "This will commit and tag all changes, but will NOT add them."
read -r GOON

if [ "$GOON" = 'y' ] ; then
    git commit -m "Release v$CURR_VER"
    git tag -am "Release v$CURR_VER" "v$CURR_VER"
    echo "Review the status and 'git push' to finish release."
    echo "Do not forget to upload to PYPI:"
    echo "python setup.py sdist && twine upload -s dist/gdspy-$CURR_VER.zip"
fi
