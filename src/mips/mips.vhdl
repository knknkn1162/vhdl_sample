library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips is
  port (
    clk, rst : in std_logic;
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
end entity;

architecture behavior of mips is
  component datapath
    port (
      clk, rst : in std_logic;

      -- controller
      opcode, funct : out std_logic_vector(5 downto 0);
      -- for memadr
      pc_aluout_s : in std_logic;
      pc0_br_s : in std_logic_vector(1 downto 0);
      pc_en : in std_logic;
      -- for memwrite
      mem_we: in std_logic;
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

  component controller
    port (
      clk, rst : in std_logic;
      opcode, funct : in std_logic_vector(5 downto 0);
      aluzero : in std_logic;
      -- for memadr
      pc_aluout_s : out std_logic;
      pc0_br_s : out std_logic_vector(1 downto 0);
      pc_en : out std_logic;
      -- for memwrite
      mem_we: out std_logic;
      -- for writeback
      instr_en, reg_we : out std_logic;
      memrd_aluout_s : out std_logic; -- for lw or addi
      rt_rd_s : out std_logic; -- Itype or Rtype
      -- for calc
      alucont : out std_logic_vector(2 downto 0);
      rdt_immext_s : out std_logic
    );
  end component;

  -- controller
  signal opcode, funct : std_logic_vector(5 downto 0);
  -- for memwrite
  signal mem_we: std_logic;
  -- for decode, writeback
  signal instr_en, reg_we : std_logic;
  signal memrd_aluout_s : std_logic;
  signal rt_rd_s : std_logic;
  -- for calc
  signal alucont : std_logic_vector(2 downto 0);
  signal rdt_immext_s : std_logic;
  signal aluzero : std_logic;

  -- for memadr
  signal pc_aluout_s : std_logic;
  signal pc0_br_s : std_logic_vector(1 downto 0);
  signal pc_en : std_logic;

begin
  datapath0 : datapath port map (
    clk => clk, rst => rst,

    -- controller
    opcode => opcode, funct => funct,
    -- for memadr
    pc_aluout_s => pc_aluout_s,
    pc0_br_s => pc0_br_s,
    pc_en => pc_en,
    -- for memwrite
    mem_we => mem_we,
    -- for writeback
    instr_en => instr_en, reg_we => reg_we,
    memrd_aluout_s => memrd_aluout_s,
    rt_rd_s => rt_rd_s,
    -- for calc
    alucont => alucont,
    rdt_immext_s => rdt_immext_s,
    aluzero => aluzero,
    
    -- scan for testbench
    pc => pc, pcnext => pcnext,
    addr => addr, mem_rd => mem_rd, mem_wd => mem_wd,
    reg_wa => reg_wa,
    reg_wd => reg_wd,
    rds => rds, rdt => rdt, immext => immext,
    ja => ja,
    alures => alures
  );

  controller0 : controller port map (
    clk => clk, rst => rst,
    opcode => opcode, funct => funct,
    aluzero => aluzero,
    -- out
    -- for memadr
    pc_aluout_s => pc_aluout_s, pc0_br_s => pc0_br_s,
    pc_en => pc_en,
    -- for memwrite
    mem_we => mem_we,
    -- for writeback
    instr_en => instr_en, reg_we => reg_we,
    memrd_aluout_s => memrd_aluout_s, rt_rd_s => rt_rd_s,
    -- for memadr
    alucont => alucont,
    rdt_immext_s => rdt_immext_s
  );
end architecture;
