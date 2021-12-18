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
