if [ $# -ne 2 ]; then
  echo 1>&2 "Usage: $0 COMPONENT-NAME COMPONENT-VERSION"
  exit 3
fi

COMPONENT_NAME=$1
VERSION=$2

# copy recipe to greengrass-build
cp recipe.yaml ./greengrass-build/recipes

# create custom build directory
rm -rf ./custom-build
mkdir -p ./custom-build/$COMPONENT_NAME

# build native build
./gradlew test nativeCompile

# copy native build artifacts to custom build
cp ./build/native/nativeCompile/application ./custom-build/$COMPONENT_NAME/application

# zip up archive
zip -r -X ./custom-build/$COMPONENT_NAME.zip ./custom-build/$COMPONENT_NAME/application

# copy archive to greengrass-build
cp ./custom-build/$COMPONENT_NAME.zip ./greengrass-build/artifacts/$COMPONENT_NAME/$VERSION/

rm -rf ./custom-build