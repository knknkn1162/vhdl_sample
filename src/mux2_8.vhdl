library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_8 is
  port (
    d0, d1 : in std_logic_vector(7 downto 0);
    s : in std_logic;
    y : out std_logic_vector(7 downto 0)
       );
end entity;

architecture struct of mux2_8 is
  component mux2 is
    port (
      d0, d1 : in std_logic_vector(3 downto 0);
      s : in std_logic;
      y : out std_logic_vector(3 downto 0)
         );
  end component;

begin
  lsbmux: mux2 port map(d0(3 downto 0), d1(3 downto 0), s, y(3 downto 0));
  msbmux: mux2 port map(d0(7 downto 4), d1(7 downto 4), s, y(7 downto 4));
end architecture;
