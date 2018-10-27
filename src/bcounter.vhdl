library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity count8n is
  port (
    clk : in std_logic;
    rst : in std_logic; --- async
    clr : in std_logic; -- sync
    cout : out std_logic_vector(2 downto 0)
  );
end entity;

architecture behavior of count8n is
  signal d : std_logic_vector(2 downto 0);

begin
  process(clk, rst, clr) begin
    if rst = '0' then
      d <= "000";
    elsif rising_edge(clk) then
      if (clr = '1') then
        d <= "000";
      elsif d = "111" then
        d <= "000";
      else
        d <= std_logic_vector(to_unsigned(to_integer(unsigned(d) + 1), 3));
      end if;
    end if;
  end process;
  cout <= d;
end architecture;
