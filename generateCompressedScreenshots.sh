SCREENSHOT_OUTPUT_DIR="./screenshots"
SCREENSHOT_COMPRESSED_OUTPUT_DIR="./screenshots-compressed"

rm -r $SCREENSHOT_COMPRESSED_OUTPUT_DIR
cp -r $SCREENSHOT_OUTPUT_DIR $SCREENSHOT_COMPRESSED_OUTPUT_DIR

cd "$SCREENSHOT_COMPRESSED_OUTPUT_DIR"
ROOT=$(pwd)
printf "{" > images.json
for device in */; do
    printf "\"$(echo $device | sed 's/.$//')\":" >> images.json
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
        printf "$raw" > images.json
        cd ..
    done
    printf "{" > images.json
    for language in */; do
        printf "\"$(echo $language | sed 's/.$//')\":" >> images.json
        cat "$language/images.json" >> images.json
        printf "," >> images.json
    done
    sed -i '' -e '$ s/.$//' images.json
    printf "}" >> images.json
    cd $ROOT

    cat "$device/images.json" >> images.json
    printf "," >> images.json
done
sed -i '' -e '$ s/.$//' images.json
printf "}" >> images.json


