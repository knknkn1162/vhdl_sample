library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips_tb is
end entity;

architecture behavior of mips_tb is
  component mips
    port (
      clk, reset : in std_logic;
      addr : in std_logic_vector(31 downto 0);
      -- for testbench
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      instr : out std_logic_vector(31 downto 0);
      a3 : out std_logic_vector(4 downto 0);
      wdata : out std_logic_vector(31 downto 0);
      rs, rt : out std_logic_vector(31 downto 0);
      rt_imm : out std_logic_vector(31 downto 0);
      aluout : out std_logic_vector(31 downto 0);
      rdata : out std_logic_vector(31 downto 0)
        );
  end component;
  signal clk, reset : std_logic;
  signal addr : std_logic_vector(31 downto 0);
  signal pc, pcnext : std_logic_vector(31 downto 0);
  signal a3 : std_logic_vector(4 downto 0);
  signal instr : std_logic_vector(31 downto 0);
  signal wdata : std_logic_vector(31 downto 0);
  signal rs, rt, rt_imm : std_logic_vector(31 downto 0);
  signal aluout : std_logic_vector(31 downto 0);
  signal rdata : std_logic_vector(31 downto 0);

  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut: mips port map (
    clk => clk, reset => reset,
    addr => addr,
    pc => pc,
    -- for testbench
    pcnext => pcnext,
    instr => instr,
    a3 => a3,
    wdata => wdata,
    rs => rs, rt => rt,
    rt_imm => rt_imm,
    aluout => aluout,
    rdata => rdata
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

    -- main:   addi $2, $0, 5      # initialize $2 = 5  0       20020005
    wait for clk_period/2;
    assert pc = X"00000000";
    assert instr = X"20020005";
    assert rs = X"00000000";
    assert rt_imm = X"00000005";
    assert aluout = X"00000005";
    assert a3 = "00010";
    assert wdata = X"00000005";

    -- addi $3, $0, 12     # initialize $3 = 12 4       2003000c
    wait for clk_period;
    assert pc = X"00000004";
    assert instr = X"2030000c";
    assert rs = X"00000000";
    assert rt_imm = X"000000c";
    assert aluout = X"0000000c";
    assert a3 = "00011";
    assert wdata = X"0000000c";

    -- success message
    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
