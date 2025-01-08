#! /usr/bin/env bash

do_heading() {
  local message="$1"

  echo "" >>$OUTFILE
  echo "echo Grab: $message" >>$OUTFILE
  echo "Build: $message"

}

OUTFILE="dist/grab.sh"
BASEURL="https://raw.githubusercontent.com/kism/zysystem.css/main"
SCRIPTSTART=$(
  cat <<EOF
#! /usr/bin/env bash
# Download zy.css and its friends to a dir called static

set -e # Turn on errors

if command -v curl >/dev/null 2>&1; then
  echo "curl is installed. Using curl to download the files."
  DOWNLOADCOMMAND="curl -sS -o"
elif command -v wget >/dev/null 2>&1; then
  echo "curl is not installed. Using wget to download the files."
  DOWNLOADCOMMAND="wget --quiet -O"
else
  echo "Neither curl nor wget is installed. Please install one of them to proceed."
  return 1
fi
EOF
)

# Start the build script
set -e # Turn on errors
mkdir dist # Its in .gitignore

echo "$SCRIPTSTART" >$OUTFILE

do_heading "Start!"

do_heading "Directories"

dirs=($(find static -type d))

for dir in "${dirs[@]}"; do
  echo "mkdir -p $dir" >>$OUTFILE
done

do_heading "Files"

files=($(find static -type f))

for file in "${files[@]}"; do
  echo "\$DOWNLOADCOMMAND $file $BASEURL/$file" >>$OUTFILE
done

chmod +x $OUTFILE

do_heading "Done!"
