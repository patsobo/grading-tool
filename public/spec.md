# Software Engineering Grading Tool Spec

**UPDATE 12/29/2016** Project has been re-evaluated to first and foremost cover working command-line scritps.  The web stuff is a secondary consideration.  So focus on the functionality past the web tool described here and in the schedule.

### Use case

Imagine the following:

Jane is the grader for CSM's CSCI 306 class, Software Engineering.  She's looking to grade Billy's Clue game, which has a nice Scooby-Doo theme to make it unique.  To grade it, Jane first needs to download the zipped up project directory that is Billy's submission.  She then needs to unzip it, compile it, and check the graphical output on Eclipse.  From there, she must record the grade and comment she wants to leave, and then manually put in everything afterwards on a clunky educational tool interface.

Or she *would*, I should say, if she didn't have this grading tool.  With it, the tool will grab the zipped project file from Canvas, unzip it, compile it, and run it on any web browser!  Jane can see the code and the graphical output side-by-side.  Then, when she's decided she's ready to give a grade to the thing, there's a convenient box for slapping a grade on the assignment.  The tool then sends that grade off to Canvas for the user and the partner to be updated!

*This is amazing*.  Thinks Jane. *Time for the next assignment!*  And so Jane submits the grade and the tool *automatically goes to the next submission*.  Beautiful.  Quick.  Painless.  Janes saves half her time just by not having to navigate through Canvas.

Jane enjoyed grading Billy's Clue game so much, she wants to use the tool for *every* assignment.  The next week, the class turns in a simple Java program that asks for names of police officers in the command line.  Jane now needs to feed input into the assignment to test the project and make sure it works.  She writes up a quick test file that is just a list of names in Notepad, and then checks all the right boxes in the grading tool.  Voila!  Each project now automatically compiles, runs, *and* inserts the text file as input.  And then, all of the results are posted on the site, right next to the code.  Jane smiles and continues her insane grading pace.

Jane looks up and sees that it's 8pm.  She started grading at 7:30pm.  *I guess I could start that OS assignment then* she muses as she loads up Starcraft on her computer.

The intention of this tool is to minimize repetitive actions, and focus on *just grading*.


### Components

There are three types of assignments that need to be considered here: graphical output submissions (using Java Swing for the GUI), console output submissions (just text), and non-Java submissions (maybe a dia file or something or some text response).  These assignments need to be pulled from Canvas and subsequently the grade must be sent back to Canvas.  

Also (potentially), the web page for the assignment could be embedded in a popup or something for easy reference for the grader.  Maybe.

One last consideration must be made: whether to pre-load the tool with all the assignments for the semester (and associated metadata such as due date), or to figure out if the Canvas APIs can do some magic stuff.

Because of all this, there are 6 (+1) major components to implement:

1. **Text editor** - for viewing the code submitted.  Also needs a directory tree for navigating between files.
2. **Command line** - for viewing and interacting with the output of the program.
3. **Graphical display** - for viewing and interacting with Swing GUIs.
4. **Grade area** - Area for submitting grade and comments to Canvas.
5. **Pulling projects from Canvas** - the projects must be pulled, compiled, and sorted for the grader.
6. **Assignment prompt popup** - Bring up the web page describing the assignment and points distribution.
7. **Test grader** - The jUnit tests, if they exist, must be run and the results reported on a window.

### Implementation notes (for technical people only)

1. **Text editor** - Fancy scripting with JavaScript and Node.js.
2. **Command line** - Fancy scripting with JavaScript and Node.js.
3. **Graphical display** - AjaxSwing.
4. **Grade area** - Canvas REST APIs and JavaScript.
5. **Pulling projects from Canvas** - bash scripts invoked using child_processes module from Node.js.  And Canvas APIs, obviously.
6. **Assignment prompt popup** - object + embed html items?  Eh.
7. **Test grader** - same tools as for compiling Java projects normally.

The flow of data will be something like: 
1. get the course (CSCI 306) json
2. ask for assignment to grade (using GET requests and json parsing)
3. get that assignment and either 1) download all submissions at once or 2) download one at a time
4. unzip, compile, and run project and junit tests (if any)
	- junit tests will execute in new terminal window
	- swing GUI will pop up separately
5. Ask for grade (out of whatever) and POST result to site
6. Get next assignment, repeat

Potentially the prompt page (on the course site) will be pulled up sometime too.


### Mockup

![Picture of what a typical image will look like]


### What's *not* being supported

- Blackboard APIs.  It was announced that CSM is moving to Canvas, so that's what will be used.
- Non-java projects.  CSCI 306 is taught with Java, so that's the only compiler that will be included for now.