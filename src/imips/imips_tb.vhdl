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
      -- for testbench
      pc : out std_logic_vector(31 downto 0);
      instr : out std_logic_vector(31 downto 0);
      rs : out std_logic_vector(31 downto 0);
      rt : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      zero : out std_logic
        );
  end component;

  signal clk, reset : std_logic;
  signal addr : std_logic_vector(31 downto 0);
  signal pc, pcnext : std_logic_vector(31 downto 0);
  signal instr : std_logic_vector(31 downto 0);
  signal rs, rt : std_logic_vector(31 downto 0);
  signal zero : std_logic;
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut: imips port map (
    clk => clk, reset => reset,
    addr => addr,
    pc => pc,
    instr => instr,
    rs => rs, rt => rt,
    pcnext => pcnext,
    zero => zero
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc: process
  begin
    -- wait until rising_edge
    wait for clk_period/2;
    reset <= '1'; wait for 1 ns;
    -- input and reset
    addr <= X"00000000"; reset <= '0';
    wait for clk_period/2; 
    assert pc = X"00000000";
    assert instr = X"12320003";
    assert rs = X"00000001";
    assert rt = X"00000001";
    assert zero = '1';
    assert pcnext = X"00000010";
    wait for clk_period;
    assert pc = X"00000010";
    assert instr = X"12740019";
    assert rs = X"00000001";
    assert rt = X"00000002";
    assert zero = '0';
    assert pcnext = X"00000014";

    -- success message
    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
