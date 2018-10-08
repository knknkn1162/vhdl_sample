library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_tb is
end entity;

architecture testbench of ram_tb is
  component ram is
    port(
      datain : in std_logic_vector(7 downto 0);
      address : in std_logic_vector(7 downto 0);
      w_r : in std_logic;
      dataout : out std_logic_vector(7 downto 0)
        );
  end component;
  signal datain : std_logic_vector(7 downto 0) := "00000000";
  signal address : std_logic_vector(7 downto 0) := "00000000";
  signal w_r : std_logic := '0';
  signal dataout : std_logic_vector(7 downto 0);

begin
  uut : ram port map(datain, address, w_r, dataout);
  stim_proc: process
  begin
    -- write data into ram
    wait for 100 ns;
    address <= "10000000"; datain <= "01111111"; wait for 100 ns;
    address <= "01000000"; datain <= "10111111"; wait for 100 ns;
    address <= "00100000"; datain <= "11011111"; wait for 100 ns;
    address <= "00010000"; datain <= "11101111"; wait for 110 ns;

    -- read data from ram
    w_r <= '1'; address <= "00000000"; wait for 100 ns;
    address <= "10000000"; wait for 100 ns; assert dataout = "01111111";
    address <= "01000000"; wait for 100 ns; assert dataout = "10111111";
    address <= "00100000"; wait for 100 ns; assert dataout = "11011111";
    address <= "00010000"; wait for 100 ns; assert dataout = "11101111";
    -- success message
    assert false report "end of test" severity note;
    wait;

  end process;
end architecture;
