library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity regfile is
  port(
    clk, we3: in std_logic;
    ra1, ra2, wa3 : in std_logic_vector(4 downto 0);
    wd3 : in std_logic_vector(31 downto 0);
    rd1, rd2 : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of regfile is
  type ramtype is array (31 downto 0) of std_logic_vector(31 downto 0);
  signal mem : ramtype;

begin
  process(clk) begin

    if rising_edge(clk) then
      if we3='1' then mem(to_integer(unsigned(wa3))) <= wd3;
      end if;
    end if;
  end process;

  process(ra1) begin
    if(to_integer(unsigned(ra1)) = 0) then rd1 <= X"00000000";
    else rd1 <= mem(to_integer(unsigned(ra1)));
    end if;
  end process;
  process(ra2) begin
    if(to_integer(unsigned(ra2)) = 0) then rd2 <= X"00000000";
    else rd2 <= mem(to_integer(unsigned(ra2)));
    end if;
  end process;
end architecture;
