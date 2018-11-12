library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register2 is
  generic(N: natural);
  port (
    clk, rst, en : in std_logic;
    a0 : in std_logic_vector(N-1 downto 0);
    a1 : out std_logic_vector(N-1 downto 0);
    a2 : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of shift_register2 is
  component flopr_en is
    generic(N : natural);
    port (
      clk, rst, en : in std_logic;
      a : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal a10 : std_logic_vector(N-1 downto 0);
begin
  flopr_rt0 : flopr_en generic map(N=>N)
  port map(
    clk => clk, rst => rst, en => en,
    a => a0, y => a10
  );
  a1 <= a10;

  flopr_rt1 : flopr_en generic map(N=>N)
  port map(
    clk => clk, rst => rst, en => en,
    a => a10, y => a2
  );
end architecture;
