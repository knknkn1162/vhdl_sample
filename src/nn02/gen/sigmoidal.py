import math
SIZE = 8
print("if (input=0) then b := 0;")
prev = 0
for i in range(1, 2**(SIZE-1)):
    # if(input=0) then b := 0;
    # elsif (input>0 and input<97) then b := 2;
    cur = round(math.log((2**(SIZE-1)+i)/(2**(SIZE-1)-i))*(2**(SIZE-1)))
    print("elsif (input>={0} and input<{1}) then b := {2};".format(prev, cur, i-1))
    prev = cur
print("else b := {0}".format(2**(SIZE-1)-1))
print("end if")
