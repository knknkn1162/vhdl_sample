library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shiftreg is
  generic(N: integer := 8);
  port (
    clk, reset : in std_logic;
    load : in std_logic;
    sin : in std_logic_vector(0 downto 0);
    d : in std_logic_vector(N-1 downto 0);
    q : out std_logic_vector(N-1 downto 0);
    sout : out std_logic
       );
end entity;

architecture synth of shiftreg is
  -- immediate signal
  signal q_tmp: std_logic_vector(N-1 downto 0);
begin
  process(clk, reset) begin
    if reset = '1' then q <= (others => '0');
    elsif rising_edge(clk) then
      if load='1' then q <=d;
      else
        q <= q_tmp;
        q <= q_tmp(N-2 downto 0) & sin;
      end if;
    end if;
  end process;
end architecture;
