# file: canvas.sh
# author:  Patrick Sobolewski
# description: Finds all ungraded submissions for a particular assignment,
# and loops through all of them, compiling and running them and letting the 
# grader submit a score. Requires a few user inputs.  The "main" is at the bottom of the file.
# notes:
#	- if you're download url isn't working, the '&' might be written as '\u0026' in the raw json

token="121266~pMnUxk5lhFHKYG8SOBmSxp6vs4qlClYxwGYT5lhN1zcIc1qPbcui0rJZzOHQrDJq"
site="https://colorado-school-of-mines.acme.instructure.com"

# global variables for keeping track of current assignment
course=-1
section=-1
assignment=-1
submissions=""	# json
json=""	# used to hold whatever json need be parsed

# max grade of the assignment
max_grade=-1
# partner
# TODO: turn into partners array
partner="no one else"

###################### FUNCTIONS ####################################

function run_test {
	echo "${course}, ${section}, ${assignment}"
}

# second and third arguments are optional for parameters
function GET {
	json=$(curl -s -X GET -H "Authorization: Bearer ${token}" "${site}/api/v1/${1}" \
		-d "${2}"="${3}"
	)
}
#courses/4/assignments/81/submissions

function PUT {
	echo "PUT command: -d {\"${2}\":\"${3}\"} ${site}/api/v1/${1} 1> NUL 2> NUL"

	curl -s -X PUT -H "Authorization: Bearer ${token}" \
		-H "Content-Type: application/x-www-form-urlencoded" \
		-d "${2}"="${3}" "${site}/api/v1/${1}" 1> NUL 2> NUL
	#rm NUL
}

#incomplete
function POST {
	curl -H "Authorization: GoogleLogin auth=<<YOUR_TOKEN>>" \
	-X POST \
	-H "Content-type: application/json" \
	-d '{"params":{"q":"select count(*) from [bigquery/samples/shakespeare];"},"method":"bigquery.query"}' \
'https://www.googleapis.com/rpc'
}

# gets CSCI 306, or whatever class is specified
function get_course {
	GET "courses"
	course=$(echo ${json} | jq -r "map(select(.name==\"${1}\")) | .[] .id")
}

# asks user to pick their section
function get_section {
	if [ ${course} == -1 ]; then
		exit
	fi
	GET "courses/${course}/sections"

	# kind of ugly solution, I guess that's bash for you
	readarray names < <( echo ${json} | jq ".[] .name" )
	readarray ids < <( echo ${json} | jq ".[] .id")
	echo "Select the section you are grading for:"
	for i in "${!names[@]}"; do
		echo -n "$i. ${names[$i]}"
	done
	echo -n "Selection: "
	read input
	# TODO: make sure input is within indices of names array
	section=$(echo -n ${ids[$input]})
	echo # extra newline for readability

	# OPTIONAL: if only one section found, skip selection process
}

# ask user to pick the assignment to grade
function get_assignment {
	if [ ${course} == -1 ]; then
		exit
	fi
	GET "courses/${course}/assignments"

	# same ugly selection menu as used in get_section
	readarray names < <( echo ${json} | jq ".[] .name" )
	readarray ids < <( echo ${json} | jq ".[] .id")
	echo "Select the assignment you want to grade:"
	for i in "${!names[@]}"; do
		echo -n "$i. ${names[$i]}"
	done
	echo -n "Selection: "
	read input
	# TODO: make sure input is within indices of names array
	assignment=$(echo -n ${ids[$input]})
	echo # extra newline for readability

	# get max_grade while you still have the assignment json
	max_grade=$( echo $json | jq "map(select(.id==${assignment})) | .[] .points_possible" )

	# OPTIONAL: if only one section found, skip selection process
}

function get_submissions {
	if [ ${course} == -1 ]; then
		exit
	fi
	GET "sections/${section}/assignments/${assignment}/submissions"
	# select all submissions that haven't been graded yet
	submissions=$(echo ${json} | jq -r "map(select(.workflow_state != \"graded\"))")
}

function find_partner {
	GET "courses/${course}/sections/${section}/" "include[]" "students"
}

