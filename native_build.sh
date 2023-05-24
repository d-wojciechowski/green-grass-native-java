COMPONENT_NAME=`jq -r '.component | keys_unsorted[0]' gdk-config.json`
VERSION=`jq -r '.component | .["'$COMPONENT_NAME'"] | .version' gdk-config.json`
AUTHOR=`jq -r '.component | .["'$COMPONENT_NAME'"] | .author' gdk-config.json`

# copy recipe to greengrass-build
# according to: https://github.com/aws-greengrass/aws-greengrass-gdk-cli/issues/74 it is required to manually update recipe
cp recipe.yaml ./greengrass-build/recipes
sed -i "s/COMPONENT_VERSION/$VERSION/g" ./greengrass-build/recipes/recipe.yaml
sed -i "s/COMPONENT_NAME/$COMPONENT_NAME/g" ./greengrass-build/recipes/recipe.yaml
sed -i "s/COMPONENT_AUTHOR/$AUTHOR/g" ./greengrass-build/recipes/recipe.yaml

# create custom build directory
rm -rf ./custom-build
mkdir -p ./custom-build/$COMPONENT_NAME

# build native build
./gradlew test nativeCompile

# copy native build artifacts to custom build
cp ./build/native/nativeCompile/application ./custom-build/$COMPONENT_NAME/application

# zip up archive
cd ./custom-build/$COMPONENT_NAME
zip -r ../$COMPONENT_NAME.zip ./*
cd ../..

# copy archive to greengrass-build
cp ./custom-build/$COMPONENT_NAME.zip ./greengrass-build/artifacts/$COMPONENT_NAME/$VERSION/

#rm -rf ./custom-build