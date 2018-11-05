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
    rs, rt, imm : out std_logic_vector(31 downto 0);
    aluout : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of mips is
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

  component fetch_memrw
    port (
      clk, rst: in std_logic;
      addr : in std_logic_vector(31 downto 0);
      wd : in std_logic_vector(31 downto 0);
      rd : out std_logic_vector(31 downto 0);
      -- controller
      we : in std_logic
    );
  end component;

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

  component calc
    port (
      clk, rst : in std_logic;
      rs, rt, imm : in std_logic_vector(31 downto 0);
      alures : out std_logic_vector(31 downto 0);
      zero : out std_logic;
      -- controller
      alucont : in std_logic_vector(2 downto 0);
      rt_imm_s : in std_logic
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
      rt_imm_s : out std_logic
    );
  end component;

  signal alures0 : std_logic_vector(31 downto 0);
  signal mem_rd0, mem_wd0, mem_addr0 : std_logic_vector(31 downto 0);
  signal rs0, rt0, imm0 : std_logic_vector(31 downto 0);
  signal zero0 : std_logic;

  -- controller
  signal opcode, funct : std_logic_vector(5 downto 0);
  -- for memadr
  signal pc_aluout_s, pc_en : std_logic;
  -- for memwrite
  signal mem_we: std_logic;
  -- for writeback
  signal instr_en, reg_we : std_logic;
  -- for memadr
  signal alucont : std_logic_vector(2 downto 0);
  signal rt_imm_s : std_logic;

begin
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
    rt_imm_s => rt_imm_s
  );

  memadr0 : memadr port map (
    clk => clk, rst => rst,
    alures => alures0,
    addr => mem_addr0,
    pc_aluout_s => pc_aluout_s, pc_en => pc_en,
    pc => pc, pcnext => pcnext
  );
  mem_wd0 <= rt0;
  fetch_memrw0 : fetch_memrw port map (
    clk => clk, rst => rst,
    addr => mem_addr0,
    wd => mem_wd0,
    rd => mem_rd0, -- instr0
    we => mem_we
  );
  addr <= mem_addr0;
  mem_rd <= mem_rd0;

  decode_writeback0 : decode_writeback port map (
    clk => clk, rst => rst,
    mem_rd => mem_rd0,
    rs => rs0, rt => rt0, imm => imm0,
    opcode => opcode, funct => funct,
    instr_en => instr_en, reg_we => reg_we,
    reg_wa => reg_wa, reg_wd => reg_wd
  );
  rs <= rs0; rt <= rt0; imm <= imm0;

  calc0 : calc port map (
    clk => clk, rst => rst,
    rs => rs0, rt => rt0, imm => imm0,
    alures => alures0,
    zero => zero0,
    alucont => alucont,
    rt_imm_s => rt_imm_s
  );
end architecture;
