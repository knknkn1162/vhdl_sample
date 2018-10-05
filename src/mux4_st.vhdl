/*
% ghdl -a mux4_st.vhdl mux2.vhdl mux4_st_tb.vhdl
% ghdl -e mux4_st_tb
% ghdl -r mux4_st_tb --vcd=out.vcd
% open out.vcd
*/

mux4_st_tb.vhdl:40:5:@60ns:(assertion note): end of test
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4_st is
  port (
    d0, d1, d2, d3 : in std_logic_vector(3 downto 0);
    s : in std_logic_vector(1 downto 0);
    y : out std_logic_vector(3 downto 0)
       );
end entity;

architecture struct of mux4_st is
  component mux2 is
    port (
      d0, d1 : in std_logic_vector(3 downto 0);
      s : in std_logic;
      y : out std_logic_vector(3 downto 0)
         );
  end component;

  signal low, high: std_logic_vector(3 downto 0);

begin
  lowmux : mux2 port map(d0, d1, s(0), low);
  highmux : mux2 port map(d2, d3, s(0), high);
  finalmux : mux2 port map(low, high, s(1), y);
end architecture;
