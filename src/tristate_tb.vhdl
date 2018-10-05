library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tristate_tb is
end entity;

architecture behavior of tristate_tb is
  component tristate is
    port (
      a : in std_logic_vector(3 downto 0);
      en : in std_logic;
      y : out std_logic_vector(3 downto 0)
         );
  end component;

  signal a : std_logic_vector(3 downto 0) := "1001";
  signal en : std_logic;
  signal y : std_logic_vector(3 downto 0);

begin
  uut : tristate port map (
    a => a,
    en => en,
    y => y
  );

  stim_proc: process
  begin
    wait for 20 ns;
    en <= '0'; wait for 10 ns; assert y = "ZZZZ";
    en <= '1'; wait for 10 ns; assert y = "1001";
    wait;
  end process;
end architecture;
