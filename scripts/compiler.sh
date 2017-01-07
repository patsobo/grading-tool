# file: compiler.sh
# author:  Patrick Sobolewski
# description: Automatically searches for main method and compiles
# given Eclipse Java project, then runs it.  In the future, hopefully
# the project can be run by a separate script
# 	@params 1 : directory (relative to current) of all the projects
# 	@params 2 : directory (relative to previous param) of sole project 
# notes:
# - search_pattern can't contain [] (grep complains)
# - echo class_name with quotations to keep the newlines

# find zip project, get just the name
project_name=$(find $1 -type f -name *.zip | sed 's/.*\///' | sed 's/\/*.zip//')

# directory for the project
project_dir="${1}/${project_name}"

# unzip the project
cd $1
unzip ${project_name}.zip
cd - > /dev/null

# Search for main
search_pattern='public static void main('

# find the main method within the project
filepath=$(find "${project_dir}/src/" -type f -print0 | xargs -0 grep -l "${search_pattern}")
num=$(echo "${filepath}" | wc -l)
if [ ${num} -gt "1" ]; then
	echo "Multiple main methods:"
	echo "${filepath}"
	read -p "Choose one (selection begins at 1): " sel
	filepath=$(echo "${filepath}" | sed -n ${sel}p)
elif [ -z "${filepath}" ]; then
	echo "No main method found"
	exit -1
fi

# strip off "project_dir/"" from beginning of filepath
len=$(echo "${project_dir}/" | wc -L)
filepath=$(echo "${filepath}" | sed -r "s/^.{${len}}//")

# Move to project root directory
cd ${project_dir}

# Compile the project
javac -d bin/ -cp src ${filepath}

# Run the project (w/o "src/" or ".java" in filepath)
java -cp bin ${filepath:4:-5}

# Return to scripts directory without any output
cd - > /dev/null