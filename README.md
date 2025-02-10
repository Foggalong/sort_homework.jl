# `sort_homework.jl`

A script for distributing homework submissions to tutors for marking, used in the University of Edinburgh's [School of Economics](https://economics.ed.ac.uk/).

## Installation

Use the windows store to install both [julia](https://julialang.org/) and [VS Code](https://code.visualstudio.com/).  We've checked, and it looks like both of these can be installed on your desktops without any additional administrator privileges.

Once you're in VS Code, you should go to the "Extensions" tab (on the left hand side) to search for and install the julia extension.

## Running the Script

Make sure that the files sort_homework.jl and Project.toml are both in the same folder as the directory containing the student submissions downloaded from Learn.

In VS Code, open the folder for the current week's homework

Open the sort_homework.jl file and update the configuration section at the top.  You may need to change the names of the:

- marksheet: this is the only one that will typically need to be changed week to week.  Copy over the filename of the current week's marksheet.

- tutors: You will need to copy over the names of the tutors exactly as they appear in the marksheet.  This should only need to be done once a semester, or when the tutors change.

- file_dir: If you want to change the name of the folder where the submissions are located, you may need to update this.  As of now, it's set to the default that Learn produces when you unzip the files ("Submissions/")

- out_dir: If you want to change the name of the output directory where the sorted homeworks will be stored, change this to the desired name.

Open a terminal.  You can do this by typing Ctrl + Shift + P to open the command palette, and then typing **"Create New Terminal"**.  I think there's also a keyboard shortcut you can use to do this directly (Ctrl + Shift + `).  If you opened VS Code in the correct folder in step 2, then you shouldn't need to change anything further to ensure you're in the correct directory.

Run the sorting file by typing the command `julia sort_homework.jl` in the terminal prompt.

Note 1: You can also do this by opening the file in the text editor, and, using the command palette, execute the command "Julia: Execute File in REPL"

Note 2: This will delete the folder sorted_homeworks and re-create it, so if you're running this command for the second time, you may want to create a backup copy of the sorted homeworks folder (if, for instance, the tutors have made annotations on the scripts).

I've attached the script and the Project.toml file to this email again for reference.  Note that I'm pretty sure that this sorting script should work with any student submissions on Learn that need to be sorted by Tutors (as long as the marksheet has the same format) so you may be able to use this as well for things like sorting essay submissions.
