library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_sample_tb is
end entity;

architecture behavior of reg_sample_tb is
  component reg
    generic(filename : string);
    port (
      clk, rst, load : in std_logic;
      -- 25:21(read)
      a1 : in std_logic_vector(4 downto 0);
      rd1 : out std_logic_vector(31 downto 0);
      -- 20:16(read)
      a2 : in std_logic_vector(4 downto 0);
      rd2 : out std_logic_vector(31 downto 0);

      a3 : in std_logic_vector(4 downto 0);
      wd3 : in std_logic_vector(31 downto 0);
      we3 : in std_logic
    );
  end component;
  signal clk, rst, load, we3 : std_logic;

  signal stop : boolean;
  signal a1, a2, a3 : std_logic_vector(4 downto 0);
  signal rd1, rd2, wd3 : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;
  constant filename : string := "./assets/regfile_sample.hex";

begin
  uut : reg generic map (filename=>filename)
  port map (
    clk => clk, rst => rst, load => load,
    a1 => a1,
    rd1 => rd1,
    a2 => a2,
    rd2 => rd2,
    a3 => a3,
    wd3 => wd3,
    we3 => we3
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
    wait for clk_period/2;
    rst <= '1'; wait for 1 ns; rst <= '0';
    -- check initialization of register
    a1 <= "00000"; wait for 1 ns; assert rd1 = X"00000000";
    a1 <= "00010"; wait for 1 ns; assert rd1 = X"00000000";
    a1 <= "00011"; wait for 1 ns; assert rd1 = X"00000000";
    a1 <= "10001"; wait for 1 ns; assert rd1 = X"00000000";
    load <= '1'; wait for clk_period/2 + 1 ns; load <= '0';

    -- check whether the regiter is preloaded
    a1 <= "00000"; wait for 1 ns; assert rd1 = X"00000000";
    a1 <= "00010"; wait for 1 ns; assert rd1 = X"00000000";
    a1 <= "00011"; wait for 1 ns; assert rd1 = X"00000001";
    a1 <= "10001"; wait for 1 ns; assert rd1 = X"00000002";

    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
