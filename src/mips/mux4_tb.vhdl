library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4_tb is
end entity;

architecture testbench of mux4_tb is
  component mux4
    generic(N : natural);
    port (
      d00 : in std_logic_vector(N-1 downto 0);
      d01 : in std_logic_vector(N-1 downto 0);
      d10 : in std_logic_vector(N-1 downto 0);
      d11 : in std_logic_vector(N-1 downto 0);
      s : in std_logic_vector(1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
    );
  end component;

  constant N : natural := 8;
  constant d00 : std_logic_vector(N-1 downto 0) := "10000000";
  constant d01 : std_logic_vector(N-1 downto 0) := "10000001";
  constant d10 : std_logic_vector(N-1 downto 0) := "10000010";
  constant d11 : std_logic_vector(N-1 downto 0) := "10000011";
  signal s : std_logic_vector(1 downto 0);
  signal y : std_logic_vector(N-1 downto 0);

begin
  uut : mux4 generic map (N=>N)
  port map (
    d00 => d00, d01 => d01, d10 => d10, d11 => d11,
    s => s,
    y => y
  );

  stim_proc: process
  begin
    wait for 10 ns;
    s <= "00"; wait for 10 ns; assert y = "10000000";
    s <= "01"; wait for 10 ns; assert y = "10000001";
    s <= "10"; wait for 10 ns; assert y = "10000010";
    s <= "11"; wait for 10 ns; assert y = "10000011";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
