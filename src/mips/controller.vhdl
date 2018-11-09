library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.controller_pkg.ALL;

entity controller is
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
    -- for decode
    -- -- forwarding for pipeline
    rd1_aluout_s, rd2_aluout_s : out std_logic;
    -- for writeback
    instr_en, reg_we : out std_logic;
    memrd_aluout_s : out std_logic; -- for lw or addi
    rt_rd_s : out std_logic; -- Itype or Rtype
    -- for calc
    alucont : out std_logic_vector(2 downto 0);
    rdt_immext_s : out std_logic
  );
end entity;

architecture behavior of controller is
  signal stateA, nextstateA : statetype;
  signal stateB, nextstateB : statetype;

begin
  process(clk, rst) begin
    if rst = '1' then
      stateA <= InitS;
      stateB <= WaitS;
    elsif rising_edge(clk) then
      stateA <= nextStateA;
      stateB <= nextStateB;
    end if;
  end process;

  -- State Machine
  process(clk, rst, opcode, funct)
    variable stateA0, nextstateA0 : statetype;
    variable stateB0, nextstateB0 : statetype;
  begin
    nextstateA0 := get_nextstate(stateA0, opcode);
    nextstateB0 := get_nextstate(stateB0, opcode);
    -- todo : additional expr
    nextstateA <= nextstateA0;
    nextstateB <= nextstateB0;
  end process;

  -- for sequential logic
  -- ex) D-flipflop enable signal should be turned on before rising_edge(clk)
  process(stateA, stateB)
    -- for memadr
    variable pc_aluout_sA, pc_aluout_sB : std_logic;
    variable pc_enA, pc_enB : std_logic;

    -- for memwrite
    variable mem_weA, mem_weB: std_logic;
    -- for decode
    -- -- forwarding for pipeline
    variable rd1_aluout_s : std_logic;
    variable rd2_aluout_s : std_logic;
    -- for writeback
    variable instr_enA, instr_enB : std_logic;
    variable reg_weA, reg_weB : std_logic;
    variable memrd_aluout_sA, memrd_aluout_sB : std_logic; -- for lw or addi
    variable rt_rd_sA, rt_rd_sB : std_logic; -- Itype or Rtype
    -- for calc
    variable alucontA, alucontB : std_logic_vector(2 downto 0);
    variable rdt_immext_sA, rdt_immext_sB : std_logic;
  begin
    -- for memadr
    pc_aluout_sA := get_pc_aluout_s(stateA); pc_aluout_sB := get_pc_aluout_s(stateB);
    pc_aluout_s <= pc_aluout_sA or pc_aluout_sB;

    pc_enA := get_pc_en(stateA); pc_enB := get_pc_en(stateB);
    pc_en <= pc_enA or pc_enB;

    -- for memwrite
    mem_weA := get_mem_we(stateA); mem_weB := get_mem_we(stateB);
    mem_we <= mem_weA or mem_weB;

    -- for decode

    -- for writeback
    instr_enA := get_instr_en(stateA); instr_enB := get_instr_en(stateB);
    instr_en <= instr_enA or instr_enB;

    reg_weA := get_reg_we(stateA); reg_weB := get_reg_we(stateB);
    reg_we <= reg_weA or reg_weB;

    memrd_aluout_sA := get_memrd_aluout_s(stateA); memrd_aluout_sB := get_memrd_aluout_s(stateB);
    memrd_aluout_s <= memrd_aluout_sA or memrd_aluout_sB;

    rt_rd_sA := get_rt_rd_s(stateA); rt_rd_sB := get_rt_rd_s(stateB);
    rt_rd_s <= rt_rd_sA or rt_rd_sB;

    -- for calc
    alucontA := get_alucont(stateA, funct); alucontB := get_alucont(stateB, funct);
    alucont <= alucontA or alucontB;

    rdt_immext_sA := get_rdt_immext_s(stateA); rdt_immext_sB := get_rdt_immext_s(stateB);
    rdt_immext_s <= rdt_immext_sA or rdt_immext_sB;

    -- 

  end process;

  -- depend on aluzero
  process(stateA, stateB, aluzero)
    variable pc0_br_sA, pc0_br_sB : std_logic_vector(1 downto 0);
  begin
    pc0_br_sA := get_pc0_br_s(stateA, aluzero); pc0_br_sB := get_pc0_br_s(stateB, aluzero);
    pc0_br_s <= pc0_br_sA or pc0_br_sB;
  end process;
end architecture;
