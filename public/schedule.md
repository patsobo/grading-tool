# Schedule

A schedule of sorts that is poorly made.  Just outlines what I'll be doing in order and maybe talks a little bit about implementation


### Compiling the eclipse projects (console only)

1. Write JS function for executing bash script (1 hour) (**actual: 4 hours**)
2. Write JS function for retrieving text output as a file (2 hours) (**actual: skipped**)
3. Write bash script for compiling and running regular java project to the console (2 hours) (**actual: 3 hours**)
4. Write bash script for running junit tests (1 hour)
5. Write bash script for compiling (not yet running) java swing projects (1 hour)

Total: 7 hours

###### Status

- 12/29/2016
	- module has been modified to only cover bash scripts
	- half of junit script needs to be written
	- java swing hasn't been fully tested yet
- 1/7/2017
	- swing projects work
- 1/7/2017
	- implemented running junit tests


### Create UI w/o Canvas hookup (displaying console only)

1. Create mock grade area div (1 hour)
2. Create area for displaying console output + hookup with JS function #2 from previous section (1 hour)
3. Add placeholders for name, assignment name (1 hour)
4. Design hierarchy directory structure w/ HTML and CSS (no backend yet) (2 hours)
5. Add area for displaying current file (use test file on server) (1 hour)
6. Hookup directory tree w/ files inside src directory (3 hours)
7. Add control for displaying entire project directory (using algorithm) (3 hours)

Total: 12 hours

###### Status

- 12/29/2016
	- skipped for now.  Working on getting working scripts that don't necessarily need UI.


### Canvas APIs (beginners)

1. Learn how to authenticate app for using APIs (2 hours) (**actual: 4 hours**)
2. Learn how to make basic GET call (2 hours) (**actual: 1 hour**)
3. Pull project name from Canvas/Blackboard (2 hours)
4. Learn how to make POST call (1 hour)
5. Get grading area to receive max score/send graded score (2 hous)

Total: 9 hours

###### Status

- 12/29/2016
	- managed to authenticate app (using unofficial testing method)
	- made basic GET calls
	- still need to parse json objects
	- still need to PUT updated grades
	- no actual functioning script written yet
- 12/31/2016
	- managed to upload score w/ comment
	- still need to upload to partner as well

### Canvas APIS (more complicated)

1. Pull zipped project file from Canvas (2 hours) (**actual: 1 hour**)
2. Add authentication to app (for grader to log in with) (4 hours)
3. Create list of potential assignments and let grader click on one to download all files (3 hours)

Total: 9 hours

###### Status

- 12/29/2016
	- managed to download zipped project file from Canvas (not implemented in app yet)
	- this is my next step. I need to parse the submission json for user_id, all the download urls (and possibly download file type), and submissions_comments.  Then, I must smartly figure out what to do with the attachment based on the assignment or w/e. From there, just need to iterate through each (download urls + user_id + submission_comments), display all the result data, and the grader will update the grade one-by-one.  For now, I will implement just pulling one zipped java project from the submission and compile and run that.
	- Oh yeah, and think about maybe trying an intelligent partner finder based on submission_comment that will upgrade his/her grade with current users.
- 12/30/2016
	- downloaded submissions (w/ comments) from Canvas and neatly organized them in a directory.

### Fake command line

1. Create HTML for command line (blinking cursor, type in junk. it submits...somewhere) (2 hours)
2. Send the command off to the server (1 hour)
3. Run java program output and send to client (3 hours)
4. If input required, use the command from step 2 to interact with program (2 hours)

Total: 8 hours

###### Status

- 12/29/2016
	 - skipped for now

### AjaxSwing

1. I have no clue (10 hours)

Total: 10 hours

###### Status

- 12/29/2016
	 - skipped for now

### Grand Total

55 hours...for now

If I spend 5 hours/week for the school year, then 10 hours/week over break, this tool should get done a little after New Year's, just in time for testing in the new semester.