#= 
Title:  sort_homework.jl
Author: Jacob Adenbaum


Description: This script will sort the homework files by tutor.  There are configurable options (mostly filenames/directory paths) in the top section labelled configuration.  

Dependencies:
    - marksheet: this script uses the current marksheet to read the
    correspondence between student IDs and Tutor names.  You need to provide the
    name of the excel file that contains the marksheet
        NOTE: this script relies on details about how the marksheet is formatted (column names, sheet names, spacing of the header).  You should ensure that the formatting does not change from week to week, otherwise this might break

    - file_dir: the directory storing the raw homework files downloaded from Learn 
    
    - tutors: I've hardcoded the list of valid tutors in the configuration setting
        you should ensure that the names are up to date with what is in the marksheet (and that they are consistently capitalized from week to week)

Outputs:
    - out_dir: this folder contains subfolders with the submissions for
        each tutor, and where the submissions have been named according to each
        student's ID.  

        Note: if a student has submitted multiple documents, they will be collected together in a folder together.  

        Note: this script will clear the output directory before running, so if
        you're running this script for a second time, and you have made edits or
        annotations to files in the output directory, be sure to create a
        backup.  
=# 

################################################################################
#################### CONFIGURATION #############################################
################################################################################
file_dir    = "Submissions/"
out_dir     = "sorted_homeworks/"
marksheet   = "Marksheet.xlsx"
report_file = "output_report.xlsx"

# List of tutors to use (this helps deal with the case where there are
# extraneous rows in the marksheet)
tutors = [
    "Tutor 1",
    "Tutor 2",
    "Tutor 3"
] 

################################################################################
#################### CODE TO RUN ###############################################
################################################################################

## Setup 
using Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()

cd(@__DIR__)
using CSV, DataFrames, DataFramesMeta, Chain
using XLSX

## Load the tutor list
df = XLSX.readtable(marksheet, "Marksheet", first_row = 3) |> DataFrame

df = @chain df begin
   @rsubset!(:Tutor in tutors)
   @rtransform!(:Username = lowercase(:Username))
   select!(:Username, :Tutor, :"Submitted?")
end

files = readdir("Submissions")

# vector to track whether each student submitted
submission_status = String[]

## Loop over all the students

rm(out_dir, recursive=true, force=true)

@eachrow df begin
    # Filter just that student's submission files  
    student_files = filter(
        x -> occursin(:Username, x) & !occursin(r"\.txt$", x), 
        files
    )

    if length(student_files) == 0
        print("Student $(:Username) submitted no files!\n")
        push!(submission_status, "No")
    else
        push!(submission_status, "Yes")
    end

    # Copy each file to the relevant folder 
    for (i, file) in enumerate(student_files)
        ext = match(r"\.\w*$", file).match

        # destination path
        if length(student_files) == 1
            dest = joinpath(out_dir, :Tutor, "$(:Username)$ext")
        else
            dest = joinpath(out_dir, :Tutor, :Username, "Submission$i$ext")
        end
        mkpath(dest)

        # Source path
        src = joinpath(file_dir, file)

        cp(src, dest, force=true)
    end
end

# cannot yet overwrite the 'Submitted?' column in the Marksheet,
# so instead this creates a new XLSX with that information.
df[!, "Submitted?"] = submission_status
# save copy of dataframe, overwriting if it already exists
rm(report_file, force=true)
XLSX.writetable(report_file, df)