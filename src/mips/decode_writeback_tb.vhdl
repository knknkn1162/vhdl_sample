library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decode_writeback_tb is
end entity;

architecture testbench of decode_writeback_tb is
  component decode_writeback
    port (
      clk, rst : in std_logic;
      mem_rd : in std_logic_vector(31 downto 0);
      rs, rt, imm : out std_logic_vector(31 downto 0);
      -- controller
      opcode, funct : out std_logic_vector(5 downto 0);
      instr_en, reg_we : in std_logic;
      -- scan
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst : std_logic;
  signal mem_rd, rs, rt, imm : std_logic_vector(31 downto 0);
  signal opcode, funct : std_logic_vector(5 downto 0);
  signal instr_en, reg_we : std_logic;
  signal reg_wa : std_logic_vector(4 downto 0);
  signal reg_wd : std_logic_vector(31 downto 0);
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : decode_writeback port map (
    clk => clk, rst => rst,
    mem_rd => mem_rd,
    rs => rs, rt => rt, imm => imm,
    -- controller
    opcode => opcode, funct => funct,
    instr_en => instr_en, reg_we => reg_we,
    -- scan
    reg_wa => reg_wa, reg_wd => reg_wd
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
    -- lw $s0, 1020($0) 1000/11 00/000 1/0000 0x03FC
    -- X"8C1003FC";
    rst <= '1'; wait for 1 ns; rst <= '0';
    -- read
    mem_rd <= X"8C1003FC"; instr_en <= '1'; reg_we <= '0'; wait for clk_period/2;
    assert rs = X"00000000"; assert imm = X"000003FC"; assert opcode = "100011";
    -- write
    mem_rd <= X"000000FF"; instr_en <= '0'; reg_we <= '1'; wait for clk_period;
    assert reg_wa = "10000"; assert reg_wd = X"000000FF"; assert rs = X"00000000";
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
