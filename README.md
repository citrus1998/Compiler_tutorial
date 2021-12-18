# compiler_tutorial 
For my assignment in the lecture  
Since 2019  
  
## flex  
### Input  
~~~
flex sample.l
~~~  
~~~
gcc -o program lex.yy.c -ll
~~~  
~~~
echo 2+3*10 | ./program
~~~  
### Output  
~~~
[ 1] tag = 1, text = 2  
[ 2] tag = 2, text = +  
[ 3] tag = 1, text = 3  
[ 4] tag = 2, text = *  
[ 5] tag = 1, text = 10  
~~~   
## flex + bison  
### Input  
~~~
flex eucom.l
~~~  
~~~
bison eucom.y
~~~
~~~
gcc -o eucom eucom.tab.c -ll
~~~  
~~~
echo 1*2+3 | ./eucom
~~~  
### Output  
~~~
SET R0, 1  
SET R1, 2  
MUL R0, R1  
SET R1, 3  
ADD R0, R1  
PRINT R0  
~~~  
