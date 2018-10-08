library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter0 is
  port (
    clk, reset : in std_logic;
    updown: in std_logic;
    q : out std_logic_vector(3 downto 0)
       );
end entity;

architecture behavior of counter0 is
  signal cnt: unsigned(3 downto 0);
begin
  process (clk, reset) begin
    if reset = '1' then
      cnt <= "0000";
    elsif rising_edge(clk) then
      if updown = '1' then
        cnt <= cnt + 1;
      else
        cnt <= cnt - 1;
      end if;
    end if;
  end process;
  q <= std_logic_vector(cnt);
end architecture;
