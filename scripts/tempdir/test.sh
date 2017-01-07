echo "Executing first script, opening second"

xterm -hold -e ./second.sh &
pids[0]=$!

echo "Now opening third"

xterm -hold -e ./third.sh & 
pids[1]=$!

echo "Opening source code..."

subl fake_project/ &

# for some reason subl is special
# also, sublime has to be closed when script runs
# might need alt solution
pids[2]=$!
pids[2]=$((pids[2]+1))

echo -n "Enter blah: "
read blah

# kill all processes
for pid in ${pids[@]}; do
	echo $pid
	kill $pid	
done
