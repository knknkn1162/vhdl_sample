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
      rs, rt : out std_logic_vector(31 downto 0);
      addr_rt_rd : out std_logic_vector(4 downto 0);
      aluout : out std_logic_vector(31 downto 0);
      shamt : out std_logic_vector(31 downto 0);
      wdata : out std_logic_vector(31 downto 0)
        );
  end component;
  signal clk, reset : std_logic;
  signal addr : std_logic_vector(31 downto 0);
  signal pc : std_logic_vector(31 downto 0);
  signal instr : std_logic_vector(31 downto 0);
  signal rs, rt : std_logic_vector(31 downto 0);
  signal addr_rt_rd : std_logic_vector(4 downto 0);
  signal aluout : std_logic_vector(31 downto 0);
  signal shamt : std_logic_vector(31 downto 0);
  signal wdata : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut: imips port map (
    clk => clk, reset => reset,
    addr => addr,
    pc => pc,
    instr => instr,
    rs => rs, rt => rt,
    addr_rt_rd => addr_rt_rd,
    aluout => aluout,
    shamt => shamt,
    wdata => wdata
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
    addr <= X"00000000"; reset <= '0';
    -- mem(0) <= X"02114020"; --add
    -- mem(1) <= X"02114822"; -- sub
    -- mem(2) <= X"02114025"; -- or
    -- mem(3) <= X"02115824"; -- and
    -- mem(4) <= X"00106100"; -- sll
    wait for clk_period/2; 
    assert pc = X"00000000";
    assert instr = X"02114020";
    assert rs = X"00000001";
    assert rt = X"00000002";
    assert aluout = X"00000003";
    assert wdata = X"00000003";

    wait for clk_period;
    assert pc = X"00000004";
    assert instr = X"02114822";
    assert rs = X"00000001";
    assert rt = X"00000002";
    assert aluout = X"FFFFFFFF";
    assert wdata = X"FFFFFFFF";

    wait for clk_period;
    assert pc = X"00000008";
    assert instr = X"02114025";
    assert rs = X"00000001";
    assert rt = X"00000002";
    assert aluout = X"00000003";
    assert wdata = X"00000003";

    wait for clk_period;
    assert pc = X"0000000c";
    assert instr = X"02115824";
    assert rs = X"00000001";
    assert rt = X"00000002";
    assert aluout = X"00000000";
    assert wdata = X"00000000";

    wait for clk_period;
    assert pc = X"00000010";
    assert instr = X"00106100";
    assert rs = X"00000000";
    assert rt = X"00000001";
    assert shamt = X"00000010";
    assert wdata = X"00000010";

    -- success message
    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
