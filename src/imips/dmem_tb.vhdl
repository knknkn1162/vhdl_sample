library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dmem_tb is
end entity;

architecture behavior of dmem_tb is
  component dmem
    port (
      clk, we : in std_logic;
      wd : in std_logic_vector(31 downto 0);
      addr: in std_logic_vector(31 downto 0);
      rd : out std_logic_vector(31 downto 0)
    );
  end component;
  constant clk_period :time := 10 ns;
  signal clk : std_logic;
  signal stop : boolean;
  signal we : std_logic;
  signal wd, addr, rd: std_logic_vector(31 downto 0);
begin
  uut : dmem port map(
    clk, we, wd, addr, rd
  );
  clk_process : process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc: process
  begin
    wait for clk_period;
    we <= '1';
    -- write data
    -- addr is 4 byte align because of MIPS instruction size
    addr <= X"000000" & B"00001100"; wd <= X"10000000";
    wait for clk_period;

    -- read data
    we <= '0';
    addr <= X"000000" & B"00001100";
    wait for 1 ns; assert rd = X"10000000";
    addr <= X"000000" & B"01000000";
    wait for 1 ns; assert rd = X"000000FF";

    -- success message
    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
end architecture;
