--  This spec file can only be modified for testing by changeing the values of small and medium.  
--  Sort_1, Sort_2, Sort_3 must be different sorts: 
--  You do not submit this file.

Package Sorter 
  with SPARK_Mode => ON
is

-- The index of an array of array_type is an integer. 
-- An array of array_type stores integers, which may be positive, negative, zero
-- and may have duplicates

   type array_type is array (Integer range <>) of Integer; -- this is set in the drvr file

   count : Integer;  -- this represents the valid number of elements in an array, it is set by the user in the drvr file

   
   procedure sort(A : in out array_type; count : in integer);

   private -- everything below here is unseen by a user

   small  : constant Integer := 5;  -- do not plan on this remaining as 5
   medium : constant Integer := 10; -- do not plan on this remaining as 10
   
	procedure sort_1(A : in out array_type; count : in integer); -- small array sorting
	Procedure sort_2(A : in out array_type; count : in integer); -- medium array sorting
	Procedure sort_3(A : in out array_type; count : in integer); -- large array sorting

   
end Sorter;
