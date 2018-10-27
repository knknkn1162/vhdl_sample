library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
  generic(cycles : natural);
  port (
    clk, rst, ena : in std_logic;
    full_count : out std_logic;
    dig1 : out std_logic_vector(2 downto 0);
    dig2 : out std_logic_vector(3 downto 0)
  );
end entity;

architecture behavior of timer is

begin
  process(clk, rst, ena)
    variable clk_cnt : natural range 0 to cycles;
    variable count1 : natural range 0 to 6;
    variable count2 : natural range 0 to 10;
  begin
    if (rst='1') then
      count1 := 0; count2 := 0;
      full_count <= '0';
    elsif rising_edge(clk) then
      if ena='1' then
        clk_cnt := clk_cnt + 1;
        if clk_cnt=cycles then
          clk_cnt := 0;
          count2 := count2 + 1;
          -- carry
          if (count2 = 10) then
            count2 := 0; count1 := count1 + 1;
          end if;
          if (count2 = 0 and count1 = 6) then
            full_count <= '1';
          end if;
        end if;
      end if;
    end if;
    dig1 <= std_logic_vector(to_unsigned(count1, dig1'length));
    dig2 <= std_logic_vector(to_unsigned(count2, dig2'length));
  end process;
end architecture;
