library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package dot1_type is
  constant N : integer := 16;
  constant M : integer := 4;
  type mat_type is array(0 to M-1) of std_logic_vector(N-1 downto 0);
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.dot1_type.ALL;

entity dot1 is
  port (
    a : in mat_type;
    b : in mat_type;
    c : out std_logic_vector(2*N-1 downto 0)
  );
end entity;

architecture behavior of dot1 is
begin
  process(a, b)
    variable res : integer range -(2**(2*N-1)) to 2**(2*N-1)-1;
  begin
    if is_X(a(0)) or is_X(b(0)) then
      c <= (others => '0');
    else
      res := 0;
      for i in 0 to M-1 loop
        res := res + to_integer(signed(a(i)) * signed(b(i)));
      end loop;
      c <= std_logic_vector(to_signed(res, 2*N));
    end if;
  end process;
end architecture;
