#! /bin/bash

# get absolute path, but don't follow symlink
# realpath follows symlinks, non-existant on osx
realpath_alt() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}
RED='\033[0;31m'
NC='\033[0m' # No Color
rootdir=$(dirname $0)
echo rootdir is $rootdir
for srcfile in $(find $rootdir -type l -or -type f -not -path "${rootdir}/.git*" -not -path $0); do
    # echo source file $srcfile
    dstfile="${HOME}${srcfile##${rootdir}}"
    # echo dest file $dstfile
    if [ -e "${dstfile}" -a ! -L "${dstfile}" ]; then
        echo -e "${RED}$dstfile exists, moving to ${dstfile}.orig${NC}"
        mv -i "$dstfile" "${dstfile}.orig"
    fi
    srcfile="$(realpath_alt $srcfile)"
    mkdir -p "$(dirname ${dstfile})"
    if [ ! -L $srcfile ]; then
        echo "creating symlink $dstfile -> $srcfile"
        ln -fs "$srcfile" "$dstfile"
    else
        echo "copying symlink $dstfile -> $srcfile"
        cp -P "$srcfile" "$dstfile"
    fi
done

