-- Your sort routine is only allowed to sort the appropriate amount of an array.
-- There is no manipulation beyond that, and no output is allowed within this package.
-- There must be three different sort routines, but you may select which three to use
-- If you have a partner only one submission is required but ensure both names are 
-- included in the comments. Using material from previous projects is allowed.


Package body Sorter 
  with SPARK_Mode => ON
is

   Procedure sort_1(A : in out array_type; count : in integer) is
      -- This is my Bubble sort which I surreptitiously aquired from my previous 
      -- homework. The only things that have been altered is that the loops for 
      -- sorting now have the upper bound set by the count instead of the 
      -- upper bound of the array. Relativly simple to implement and spark didn't
      -- seem upset
      
   begin
      for i in 1 .. count - 1 loop
         for j in 1 .. count - i loop            
            if A(j) > A(j + 1) then
               -- Swap A(j) and A(j + 1)
               declare
                  temp : Integer := A(j);
               begin
                  A(j) := A(j + 1);
                  A(j + 1) := temp;
               end;
            end if;
         end loop;
      end loop;
   end sort_1;
   

   Procedure sort_2(A : in out array_type; count : in Integer) is
      -- MERGE SORT TIME!!!!
      -- Who doesn't love merge sort (besides SPARK)
      -- Again, this is a sorting algorithm from my previous homework that I 
      -- adapted to work here. The only major concern Spark has was with the assignment
      -- of left and right sub arrays in the merge_sort procedure
      -- I was able to work around this by first assigning them into subtypes
      -- which SPARK was willing to accept
      -- I also alter the procedure to only sort the first "count" number of 
      -- elements in the array
      
    -- Procedure to merge two subarrays within a specified range
    procedure merge(left, right : array_type; result : in out array_type; count : Integer) is
        i: Integer := 1;
        j: Integer := 1;
        k: Integer := 1;
    begin
        -- Merge elements within the range defined by `count`
        while (i <= left'Length and j <= right'Length and k <= count) loop
            if left(i) <= right(j) then
                result(k) := left(i);
                i := i + 1;
            else
                result(k) := right(j);
                j := j + 1;
            end if;
            k := k + 1;
        end loop;

        -- Copy any remaining elements from the left array within range
        while i <= left'Length and k <= count loop
            result(k) := left(i);
            i := i + 1;
            k := k + 1;
        end loop;

        -- Copy any remaining elements from the right array within range
        while j <= right'Length and k <= count loop
            result(k) := right(j);
            j := j + 1;
            k := k + 1;
        end loop;
    end merge;

    -- Modified merge_sort procedure to sort only the first `count` elements in `A`
    procedure merge_sort(B : in out array_type; count : Integer) is
        middle : constant Integer := count / 2;
        subtype left_subtype is array_type(1 .. middle);
        subtype right_subtype is array_type(1 .. (count - middle));
        left   : left_subtype;
        right  : right_subtype;
    begin
        if count < 2 then
            return;
        end if;

        -- Copy the first half of `B` into `left`
        for i in 1 .. middle loop
            left(i) := B(i);
        end loop;

        -- Copy the second half of `B` into `right`
        for i in 1 .. (count - middle) loop
            right(i) := B(middle + i);
        end loop;

        -- Recursively sort each half of the array
        merge_sort(left, left'Length);
        merge_sort(right, right'Length);

        -- Merge sorted halves into the result within range
        merge(left, right, B, count);
    end merge_sort;

begin
    -- Sort only the first `count` elements in `A`
    merge_sort(A, count);
end sort_2;

   
   procedure sort_3(A : in out array_type; count : in Integer) is
      -- Last but not least, we've got quick_sort!
      -- This is the final of the sorting algorithms from my previous homework
      -- This one didn't actual throw any SPARK errors and after I altered the 
      -- upper range, it was good to go
    procedure quick_sort(low, high: Integer) is
        pivot : Integer := A((low + high) / 2);
        i     : Integer := low;
        j     : Integer := high;
    begin
        -- Partition the array around the pivot
        while i <= j loop
            while A(i) < pivot loop
                i := i + 1;
            end loop;

            while A(j) > pivot loop
                j := j - 1;
            end loop;

            if i <= j then
                declare
                    Temp : Integer := A(i);
                begin
                    A(i) := A(j);
                    A(j) := Temp;
                end;
                i := i + 1;
                j := j - 1;
            end if;
        end loop;

        -- Recursively sort each partition, but only within the range up to `count`
        if low < j and j <= count then
            quick_sort(low, j);
        end if;

        if i < high and i <= count then
            quick_sort(i, high);
        end if;
    end quick_sort;

begin
    -- Start QuickSort on the specified range (from 1 to count)
    if count > 1 then
        quick_sort(1, count);
    end if;
end sort_3;

   
-- No changes are allowed to Procedure sort
   Procedure sort(A : in out array_type; count : in integer) is
   begin
      if count <= small then
         sort_1(A, count);
      elsif count <= medium then
         sort_2(A, count);
      else sort_3(A, count); 
      end if;
   end sort;

end Sorter;
