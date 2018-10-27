import math
INPUT_SIZE = 8
WSIZE = 5
SIZE = INPUT_SIZE + WSIZE

is_if = True
prev = 0
print("if a = 0 then b := 256;");
for i in range(2, 2**8+2, 2):
    val = round(math.log(i)*(2**INPUT_SIZE));
    cur = i
    print("elsif (a >= {0} and a < {1}) then b := {2};".format(prev, cur, val))
    prev = i
