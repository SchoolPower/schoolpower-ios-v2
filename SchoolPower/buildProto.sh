# $1 should be source root ($SRCROOT)

protoc --proto_path="$(dirname "$1")/Proto/" \
       --swift_out="$1/SchoolPower/Proto" \
       "$(dirname "$1")/Proto/powerschool.proto"
    
$(dirname "$1")/Proto/GenerateTypealaises "$1/SchoolPower/Proto/"
