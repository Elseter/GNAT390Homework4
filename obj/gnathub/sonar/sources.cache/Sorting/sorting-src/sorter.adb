-- Your sort routine is only allowed to sort the appropriate amount of an array.
-- There is no manipulation beyond that, and no output is allowed within this package.
-- There must be three different sort routines, but you may select which three to use
-- If you have a partner only one submission is required but ensure both names are 
-- included in the comments. Using material from previous projects is allowed.


Package body Sorter 
  with SPARK_Mode => ON
is

    Procedure sort_1(A : in out array_type; count : in integer) is
    begin
      null;
    end sort_1;


    Procedure sort_2(A : in out array_type; count : in integer) is
    begin
	null;
    end sort_2;
   
   Procedure sort_3(A : in out array_type; count : in integer) is
   begin
	null;
   end sort_3;
   
-- No changes are allowed to Procedure sort
   Procedure sort(A : in out array_type; count : in integer) is
   begin
      if A'length <= small then
         sort_1(A, count);
      elsif A'length <= medium then
         sort_2(A, count);
      else sort_3(A, count); 
      end if;
   end sort;

end Sorter;
