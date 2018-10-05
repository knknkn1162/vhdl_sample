library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux2_tb is
end entity;

architecture behavior of mux2_tb is
  component mux2 is
    port (
      d0, d1 : in std_logic_vector(3 downto 0);
      s : in std_logic;
      y : out std_logic_vector(3 downto 0)
    );
  end component;

  signal d0 : std_logic_vector(3 downto 0) := "1000";
  signal d1 : std_logic_vector(3 downto 0) := "0011";
  signal s : std_logic;
  signal y : std_logic_vector(3 downto 0);

begin
  uut : mux2 port map (
    d0 => d0,
    d1 => d1,
    s => s,
    y => y
  );


  stim_proc: process
  begin
    wait for 20 ns;
    s <= '0'; wait for 10 ns; assert y = d0;
    s <= '1'; wait for 10 ns; assert y = d1;
    assert false report "end of test" severity note;
    wait;
  end process;

end;
