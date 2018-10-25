import math
SIZE = 8
is_if = True
prev = 0
for i in range(1, 2**SIZE):
    # if(input=0) then b := 0;
    # elsif (input>0 and input<97) then b := 2;
    cur = round(math.log(i/(2**SIZE-i)) * (2**SIZE))
    if is_if:
        print("if a < {0} then b := {1};".format(cur, i-1));
        is_if = False
    else:
        print("elsif (a >= {0} and a < {1}) then b := {2};".format(prev, cur, i-1))
    prev = cur
print("else b := {0};".format(2**SIZE-1))
print("end if;")
