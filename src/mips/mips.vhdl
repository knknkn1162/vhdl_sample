library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.debug_pkg.state_vector_type;

entity mips is
  generic(memfile : string; regfile : string);
  port (
    clk, rst, load : in std_logic;
    -- scan for testbench
    pc : out std_logic_vector(31 downto 0);
    pcnext : out std_logic_vector(31 downto 0);
    addr, mem_rd, mem_wd : out std_logic_vector(31 downto 0);
    rds, rdt, immext : out std_logic_vector(31 downto 0);
    ja : out std_logic_vector(27 downto 0);
    alures : out std_logic_vector(31 downto 0);
    -- for scan
    dec_sa, dec_sb : out state_vector_type;
    reg_wa : out std_logic_vector(4 downto 0);
    reg_wd : out std_logic_vector(31 downto 0);
    reg_we : out std_logic;
    -- -- check stall or not
    stall_en : out std_logic
  );
end entity;

architecture behavior of mips is
  component datapath
    generic(memfile : string; regfile : string);
    port (
      clk, rst, load : in std_logic;

      -- controller
      opcode, funct : out std_logic_vector(5 downto 0);
      rs, rt, rd : out std_logic_vector(4 downto 0);
      -- for memadr
      pc_aluout_s : in std_logic;
      pc4_br4_ja_s : in std_logic_vector(1 downto 0);
      pc_en, rw_en : in std_logic;
      -- for memwrite
      mem_we: in std_logic;
      -- for decode
      cached_rds, cached_rdt : in std_logic_vector(31 downto 0);
      -- for writeback
      instr_en : in std_logic;
      reg_wa : in std_logic_vector(4 downto 0);
      reg_wd : in std_logic_vector(31 downto 0);
      reg_we : in std_logic;
      -- for calc
      alucont : in std_logic_vector(2 downto 0);
      rdt_immext_s : in std_logic;
      calc_en : in std_logic;
      aluzero : out std_logic;

      -- scan for testbench
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      addr, mem_rd, mem_wd : out std_logic_vector(31 downto 0);
      rds, rdt, immext : out std_logic_vector(31 downto 0);
      ja : out std_logic_vector(27 downto 0);
      alures : out std_logic_vector(31 downto 0)
    );
  end component;

  component controller
    port (
      clk, rst, load : in std_logic;
      opcode, funct : in std_logic_vector(5 downto 0);
      rs, rt, rd : in std_logic_vector(4 downto 0);
      mem_rd, alures : in std_logic_vector(31 downto 0);
      aluzero : in std_logic;
      -- for memread
      pc_aluout_s : out std_logic;
      pc4_br4_ja_s : out std_logic_vector(1 downto 0);
      pc_en, rw_en : out std_logic;

      -- for memwrite
      mem_we: out std_logic;
      -- for writeback
      instr_en : out std_logic;
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0);
      reg_we : out std_logic;
      -- forwarding
      cached_rds, cached_rdt : out std_logic_vector(31 downto 0);
      -- for calc
      alucont : out std_logic_vector(2 downto 0);
      rdt_immext_s : out std_logic;
      calc_en : out std_logic;
      -- for scan
      dec_sa, dec_sb : out state_vector_type
    );
  end component;

  -- controller
  signal opcode, funct : std_logic_vector(5 downto 0);
  signal rs, rt, rd : std_logic_vector(4 downto 0);
  -- for memwrite
  signal mem_we: std_logic;
  -- for decode
  signal cached_rds, cached_rdt : std_logic_vector(31 downto 0);
  -- for writeback
  signal instr_en : std_logic;
  signal reg_wa0 : std_logic_vector(4 downto 0);
  signal reg_we0 : std_logic;
  signal reg_wd0 : std_logic_vector(31 downto 0);
  -- for calc
  signal alucont : std_logic_vector(2 downto 0);
  signal rdt_immext_s : std_logic;
  signal calc_en : std_logic;
  signal aluzero : std_logic;
  signal mem_rd0, alures0 : std_logic_vector(31 downto 0);

  -- for memadr
  signal pc_aluout_s : std_logic;
  signal pc4_br4_ja_s : std_logic_vector(1 downto 0);
  signal pc_en, rw_en : std_logic;

begin
  datapath0 : datapath generic map (memfile=>memfile, regfile=>regfile)
  port map (
    clk => clk, rst => rst, load => load,

    -- controller
    opcode => opcode, funct => funct,
    rs => rs, rt => rt, rd => rd,
    -- for memadr
    pc_aluout_s => pc_aluout_s,
    pc4_br4_ja_s => pc4_br4_ja_s,
    pc_en => pc_en,
    rw_en => rw_en,
    -- for memwrite
    mem_we => mem_we,
    -- forwarding for pipeline
    cached_rds => cached_rds, cached_rdt => cached_rdt,
    -- for writeback
    instr_en => instr_en,
    reg_wa => reg_wa0, reg_wd => reg_wd0, reg_we => reg_we0,
    -- for calc
    alucont => alucont,
    rdt_immext_s => rdt_immext_s,
    aluzero => aluzero,
    calc_en => calc_en,
    
    -- scan for testbench
    pc => pc, pcnext => pcnext,
    addr => addr, mem_rd => mem_rd0, mem_wd => mem_wd,
    rds => rds, rdt => rdt, immext => immext,
    ja => ja,
    alures => alures0
  );
  reg_wa <= reg_wa0; reg_wd <= reg_wd0; reg_we <= reg_we0;

  controller0 : controller port map (
    clk => clk, rst => rst, load => load,
    opcode => opcode, funct => funct,
    rs => rs, rt => rt, rd => rd,
    mem_rd => mem_rd0, alures => alures0,
    aluzero => aluzero,
    -- out
    -- for memadr
    pc_aluout_s => pc_aluout_s, pc4_br4_ja_s => pc4_br4_ja_s,
    pc_en => pc_en,
    rw_en => rw_en,
    -- for memwrite
    mem_we => mem_we,
    -- for decode
    -- for writeback
    instr_en => instr_en,
    reg_wa => reg_wa0, reg_wd => reg_wd0, reg_we => reg_we0,
    -- forwarding
    cached_rds => cached_rds, cached_rdt => cached_rdt,
    -- for memadr
    alucont => alucont,
    rdt_immext_s => rdt_immext_s,
    calc_en => calc_en,
    dec_sa => dec_sa, dec_sb => dec_sb
  );
  alures <= alures0;
  mem_rd <= mem_rd0;
  stall_en <= not calc_en;
end architecture;
