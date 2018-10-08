library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_tri is
  port (
    d0, d1 : in std_logic;
    s : in std_logic;
    y : out std_logic
       );
end entity;

architecture struct of mux_tri is
  component tri 
    port (
      a : in std_logic;
      en : in std_logic;
      y : out std_logic
    );
  end component;
  signal sbar : std_logic;

begin
  sbar <= not s;
  t0 : tri port map (d0, sbar, y);
  t1 : tri port map (d1, s, y);
end architecture;
