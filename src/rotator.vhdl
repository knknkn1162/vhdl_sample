library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package rotator_type is
  constant M : integer := 2;
  constant N : integer := 32;
  type datatype is array(M-1 downto 0) of std_logic_vector(N-1 downto 0);
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.rotator_type.ALL;

entity rotator is
  port (
    clk, rst : in std_logic;
    load : in datatype;
    ans : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of rotator is
  constant M : integer := 2;
  constant N : integer := 32;
  signal val : datatype;
begin
  process(clk, rst)
    variable tmp : std_logic_vector(N-1 downto 0);
  begin
    if (rst = '1') then
      val <= load;
    elsif rising_edge(clk) then
      tmp := val(0);
      val(0) <= val(1);
      val(1) <= tmp;
    end if;
  end process;
  ans <= val(0);
end architecture;
