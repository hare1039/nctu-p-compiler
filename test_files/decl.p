/**
 * decl.p: declarations
 */
//&T-
//&D+
decl;

// global variables declaration
var ga: integer;
var gb, gc: boolean;
var gd: real;
var ge: string;
var garray: array 1 to 10 of integer;
var garray2: array 1 to 2 of array 1 to 3 of array 1 to 4 of boolean;
var gb: real; 

// global constants declaration
var PI: 3.1415926;
var course: "Introduction to Compiler Design";
var isPass: true;
   //  ; b:array 1 to 2 of array 2 to 4 of real 
func( a:integer; b, q :real; c: boolean; ffd: array 1 to 100 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of array 5 to 10 of boolean): boolean;
begin
   var x: "hello world";
   begin
	  var aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbb: real;
	  return 1 > 2;
   end
end
end func



begin
        // local constants declaration
        var arraySize: 1024;

        // local variables declaration
        var la: integer;
        var lb, lc, ld: boolean;
        var le, lf: real;
        var lg: string;
        var L1darray: array 1 to 5 of integer;                  // one dimensional
        var L2darray: array 1 to 5 of array 1 to 3 of integer;  // two dimensional

		var lg: integer;
        var lg: real;
        for k := 10 to 20 do
		   print k*3;
		   print "\n";
		   for j := 20 to 30 do
			  j := 10;
		      for k := 40 to 50 do
				 k := 10;
			  end do
		   end do
        end do

end
end decl
