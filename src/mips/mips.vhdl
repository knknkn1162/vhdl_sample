library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mips is
  port (
    clk, reset : in std_logic;
    addr : in std_logic_vector(31 downto 0);
    -- for testbench
    pc : out std_logic_vector(31 downto 0);
    pcnext : out std_logic_vector(31 downto 0);
    instr : out std_logic_vector(31 downto 0);
    a3 : out std_logic_vector(4 downto 0);
    dmem_wd, reg_wd : out std_logic_vector(31 downto 0);
    rs, rt : out std_logic_vector(31 downto 0);
    rt_imm : out std_logic_vector(31 downto 0);
    aluout : out std_logic_vector(31 downto 0);
    rdata : out std_logic_vector(31 downto 0)
      );
end entity;

architecture behavior of mips is
  component datapath
    port (
      clk, reset : in std_logic;
      addr : in std_logic_vector(31 downto 0);

      -- from controller
      -- write enable
      reg_we3, dmem_we : in std_logic;
      -- multiplex selector
      rt_rd_s, rt_imm_s, calc_rdata_s : in std_logic;
      -- alu
      alu_func : in std_logic_vector(2 downto 0);
      -- branch
      is_branch, is_jmp : in std_logic;
      -- jump, branch, pc
      -- pcn4_br_s, pcn_jmp_s : in std_logic;

      -- for testbench
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      instr : out std_logic_vector(31 downto 0);
      a3 : out std_logic_vector(4 downto 0);
      dmem_wd, reg_wd : out std_logic_vector(31 downto 0);
      rs, rt : out std_logic_vector(31 downto 0);
      rt_imm : out std_logic_vector(31 downto 0);
      aluout : out std_logic_vector(31 downto 0);
      rdata : out std_logic_vector(31 downto 0)
        );
  end component;

  component controller
    port (
      opcode : in std_logic_vector(5 downto 0);
      funct : in std_logic_vector(5 downto 0);
      -- write enable
      reg_we3, dmem_we : out std_logic;
      -- multiplex selector
      rt_rd_s, rt_imm_s, calc_rdata_s : out std_logic;
      -- alu
      alu_func : out std_logic_vector(2 downto 0);
      -- branch
      is_branch, is_jmp : out std_logic
      -- jump, branch, pc
      -- pcn4_br_s, pcn_jmp_s : in std_logic;
    );
  end component;

  signal instr0 : std_logic_vector(31 downto 0);

  signal reg_we3, dmem_we : std_logic;
  signal rt_rd_s ,rt_imm_s, calc_rdata_s : std_logic;
  signal alu_func : std_logic_vector(2 downto 0);
  signal is_branch, is_jmp : std_logic;

begin
  datapath0 : datapath port map (
    clk => clk, reset => reset,
    addr => addr,
    -- from controller
    reg_we3 => reg_we3, dmem_we => dmem_we,
    rt_rd_s => rt_rd_s, rt_imm_s => rt_imm_s, calc_rdata_s => calc_rdata_s,
    alu_func => alu_func,
    is_branch => is_branch, is_jmp => is_jmp,
    -- pcn4_br_s, => pcn4_br_s, pcn_jmp_s => pcn_jmp_s
    pc => pc,
    pcnext => pcnext,
    instr => instr0,
    a3 => a3,
    dmem_wd => dmem_wd, reg_wd => reg_wd,
    rs => rs, rt => rt,
    rt_imm => rt_imm,
    aluout => aluout,
    rdata => rdata
  );

  controller0 : controller port map (
    opcode => instr0(31 downto 26),
    funct => instr0(5 downto 0),
    -- decode
    reg_we3 => reg_we3, dmem_we => dmem_we,
    rt_rd_s => rt_rd_s, rt_imm_s => rt_imm_s, calc_rdata_s => calc_rdata_s,
    alu_func => alu_func,
    is_branch => is_branch, is_jmp => is_jmp
  );

  instr <= instr0;
end architecture;
