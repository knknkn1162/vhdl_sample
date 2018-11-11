library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath_tb is
end entity;

architecture testbench of datapath_tb is
  component datapath
    generic(memfile : string; regfile : string := "./assets/dummy.hex");
    port (
      clk, rst, load : in std_logic;

      -- controller
      opcode, funct : out std_logic_vector(5 downto 0);
      rs, rt, rd : out std_logic_vector(4 downto 0);
      -- for memadr
      pc_aluout_s : in std_logic;
      pc4_br4_ja_s : in std_logic_vector(1 downto 0);
      pc_en : in std_logic;
      -- for memwrite
      mem_we: in std_logic;
      -- for decode
      -- forwarding for pipeline
      rd1_aluforward_s, rd2_aluforward_s : in std_logic;
      -- for writeback
      instr_en, reg_we : in std_logic;
      memrd_aluout_s : in std_logic; -- for lw or addi
      rt_rd_s : in std_logic; -- Itype or Rtype
      -- for calc
      alucont : in std_logic_vector(2 downto 0);
      rdt_immext_s : in std_logic;
      aluzero : out std_logic;

      -- scan for testbench
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      addr, mem_rd, mem_wd : out std_logic_vector(31 downto 0);
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0);
      rds, rdt, immext : out std_logic_vector(31 downto 0);
      ja : out std_logic_vector(27 downto 0);
      alures : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst, load : std_logic;

  -- controller
  signal opcode, funct : std_logic_vector(5 downto 0);
  signal rs, rt, rd : std_logic_vector(4 downto 0);
  -- for memadr
  signal pc_aluout_s : std_logic;
  signal pc4_br4_ja_s : std_logic_vector(1 downto 0);
  signal pc_en : std_logic;
  -- for memwrite
  signal mem_we: std_logic;
  -- for decode
  -- forwardg for pipele
  signal rd1_aluforward_s, rd2_aluforward_s : std_logic;
  -- for writeback
  signal instr_en, reg_we : std_logic;
  signal memrd_aluout_s : std_logic; -- for lw or addi
  signal rt_rd_s : std_logic; -- Itype or Rtype
  -- for calc
  signal alucont : std_logic_vector(2 downto 0);
  signal rdt_immext_s : std_logic;
  signal aluzero : std_logic;

  -- scan for testbench
  signal pc :  std_logic_vector(31 downto 0);
  signal pcnext :  std_logic_vector(31 downto 0);
  signal addr, mem_rd, mem_wd :  std_logic_vector(31 downto 0);
  signal reg_wa :  std_logic_vector(4 downto 0);
  signal reg_wd :  std_logic_vector(31 downto 0);
  signal rds, rdt, immext :  std_logic_vector(31 downto 0);
  signal ja :  std_logic_vector(27 downto 0);
  signal alures :  std_logic_vector(31 downto 0);
  constant memfile : string := "./assets/memfile.hex";
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : datapath generic map(memfile=>memfile) 
  port map (
    clk => clk, rst => rst, load => load,
    -- controller
    opcode => opcode, funct => funct,
    rs => rs, rt => rt, rd => rd,
    -- for memadr
    pc_aluout_s => pc_aluout_s,
    pc4_br4_ja_s => pc4_br4_ja_s,
    pc_en => pc_en,
    -- for memwrite
    mem_we => mem_we,
    -- for decode
    -- forwarding for pipeline
    rd1_aluforward_s => rd1_aluforward_s, rd2_aluforward_s => rd2_aluforward_s,
    -- for writeback
    instr_en => instr_en, reg_we => reg_we,
    memrd_aluout_s => memrd_aluout_s,
    rt_rd_s => rt_rd_s,
    -- for calc
    alucont => alucont,
    rdt_immext_s => rdt_immext_s,
    aluzero => aluzero,

    -- scan for testbench
    pc => pc,
    pcnext => pcnext,
    addr => addr, mem_rd => mem_rd, mem_wd => mem_wd,
    reg_wa => reg_wa,
    reg_wd => reg_wd,
    rds => rds, rdt => rdt, immext => immext,
    ja => ja,
    alures => alures
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
    rst <= '1'; mem_we <= '0'; wait for 1 ns; rst <= '0';
    -- syncronous reset
    load <= '1'; wait for clk_period/2; load <= '0';
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
