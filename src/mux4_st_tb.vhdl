library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4_st_tb is
end entity;

architecture behavior of mux4_st_tb is
  component mux4_st is
    port (
      d0, d1, d2, d3 : in std_logic_vector(3 downto 0);
      s : in std_logic_vector(1 downto 0);
      y  : out std_logic_vector(3 downto 0)
    );
  end component;

  signal d0 : std_logic_vector(3 downto 0) := "1000";
  signal d1 : std_logic_vector(3 downto 0) := "0100";
  signal d2 : std_logic_vector(3 downto 0) := "0010";
  signal d3 : std_logic_vector(3 downto 0) := "0001";
  signal input : std_logic_vector(1 downto 0);
  signal output : std_logic_vector(3 downto 0);

begin
  uut: mux4_st port map (
    d0 => d0,
    d1 => d1,
    d2 => d2,
    d3 => d3,
    s => input,
    y => output
  );

  stim_proc: process
  begin
    wait for 20 ns;
    input <= "00"; wait for 10 ns; assert output = d0;
    input <= "01"; wait for 10 ns; assert output = d1;
    input <= "10"; wait for 10 ns; assert output = d2;
    input <= "11"; wait for 10 ns; assert output = d3;
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
