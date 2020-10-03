shellScriptDir=$(dirname "$0")
frameFileName="$shellScriptDir/frame.png"
rm -rf frame-it
mkdir -p frame-it
for fileName in *."jpg"; do
    resizedFileName="resized_$fileName"
    mergedFileName="frame-it/${fileName%%.*}.png"

    # Crop it first
    imageWidth=$(identify -format "%w" $fileName)
    newImageHeight=$(expr 2 \* $imageWidth)
    convert $fileName -crop $imageWidth'x'$newImageHeight+0+0 -resize 49.2% $resizedFileName

    ## Place cropped image into the frame
    composite -geometry +42+155 $resizedFileName $frameFileName $mergedFileName
    rm $resizedFileName
    echo "✅ $fileName framed"
done

# Reading tile count
read -p "Enter number of tiles in one row: " tile

montage -mode concatenate -gravity center -background none -tile "$tile"x frame-it/*.png frame-it/montage.png
echo "✅ Created montage version 🖼️"
