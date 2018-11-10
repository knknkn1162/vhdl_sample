library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
  port (
    clk, rst : in std_logic;

    -- controller
    opcode, funct : out std_logic_vector(5 downto 0);
    rs, rt, rd : out std_logic_vector(4 downto 0);
    -- for memadr
    pc_aluout_s : in std_logic;
    pc0_br_s : in std_logic_vector(1 downto 0);
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
end entity;

architecture behavior of datapath is
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
      rs, rt, rd, shamt : out std_logic_vector(4 downto 0);
      imm : out std_logic_vector(15 downto 0);
      target : out std_logic_vector(25 downto 0);
      reg_memrd : out std_logic_vector(31 downto 0);
      -- controller
      opcode, funct : out std_logic_vector(5 downto 0);
      instr_en : in std_logic
    );
  end component;

  component regrw
    port (
      clk, rst : in std_logic;
      rs, rt, rd : in std_logic_vector(4 downto 0);
      mem_rd : in std_logic_vector(31 downto 0);
      aluout : in std_logic_vector(31 downto 0);
      imm : in std_logic_vector(15 downto 0);

      rds, rdt, immext : out std_logic_vector(31 downto 0);
      -- forwarding for pipeline
      aluforward : in std_logic_vector(31 downto 0);
      -- controller
      we : in std_logic;
      memrd_aluout_s : in std_logic;
      rt_rd_s : in std_logic;
      -- forwarding for pipeline
      rd1_aluforward_s : in std_logic;
      rd2_aluforward_s : in std_logic;
      -- scan
      wa : out std_logic_vector(4 downto 0);
      wd : out std_logic_vector(31 downto 0)
    );
  end component;

  component calc
    port (
      clk, rst : in std_logic;
      rds, rdt, immext : in std_logic_vector(31 downto 0);
      target : in std_logic_vector(25 downto 0);
      alures : out std_logic_vector(31 downto 0);
      aluzero : out std_logic;
      brplus : out std_logic_vector(31 downto 0);
      ja : out std_logic_vector(27 downto 0);
      -- controller
      alucont : in std_logic_vector(2 downto 0);
      rdt_immext_s : in std_logic
    );
  end component;

  component memadr
    port (
      clk, rst : in std_logic;
      alures : in std_logic_vector(31 downto 0);
      ja : in std_logic_vector(27 downto 0);
      brplus : in std_logic_vector(31 downto 0);
      addr : out std_logic_vector(31 downto 0);
      reg_aluout : out std_logic_vector(31 downto 0);
      -- controller
      pc_aluout_s : in std_logic;
      pc0_br_s : in std_logic_vector(1 downto 0);
      pc_en : in std_logic;
      -- scan
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0)
    );
  end component;

  signal mem_rd0, mem_wd0, mem_addr0 : std_logic_vector(31 downto 0);
  signal rs0, rt0, rd0, shamt0 : std_logic_vector(4 downto 0);
  signal imm0 : std_logic_vector(15 downto 0);
  signal target0 : std_logic_vector(25 downto 0);
  signal rds0, rdt0, immext0 : std_logic_vector(31 downto 0);
  signal ja0 : std_logic_vector(27 downto 0);
  signal reg_aluout0, reg_memrd0 : std_logic_vector(31 downto 0);
  signal reg_wa0 : std_logic_vector(4 downto 0);
  signal reg_wd0 : std_logic_vector(31 downto 0);
  signal alures0 : std_logic_vector(31 downto 0);
  signal brplus0 : std_logic_vector(31 downto 0);

  -- pipeline
  signal aluforward0 : std_logic_vector(31 downto 0);

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
    rs => rs0, rt => rt0, rd => rd0, shamt => shamt0,
    imm => imm0,
    target => target0,
    reg_memrd => reg_memrd0,
    -- controller
    opcode => opcode, funct => funct,
    instr_en => instr_en
  );
  rs <= rs0; rt <= rt0; rd <= rd0;

  regrw0 : regrw port map (
    clk => clk, rst => rst,
    rs => rs0, rt => rt0, rd => rd0,
    mem_rd => reg_memrd0, aluout => reg_aluout0,
    imm => imm0,
    rds => rds0, rdt => rdt0, immext => immext0,
    -- forwarding for pipeline
    aluforward => aluforward0,
    -- controller
    we => reg_we,
    memrd_aluout_s => memrd_aluout_s, rt_rd_s => rt_rd_s,
    -- forwarding for pipeline
    rd1_aluforward_s => rd1_aluforward_s, rd2_aluforward_s => rd2_aluforward_s,
    -- scan
    wa => reg_wa0,
    wd => reg_wd0
  );

  reg_wa <= reg_wa0;
  reg_wd <= reg_wd0;
  rds <= rds0; rdt <= rdt0; immext <= immext0;

  calc0 : calc port map (
    clk => clk, rst => rst,
    rds => rds0, rdt => rdt0, immext => immext0,
    target => target0,
    alures => alures0, aluzero => aluzero,
    brplus => brplus0,
    ja => ja0,
    -- controller
    alucont => alucont,
    rdt_immext_s => rdt_immext_s
  );
  alures <= alures0;
  aluforward0 <= alures0; -- forwarding for pipeline

  memadr0 : memadr port map (
    clk => clk, rst => rst,
    alures => alures0,
    ja => ja0,
    brplus => brplus0,
    addr => mem_addr0,
    reg_aluout => reg_aluout0,
    -- controller
    pc_aluout_s => pc_aluout_s, pc0_br_s => pc0_br_s,
    pc_en => pc_en,
    -- scan
    pc => pc, pcnext => pcnext
  );
end architecture;
