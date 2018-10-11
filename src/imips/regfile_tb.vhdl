library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regfile_tb is
end entity;

architecture behavior of regfile_tb is
  component regfile
    port (
      clk : in std_logic;
      -- 25:21(read)
      addr1 : in std_logic_vector(4 downto 0);
      rd1 : out std_logic_vector(31 downto 0);
      -- 20:16(read)
      -- a2 : in std_logic_vector(4 downto 0);
      -- rd2 : out std_logic_vector(31 downto 0);

      -- 20:16(write)
      addr3 : in std_logic_vector(4 downto 0);
      wd3 : in std_logic_vector(31 downto 0);
      we3 : in std_logic
    );
  end component;
  signal clk, we3 : std_logic;

  signal stop : boolean;
  signal addr1, addr3 : std_logic_vector(4 downto 0);
  signal rd1, wd3 : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;

begin
  uut : regfile port map (
    clk, addr1, rd1, addr3, wd3, we3
  );
  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for clk_period;
    -- write into memory
    we3 <= '1';
    addr3 <= "00000"; wd3 <= X"00000001"; wait for clk_period;
    addr3 <= "00001"; wd3 <= X"00000011"; wait for clk_period;

    -- read from mem
    addr1 <= "00000"; wait for 1 ns; assert rd1 = X"00000000";
    addr1 <= "00001"; wait for 1 ns; assert rd1 = X"00000011";
    -- if we3='0' when rising_edge, stay the same.
    addr3 <= "00001"; wd3 <= X"00000111"; wait for 1 ns;
    we3 <= '0'; wait for 3 ns;
    addr1 <= "00001"; wait for 1 ns; assert rd1 = X"00000011";
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
  
end architecture;
