ROOT=$(pwd)
SCREENSHOT_OUTPUT_DIR="./screenshots/"

for device in "$SCREENSHOT_OUTPUT_DIR"*/; do
    cd "$device"
    DEVICE=$(pwd)
    for language in */; do
        cd "$language"
        echo $(pwd)
        rm *.json
        raw=$(ls | jq -R -s -c 'split("\n")[:-1]')
        echo "$raw" > images.json
        cd ..
    done
    cd $ROOT
done


