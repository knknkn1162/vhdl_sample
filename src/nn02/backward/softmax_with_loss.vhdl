library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity softmax_with_loss is
  generic(N: integer);
  port (
    y : in arr_type(0 to N-1);
    t : in std_logic_vector(N-1 downto 0);
    a : out arr1_type(0 to N-1)
  );
end entity;

architecture testbench of softmax_with_loss is
  constant zero_or_one : arr_type(0 to 1) := ((others => '0'), (others => '1'));
  signal m : integer;
begin
  process(y, t)
    variable tmp : integer range -2**(SIZE) to 2**SIZE-1;
  begin
  if is_X(t) or is_X(y(0)) then
    a <= (others => (others => '-'));
  else
    for i in 0 to N-1 loop
      -- see https://stackoverflow.com/questions/34039510/std-logic-to-integer-conversion#comment84596633_34039685
      tmp := to_integer(signed(unsigned(y(i)) - unsigned(zero_or_one( to_integer(unsigned'('0' & t(i))) ))));
      a(i) <= std_logic_vector(to_signed(tmp, SIZE+1));
    end loop;
  end if;
  end process;
end architecture;
