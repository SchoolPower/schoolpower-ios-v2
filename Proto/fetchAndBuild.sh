echo "Make sure you've installed swift-protobuf (\$ brew install swift-protobuf)"

rm powerschool.proto
wget https://raw.githubusercontent.com/SchoolPower/SchoolPower-Backend/main/protos/powerschool.proto

cd ../SchoolPower
./buildProto.sh $(pwd)

