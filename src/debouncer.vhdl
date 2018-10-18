library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
  generic(max : integer := 5);
  port (
    x : in std_logic;
    clk : in std_logic;
    y : out std_logic
  );
end entity;


architecture behavior of debouncer is
  signal y0 : std_logic;
  signal cnt : integer;
begin
  process(clk)
    variable count : integer;
  begin
    if rising_edge(clk) then
      if is_X(x) then
        y0 <= '-';
        count := 0;
      elsif (y0 /= x) then
        count := count + 1;
        if (count = max) then
          count := 0;
          y0 <= x;
        end if;
      else
        count := 0;
      end if;
    end if;
    cnt <= count;
  end process;
  y <= y0;
end architecture;
