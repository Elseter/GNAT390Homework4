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
   Max : Integer := 10000;        -- this is set on the size of the datafile, it is guarenteed to be greater than zero
   Current_array_size: Integer := Max;       -- and no larger than the datafile, there is no need to check for this
   A : array_type(1..10000) := (others => 0);
   choice : Integer;
   Original_Array : array_type(1..10000) := (others => 0);
   
   -- Helper Procedures
   -- ---------------------------------------------------------------------------------------------
   
   procedure validator(A: in array_type; count : in Integer) is
      -- The tricky part of validating a sort is addressing acidental sorts
      -- Which in this case would involve the element directly following the 
      -- sorted portion of the array, purely by coincidence, being in the correct
      -- index to be sorted. This could make a sort of 15 elements, look like it
      -- sorted 16 or maybe even 17 if you get extraordinarily unlucky/lucky.
      -- My first insinct was to rescramble the array after the first `count` 
      -- elements. However, we do not know if those elements are in use or are 
      -- serving a purpose in their current order. With that in mind, I've decided 
      -- create a copy of the array which we can use for validation. While computationally more expensive,
      -- it allows us to check for false positives. This copy array will only be
      -- created if it is suspected that the array was sorted
      Sorted : Boolean := True;
      Modified : Boolean := False;
   begin

      -- Check if the original array is sorted
      for i in 1..count - 1 loop
         if A(i) > A(i + 1) then
            Sorted := False;
            exit;
         end if;
      end loop;

      -- Check if the original array was modified
      for i in count + 1..Current_array_size loop
         if A(i) /= Original_Array(i) then
            Modified := True;
            exit;
         end if;
      end loop;

      -- print the 4 possible outcomes
      if Sorted and not Modified then
         Put("Array was sorted, remainder of the array was unmodified");
         New_Line;
      elsif Sorted and Modified then
         Put("Array was sorted, remainder of array was modified");
         New_Line;
      elsif not Sorted and not Modified then
         Put("Array was not sorted, remainder of array was unmodified");
         New_Line;
      else
         Put("Array was not sorted, remainder of array was modified");
         New_Line;
      end if;
   end validator;

   procedure Fetch_Safe_Input(Min : Integer; Max : Integer; Input : out Integer) is
   Input_String : String(1..10);
   Length       : Natural;
   Valid        : Boolean := False;

   -- Helper function to check if all characters are digits
   function Is_Digit_String(S : String; Len : Natural) return Boolean is
   begin
      for I in 1 .. Len loop
         if not (S(I) in '0' .. '9') then
            return False;
         end if;
      end loop;
      return True;
   end Is_Digit_String;

   -- Helper function to convert digit string to integer
   function String_To_Integer(S : String; Len : Natural) return Integer is
      Result : Integer := 0;
   begin
      for I in 1 .. Len loop
         if I <= S'Length then
            Result := Result * 10 + Character'Pos(S(I)) - Character'Pos('0');
         end if;
      end loop;
      return Result;
   end String_To_Integer;

begin
   while not Valid loop
      Get_Line(Input_String, Length);

      -- Check if input is a valid integer string
      if Is_Digit_String(Input_String(1..Length), Length) then
         Input := String_To_Integer(Input_String(1..Length), Length);

         -- Check if input is within the specified range
         if Input >= Min and Input <= Max then
            Valid := True;
         else
            Put_Line("Invalid entry. Please enter a value between " & Integer'Image(Min) & " and " & Integer'Image(Max));
         end if;
      else
         Put_Line("Invalid entry. Please enter an integer value.");
      end if;
   end loop;
end Fetch_Safe_Input;


   procedure fetch_array(A : in out array_type; size : in Integer) is
   begin
      -- Procedure to fetch a random array of size size from the file
         open(rand_file, In_File, ".\src\random10k.txt");-- opens a 10,000 element data file in the src directory
         for i in 1..size loop
            get(rand_file,A(i)); -- reads data from a text file
         end loop;
         close(rand_file); -- close the file (often forgotten)
   end fetch_array;
   
-- Main
-- ---------------------------------------------------------------------------------------------
                          
begin
   -- Fetch the array from the file
   fetch_array(A, Max);
   Original_Array := A;

   Put("Welcome to the array sorter program."); New_Line;
   Put("The size of the Array is" & Integer'Image(Max)); New_Line;
   -- Create an infinite menu where the user can attempt to validate the array with a count or sort the array with a count
   loop
      New_Line;
      Put("Array Sorter Menu:"); New_Line;
      Put("1. Restrict Array View (also rescrambles array sort):"); New_Line;
      Put("2. Sort the array with a count:"); New_Line;
      Put("3. Validate the array with a count:"); New_Line;
      Put("4. Exit the program."); New_Line;

      -- Get user input for the menu
      Put("Enter your choice: ");
      fetch_safe_input(1, 4, choice);

      -- logic for the menu
      case choice is
         when 1 =>
            Put("Enter the how much of the array you'd like visable (it still takes up" & Integer'Image(max) & " ints in memory): ");
            fetch_safe_input(1, Max, Current_array_size);
            Put("The size of the Array is" & Integer'Image(Current_array_size)); New_Line;
            fetch_array(A, Current_array_size);
         when 2 =>
            Put("Enter the number of valid entries: ");
            fetch_safe_input(0, Current_array_size, Sorter.Count);
            Put("The size of the Array is" & Integer'Image(Current_array_size) & " of which" & Integer'Image(Sorter.Count) & " are sorted."); New_Line;
            sort(A, Sorter.Count);

            -- print the array to check if it was sorted
            for i in  1.. Current_array_size loop
               Put(Integer'Image(A(i))); New_Line;
            end loop;
         when 3 =>
            Put("Enter the number of valid entries: ");
            fetch_safe_input(1, Current_array_size, Sorter.Count);
            validator(A, Sorter.Count);
         when 4 =>
            exit;
         when others =>
            Put("Invalid choice. Please enter a value between 1 and 4."); New_Line;
      end case;

   end loop;

end Drvr;
