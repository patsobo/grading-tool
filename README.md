# CSCI 306 Grading Tool

A tool for the ages.  To view more detail about the project and schedule, view the files inside the "public" folder.

### Purpose 

This tool is meant to aid in grading the CSCI 306 Software Engineering class taught at the Colorado School of Mines.  Hence this tool has a very focused and limited scope for that class and that class only.  Further extensions to the tool for other classes may be considered in the future.

This tool will help in automating a lot of the grading for a class.  It allows the grader to avoid navigating the slower Eclipse and Canvas interfaces, and instead give just the information the grader cares about, cleanly and efficiently.

### Requirements

To run the scripts in this tool, you will need a system with Bash.  Furthermore, you need to make sure you have the following tools: wget, java, javac, and subl.  To install them, run the following commands: 

    sudo apt-get install wget
    sudo apt-get install java
    sudo apt-get install javac
    sudo apt-get install subl

These are not necessarily correct, and I will update them later.

Furthermore, the grader must grant OAuth 2.0 access or whatever to this tool.  To do so, do this: BLAH BLAH BLAH

### Usage

To use this tool, simply run the $MASTER_SCRIPT.sh script.  The tool will then ask for the section and assignment that the grader wants to grade.

From there, the tool will go through each ungraded submission, compile it, then for each of these open a new window and display results:

- the output of the program (if the assignment has a Swing GUI, it will display that; otherwise, console output will just be printed in a new terminal window)
- the results of junit tests, if any
- a text editor (default sublime) will display the source code for the grader to review

The original window will then have a prompt for inputting a comment, and after that for inputting a grade.  Canvas will automatically be updated of these results.  Another prompt for updating a partner will pop up.  The tool will make a guess as to who the partner is based on the comment.  The grader can accept or reject this guess.  If rejected, the grader can input a name and the tool will try to find that student.  His/her grade will automatically be updated as well.

### Future considerations

This tool really works best when you want to hammer out the bulk of your grading.  If a student has a personal complaint about a grade or some other special case like that, you should probably just go to Canvas and resolve the issue through that.  In the future, this tool might be expanded to be useful for special cases like this.  For now, no.

Another possible consideration is expanding the tool to work beyond just Java programs.  This should be a relatively simple upgrade to make if wanted.

This tool could possibly be extended to be useful for classes beyond the computer science department; however, this is unlikely, considering Canvas has a "SpeedGrader" tool that looks way better than mine.  This tool is really helpful for submissions that need to be compiled or whatever outside of the Canvas website and can't just be viewed with a document previewer or something.