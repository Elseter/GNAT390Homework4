--  It is common to recieve code from differet teams that need to be inserted into your project.
--  However, you don't have access to that code and may not be sure the returning data is correct.
--  
--  This project requires you to write three DIFFERENT sort routines for integer arrays and determine the validity of those sorts. 
--  You can reuse the code from previous efforts.
--
--  SORTER.ADS provides the type declaration for an integer array of unknown size. It has a
--  private section that identifies the size of a small, medium and anything else would be a large array.  The private section
--  section also contains the calls to subsequent routines based on array size.
--  Notice Spark Mode is set to ON
--
--  SORTER.ADB is where you need to encode the specific sort routines for the small, medium or large
--  array.  You only have access to call the SORT procedure and it determines which subsequent procedure 
--  gets invoked.  You will need to code each sorting routine, but you are not allowed to
--  to modify SORT.  The SORTER.ADB must not produce any output other than returning a sorted array. You
--  will submit your SORTER.ADB file.  Notice Spark Mode is set to ON
--
-- BEFORE YOU MAKE ANY MODIFICATIONS:
--
--   Open the project using the IDE
--
--   Notice it has 
--
--        --pragma Spark_Mode (on) (this line is commented out)
--
-- 
--   You are to run Spark->Examine All
--   Ensure the Multiprocess box is checked and Analysis Mode is set as Flow Analysis
--   Ensure this appears:  gnatprove -P%PP -j0 %X --mode=flow --output=oneline --ide-progress-bar
--   After it executes you may need to hit the Show Report tab
--   Comment on the results in a seperate txt file.
--
--   Then run Spark->Prove All
--   Ensure the Multiprocess box is checked and Prove level is set to Fast (0 level)
--   and this:  gnatprove -P%PP -j0 %X --level=0 --output=oneline --ide-progress-bar is set
--   Comment on the results in a seperate txt file (can be combined with the txt file above).
--
--  Then uncomment the pragma line e.g.  pragma Spark_Mode (on)
--
--   It likely will not allow you to run since Max cannot be verified.  This is an example of how Spark is different from Ada
--   within the array declaration, remove max and use 10000
--
--   You are to run Spark->Examine All
--   Ensure the Multiprocess box is checked and Analysis Mode is set as Flow Analysis
--   Ensure this appears:  gnatprove -P%PP -j0 %X --mode=flow --output=oneline --ide-progress-bar
--   After it executes you may need to hit the Show Report tab
--   Comment on the results in a seperate txt file (can be combined with the txt file above).
--
--   Then run Spark->Prove All
--   Ensure the Multiprocess box is checked and Prove level is set to Fast (0 level)
--   and this:  gnatprove -P%PP -j0 %X --level=0 --output=oneline --ide-progress-bar is set
--   Comment on the results (can be combined with the txt file above).
--
--
--  For your program, comment out Spark_mode(on) and reset the declaration to array(1..max)
--
--  Your program must read in a file of a fixed size (denoted by Max). But, you have to ask the user to 
--  enter the number of valid entries that are in the array.  For example, there may be 1000 elements in the array
--  but only 100 of them are valid.  The number of valid entries needs to be stored in the variable Sorter.Count 
--  which is defined in Sorter.ads You must ensure that Sorter.Count, when set, is itself valid.
--  The valid entries will always start at the first array position and will be continuous. Sorter is based on
--  receiveing arrays of a fixed size (determined by the value of Max).
--  
--  Your drvr code has to validate that the proper amount of the array was sorted and the rest of the array
--  is unmodified. It should produce the following output:
--
--  The size of the Array is XXX of which YYY are valid.
--  Then one of the following:
--      Array was sorted, remainder of the array was unmodified
--      Array was sorted, remainder of array was modified
--      Array was not sorted, remainder of array was unmodified
--      Array was not sorted, remainder of array was modified
--
--  You need to submit your entire projct (.gpr, src dirctory, obj directory, txt fil of comments running SPARK) you will likely need to zip it prior to submission  
--  If you work with a partner only one submission is required but
--  ensure both names are provided in the comments.

  pragma Spark_mode (on);

with Ada.Text_IO; use Ada.text_io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Sorter; use Sorter;

procedure Drvr is
   rand_file : File_Type;         -- input file which is 10k integers (this may vary in the final run but will be <= Max
   Max : Integer := 10000;     -- this is set on the size of the datafile, it is guarenteed to be greater than zero
                                  -- and no larger than the datafile, there is no need to check for this
   A : array_type(1..max);
                          
begin
   open(rand_file, In_File, ".\src\random10k.txt");-- opens a 10,000 element data file in the src directory
   for i in 1..max loop
      get(rand_file,A(i)); -- reads data from a text file
   end loop;
   close(rand_file); -- close the file (often forgotten)
end Drvr;

