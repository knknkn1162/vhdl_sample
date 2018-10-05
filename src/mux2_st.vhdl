library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_st is
  port (
    d0, d1 : in std_logic_vector(3 downto 0);
    s : in std_logic;
    y : out std_logic_vector(3 downto 0)
       );
end entity;

architecture struct of mux2_st is
  component tristate
    port (
      a : in std_logic_vector(3 downto 0);
      en : in std_logic;
      y : out std_logic_vector(3 downto 0)
         );
  end component;

  signal sbar: std_logic;

begin
  sbar <= not s;
  t0: tristate port map(d0, sbar, y);
  t1: tristate port map(d1, s, y);
end architecture;
