# Convert a PNG image to SVG

svg() {

    fullFileName=$1
    filename=$(basename -- "$fullFileName")
    extension="${filename##*.}"
    output="${filename%.*}.svg"

    convert -alpha remove $fullFileName pgm: | potrace --svg -o $output
}
