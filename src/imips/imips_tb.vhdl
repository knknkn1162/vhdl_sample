library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imips_tb is
end entity;

architecture behavior of imips_tb is
  component imips
    port (
      clk, reset : in std_logic;
      addr : in std_logic_vector(31 downto 0);
      pc : out std_logic_vector(31 downto 0);
      instr : out std_logic_vector(31 downto 0);
      aluout : out std_logic_vector(31 downto 0)
        );
  end component;
  signal clk, reset : std_logic;
  signal addr : std_logic_vector(31 downto 0);
  signal pc : std_logic_vector(31 downto 0);
  signal instr : std_logic_vector(31 downto 0);
  signal aluout : std_logic_vector(31 downto 0);
  signal clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut: imips port map (
    clk, reset, addr, pc, instr, aluout
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period;
      clk <= '1'; wait for clk_period;
    end loop;
    wait;
  end process;

  stim_proc: process
  begin
    reset <= '1'; wait for 1 ns; reset <= '0';
    addr <= X"00000000";
    wait for clk_period/2; 
    assert pc = X"00000004";
    assert instr = X"20100005";
    --assert aluout = X"00000005";
    -- success message
    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
