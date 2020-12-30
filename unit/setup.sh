cd ..
./gradlew writeSvunitDirPath
svunit_dir=$(head -n 1 build/svunit_dir_path.txt)
cd - > /dev/null

echo "Using SVUnit from $svunit_dir"

cd $svunit_dir
source Setup.bsh
cd - > /dev/null
