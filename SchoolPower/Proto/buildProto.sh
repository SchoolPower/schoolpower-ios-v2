# $1 should be source root
protoc --proto_path="$1/Proto/" --swift_out="$1/SchoolPower/Proto" "$1/Proto/powerschool.proto"
$1/Proto/GenerateTypealaises "$1/SchoolPower/Proto/"
