ROOT=$(pwd)
SCREENSHOT_OUTPUT_DIR="./screenshots"
SCREENSHOT_COMPRESSED_OUTPUT_DIR="./screenshots-compressed"

rm -r $SCREENSHOT_COMPRESSED_OUTPUT_DIR
cp -r $SCREENSHOT_OUTPUT_DIR $SCREENSHOT_COMPRESSED_OUTPUT_DIR

for device in "$SCREENSHOT_COMPRESSED_OUTPUT_DIR"/*/; do
    cd "$device"
    DEVICE=$(pwd)
    for language in */; do
        cd "$language"
        echo $(pwd)
        for image in *.png; do 
            echo "$image"
            pngquant "$image" -o "$image" --quality=20-30 --force
        done
        rm *.json
        raw=$(ls *.png | jq -R -s -c 'split("\n")[:-1]')
        echo "$raw" > images.json
        cd ..
    done
    cd $ROOT
done


