<id: test>
<;>
1: test;
2: //&T-
3: // no global declaration(s)
4: 
5: func( a: integer ; b: array 1 to 2 of array 2 to 4 of real ): boolean;
6: begin
7:         var c: "hello world!";
8:         begin
9:                 var d: real;
10:                 return (b[1][4] >= 1.0);
==============================================================================================================
Name                             Kind       Level      Type             Attribute  
--------------------------------------------------------------------------------------------------------------
d                                variable   2(local)   real             
--------------------------------------------------------------------------------------------------------------
11:         end
==============================================================================================================
Name                             Kind       Level      Type             Attribute  
--------------------------------------------------------------------------------------------------------------
a                                parameter  1(local)   integer          
b                                parameter  1(local)   real [2][3]      
c                                constant   1(local)   string           "hello world!"
--------------------------------------------------------------------------------------------------------------
12: end
13: end func
14: 
15: begin
16:         var a: integer;
17:         begin
18:                 var a: boolean; // outer 'a' has been hidden in this scope
==============================================================================================================
Name                             Kind       Level      Type             Attribute  
--------------------------------------------------------------------------------------------------------------
a                                variable   2(local)   boolean          
--------------------------------------------------------------------------------------------------------------
19:         end
==============================================================================================================
Name                             Kind       Level      Type             Attribute  
--------------------------------------------------------------------------------------------------------------
a                                variable   1(local)   integer          
--------------------------------------------------------------------------------------------------------------
20: end
==============================================================================================================
Name                             Kind       Level      Type             Attribute  
--------------------------------------------------------------------------------------------------------------
test                             program    0(global)  void             
func                             function   0(global)  boolean          integer, real [2][3]
--------------------------------------------------------------------------------------------------------------
21: end test