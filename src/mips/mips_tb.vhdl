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
    reset <= '1';
    addr <= X"00000000";
    wait for 1 ns; reset <= '0';

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
    assert instr = X"2003000c";
    assert rs = X"00000000";
    assert rt_imm = X"0000000c";
    assert aluout = X"0000000c";
    assert a3 = "00011";
    assert wdata = X"0000000c";

    -- addi $7, $3, -9     # initialize $7 = 3  8       2067fff7
    wait for clk_period;
    assert pc = X"00000008";
    assert instr = X"2067fff7";
    assert rs = X"0000000c";
    assert rt_imm = X"FFFFFFF7";
    assert aluout = X"00000003";
    assert a3 = "00111";
    assert wdata = X"00000003";

    -- or   $4, $7, $2     # $4 <= 3 or 5 = 7   c       00e22025
    wait for clk_period;
    assert pc = X"0000000c";
    assert instr = X"00e22025";
    assert rs = X"00000003"; -- $7
    assert rt_imm = X"00000005"; -- $2
    assert aluout = X"00000007";
    assert a3 = "00100"; -- $4
    assert wdata = X"00000007";

    -- and $5,  $3, $4     # $5 <= 12 and 7 = 4 10      00642824
    wait for clk_period;
    assert pc = X"00000010";
    assert instr = X"00642824";
    assert rs = X"0000000c"; -- $3
    assert rt_imm = X"00000007"; -- $4
    assert aluout = X"00000004";
    assert a3 = "00101"; -- $5
    assert wdata = X"00000004";

    -- add $5,  $5, $4     # $5 = 4 + 7 = 11    14      00a42820
    wait for clk_period;
    assert pc = X"00000014";
    assert instr = X"00a42820";
    assert rs = X"00000004"; -- $5
    assert rt_imm = X"00000007"; -- $4
    assert aluout = X"0000000b";
    assert a3 = "00101"; -- $5
    assert wdata = X"0000000b";

    -- success message
    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