# main loop for the program
function grading_loop {
	# First array holds attachments + user_ids, second one holds attachment name and submission comment
	# -r option in first array because it gets rid of quotes around attachment url
	readarray att_id < <( echo ${submissions} | jq -r "map(.attachments[].url, .user_id) | .[]" )
	readarray name_comments < <( echo ${submissions} | jq -r "map(.attachments[].filename, .submission_comments) | .[]")
	# make a dir to hold all the attachments
	mkdir submissions
	cd submissions
	mkdir tmpdir
	re='^[0-9]+$'	# for checking if a var is a number
	echo "Downloading files...this may take a bit..."
	for ((i=0; i<${#att_id[@]}; i++)); do
		val=$(echo -n ${att_id[$i]})
		# if not a number (a.k.a., download url)
		if ! [[ $val =~ $re ]]; then
			filename=$(echo -n "${name_comments[$i]}")
			download_file "${val}" "${filename}"			
		else # otherwise you hit a number and should rollover to next assignment
			mv tmpdir user${val}
			mkdir tmpdir
			echo "${name_comments[$i]}" > user${val}/comment.txt
			echo "${val}" > user${val}/metadata.txt
		fi 

	done
	rmdir tmpdir
	cd .. # go back to original dir
	echo "Finished downloading"
	echo

	# TODO: ask if there are tests

	for dir in submissions/*; do
		uid=$(echo "$dir")
		uid=${uid##*r}	# get the userid
		echo "Grading for $dir (temp text)."		
		# open terminal and compile project
		xterm -hold -e ./compiler.sh dir &
		pids[0]=$!
		# open terminal and run tests (if exists)
		xterm -hold -e ./test_runner.sh dir &
		pids[1]=$!		
		# open subl at project root dir
		subl fake_project/ &
		# for some reason subl is special
		# also, sublime has to be closed when script runs
		# might need alt solution
		pids[2]=$!
		pids[2]=$((pids[2]+1))		
		# display comment on current terminal
		sub_comment=$(echo $submissions | jq "map(select(.user_id==${uid})) | .[] .submission_comments")
		# need submission comment, max grade
		echo "User comment: "
		echo "$sub_comment"
		echo
		echo "Executing project..."
		echo
		echo -n "Enter comment: "
		read comment
		echo -n "Enter grade (out of ${max_grade}): "
		read grade
		# find partner
		partner="no one else"
		echo -n "Submitting to $partner as well.  If correct, press enter; otherwise input correct name: "
		read partner
		#puid=1
		find_partner $partner

		PUT "sections/${section}/assignments/${assignment}/submissions/${uid}" \
			"comment[text_comment]" "${comment}"  
		PUT "sections/${section}/assignments/${assignment}/submissions/${uid}" \
			"submission[posted_grade]" "${grade}"

		# kill sub-processes (other terminals + sublime)
		for pid in ${pids[@]}; do
			echo $pid
			kill $pid	
		done
		echo
	done
	exit
}

function post_grade {
	# ask for grade from grader
	# POST that grade to the submission
	exit
}

function post_comment {
	# ask for comment from user
	# POST that comment to the submission
	exit
}

# I think you don't even need the cookies
# Yes, I tried without cookies and it worked.  I'm keeping them just in case I need it later
function download_file {
	# Log in to the server.  This can be done only once.                   
	wget --save-cookies cookies.txt \
	     --keep-session-cookies \
	     --post-data 'user=psobolew@mymail.mines.edu&password=Cjsxkj5XhxSm4idIfMJD' \
	     --delete-after \
	     https://colorado-school-of-mines.acme.instructure.com/login/canvas 1> NUL 2> NUL

	# Now grab the page or pages we care about.
	wget --load-cookies cookies.txt -O "tmpdir/$2" $1 1> NUL 2> NUL
	rm cookies.txt
	rm NUL
}


###################### MAIN TYPE THING ##############################

# GET all courses, find specific course named w/e
get_course "Introduction to Oceanography"
# GET all sections of course, ask user which section to grade for
get_section
# GET all assignments in that section, ask user which one to grade for
get_assignment
# GET all ungraded submissions for that assignment
get_submissions
# Now must determine what type of submission it is (zip, txt, more than one, etc	)
# start the grading
grading_loop

run_test



#curl -u psobolew@mymail.mines.edu:Cjsxkj5XhxSm4idIfMJD -O 'https://colorado-school-of-mines.acme.instructure.com/files/8/download?download_frd=1\u0026verifier=9zVWUVTn13xGuWelcoNHKBVwdCp9reyNBLTLAok5'
