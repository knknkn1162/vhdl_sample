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
  signal m : std_logic_vector(SIZE downto 0); --integer;

begin
  process(y, t)
    --variable tmp : integer range -2**(SIZE) to 2**SIZE-1;
    variable tmp : std_logic_vector(SIZE downto 0);
  begin
  if is_X(t) or is_X(y(0)) then
    a <= (others => (others => '-'));
  else
    for i in 0 to N-1 loop
      -- https://www.edaboard.com/showthread.php?310376-Unsigned-and-Signed-Addition-and-subtraction-VHDL&p=1327786&viewfull=1#post1327786
      -- unsigned("0" & y(i)) : can't resolve overload for operator "&"
      tmp := std_logic_vector(unsigned('0' & y(i)) - unsigned('0' & zero_or_one( to_integer(unsigned'('0' & t(i))) )));
      if i = 1 then
        m <= tmp;
      end if;
      a(i) <= std_logic_vector(signed(tmp));
    end loop;
  end if;
  end process;
end architecture;
