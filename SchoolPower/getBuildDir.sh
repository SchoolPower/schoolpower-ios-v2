# Credit: https://stackoverflow.com/a/66377464
CONFIGURATION_BUILD_DIR=$(xcodebuild -showBuildSettings 2> /dev/null | grep CONFIGURATION_BUILD_DIR | sed 's/[ ]*CONFIGURATION_BUILD_DIR = //')

CONFIGURATION_BUILD_DIR="${CONFIGURATION_BUILD_DIR%/Build*}"

echo $CONFIGURATION_BUILD_DIR

