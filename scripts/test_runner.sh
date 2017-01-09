#!/bin/bash
# file: test_runner.sh
# author:  Patrick Sobolewski
# description: Automatically finds, compiles, and runs all junit tests.
# 	@params 1 : relative directory of the user's submission
# 	@params 2 : full directory path of the directory holding the jars
# notes:
# - search_pattern can't contain [] (grep complains)


# get the name of the project directory
project_name=$(find $1 -type f -name *.zip | sed 's/.*\///' | sed 's/\/*.zip//')

# directory for the project
project_dir="${1}/${project_name}"

# move to project dir for simplified logic
cd $project_dir

# find the directory with all the test java files
search_pattern='@Test'
readarray result < <(find "src/" -type f -print0 | xargs -0 grep -l "${search_pattern}")
# first sed removes 'src/' from front, next sed removes java file name
test_dir=$(echo "${result[0]}" | sed 's/^....//' | sed 's/\/.*.java//')

# includes junit, src w/ all the files, and bin for running tests 
junit=$(ls ${2}/junit-*.jar)
hamcrest=$(ls ${2}/hamcrest-core-*.jar)
classpath=$(pwd)/bin:${junit}:${hamcrest}:src

#java_files

# build the tests
javac -cp $classpath -d bin/ src/${test_dir}/*.java

# get all the test class files
# first sed removes '.class' from end, second sed adds 'test_dir.' to front
class_files=$(ls bin/${test_dir} | sed 's/.\{6\}$//' | sed "s/^/${test_dir}./")

# run the tests
java -cp $classpath org.junit.runner.JUnitCore $class_files

cd - > /dev/null