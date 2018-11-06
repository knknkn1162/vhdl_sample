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
    alures : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of mips is
  component memrw
    port (
      clk, rst: in std_logic;
      addr : in std_logic_vector(31 downto 0);
      wd : in std_logic_vector(31 downto 0);
      rd : out std_logic_vector(31 downto 0);
      -- controller
      we : in std_logic
    );
  end component;

  component decode
    port (
      clk, rst : in std_logic;
      mem_rd : in std_logic_vector(31 downto 0);
      rs, rt : out std_logic_vector(4 downto 0);
      imm : out std_logic_vector(15 downto 0);
      wd : out std_logic_vector(31 downto 0);
      -- controller
      opcode, funct : out std_logic_vector(5 downto 0);
      instr_en : in std_logic
    );
  end component;

  component regrw
    port (
      clk, rst : in std_logic;
      rs, rt : in std_logic_vector(4 downto 0);
      wd : in std_logic_vector(31 downto 0);
      imm : in std_logic_vector(15 downto 0);

      rds, rdt, immext : out std_logic_vector(31 downto 0);
      -- controller
      we : in std_logic;
      -- scan
      wa : out std_logic_vector(4 downto 0)
    );
  end component;

  component calc
    port (
      clk, rst : in std_logic;
      rds, rdt, immext : in std_logic_vector(31 downto 0);
      alures : out std_logic_vector(31 downto 0);
      zero : out std_logic;
      -- controller
      alucont : in std_logic_vector(2 downto 0);
      rdt_immext_s : in std_logic
    );
  end component;

  component memadr
    port (
      clk, rst : in std_logic;
      alures : in std_logic_vector(31 downto 0);
      addr : out std_logic_vector(31 downto 0);
      -- controller
      pc_aluout_s, pc_en : in std_logic;
      -- scan
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0)
    );
  end component;

  component controller
    port (
      clk, rst : in std_logic;
      opcode, funct : in std_logic_vector(5 downto 0);
      -- for memadr
      pc_aluout_s, pc_en : out std_logic;
      -- for memwrite
      mem_we: out std_logic;
      -- for writeback
      instr_en, reg_we : out std_logic;
      -- for memadr
      alucont : out std_logic_vector(2 downto 0);
      rdt_immext_s : out std_logic
    );
  end component;

  signal mem_rd0, mem_wd0, mem_addr0 : std_logic_vector(31 downto 0);
  signal rs0, rt0 : std_logic_vector(4 downto 0);
  signal imm0 : std_logic_vector(15 downto 0);
  signal rds0, rdt0, immext0 : std_logic_vector(31 downto 0);
  signal reg_wa0 : std_logic_vector(4 downto 0);
  signal reg_wd0 : std_logic_vector(31 downto 0);
  signal alures0 : std_logic_vector(31 downto 0);
  signal zero0 : std_logic;

  -- controller
  signal opcode, funct : std_logic_vector(5 downto 0);
  -- for memwrite
  signal mem_we: std_logic;
  -- for decode, writeback
  signal instr_en, reg_we : std_logic;
  -- for calc
  signal alucont : std_logic_vector(2 downto 0);
  signal rdt_immext_s : std_logic;
  -- for memadr
  signal pc_aluout_s, pc_en : std_logic;

begin

  mem_wd0 <= rdt0;
  memrw0 : memrw port map (
    clk => clk, rst => rst,
    addr => mem_addr0, wd => mem_wd0, rd => mem_rd0,
    -- controller
    we => mem_we
  );
  addr <= mem_addr0;
  mem_wd <= mem_wd0;
  mem_rd <= mem_rd0;

  decode0 : decode port map (
    clk => clk, rst => rst,
    mem_rd => mem_rd0,
    rs => rs0, rt => rt0,
    imm => imm0,
    wd => reg_wd0,
    -- controller
    opcode => opcode, funct => funct,
    instr_en => instr_en
  );

  regrw0 : regrw port map (
    clk => clk, rst => rst,
    rs => rs0, rt => rt0,
    imm => imm0,
    wd => reg_wd0,
    rds => rds0, rdt => rdt0, immext => immext0,
    -- controller
    we => reg_we,
    -- scan
    wa => reg_wa0
  );
  reg_wa <= reg_wa0;
  reg_wd <= reg_wd0;
  rds <= rds0; rdt <= rdt0; immext <= immext0;

  calc0 : calc port map (
    clk => clk, rst => rst,
    rds => rds0, rdt => rdt0, immext => immext0,
    alures => alures0,
    zero => zero0,
    -- controller
    alucont => alucont,
    rdt_immext_s => rdt_immext_s
  );

  memadr0 : memadr port map (
    clk => clk, rst => rst,
    alures => alures0,
    addr => mem_addr0,
    -- controller
    pc_aluout_s => pc_aluout_s, pc_en => pc_en,
    -- scan
    pc => pc, pcnext => pcnext
  );
  alures <= alures0;

  controller0 : controller port map (
    clk => clk, rst => rst,
    opcode => opcode, funct => funct,
    -- out
    -- for memadr
    pc_aluout_s => pc_aluout_s, pc_en => pc_en,
    -- for memwrite
    mem_we => mem_we,
    -- for writeback
    instr_en => instr_en, reg_we => reg_we,
    -- for memadr
    alucont => alucont,
    rdt_immext_s => rdt_immext_s
  );
end architecture;
