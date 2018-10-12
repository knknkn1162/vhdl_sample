library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imips_tb is
end entity;

architecture behavior of imips_tb is
  component imips
    port (
      clk, reset : in std_logic;
      addr : in std_logic_vector(7 downto 0);
      pc : out std_logic_vector(31 downto 0);
      aluout : out std_logic_vector(31 downto 0)
        );
  end component;
  signal clk : std_logic;
  signal addr : std_logic_vector(7 downto 0);
begin

end architecture;
