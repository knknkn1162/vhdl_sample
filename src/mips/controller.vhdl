library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.controller_pkg.ALL;
use work.state_pkg.ALL;
use work.debug_pkg.ALL;

entity controller is
  port (
    clk, rst : in std_logic;
    load : out std_logic;
    opcode, funct : in std_logic_vector(5 downto 0);
    rs, rt, rd : in std_logic_vector(4 downto 0);
    mem_rd, alures : in std_logic_vector(31 downto 0);
    -- for decode
    is_equal : in std_logic;
    -- for memread
    pc_aluout_s : out std_logic;
    pc4_br4_ja_s : out std_logic_vector(1 downto 0);
    pc_en : out std_logic;
    rw_en : out std_logic;

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
    dec_sa, dec_sb, dec_sc : out state_vector_type
  );
end entity;

architecture behavior of controller is
  signal dec_sa0, dec_sb0, dec_sc0 : state_vector_type;
  signal stateA, nextstateA : statetype;
  signal stateB, nextstateB : statetype;
  signal stateC, nextstateC : statetype;
  signal calcs_opcode, calcs_funct : std_logic_vector(5 downto 0);
  signal calcs_rs, calcs_rt, calcs_rd : std_logic_vector(4 downto 0);
  signal memrds_opcode, memrds_funct : std_logic_vector(5 downto 0);
  signal memrds_rs_dummy, memrds_rt, memrds_rd_dummy : std_logic_vector(4 downto 0);
  signal instr_shift_en : std_logic_vector(1 downto 0);
  signal ena : std_logic;
  signal enb : std_logic;
  signal is_branch : std_logic;
  -- for cache register address and data
  signal calcs_wa : std_logic_vector(4 downto 0);
  signal calcs_rt_rd_s, memrds_load_s : std_logic;
  signal alures_we, memrd_we : std_logic;
  signal load0 : std_logic;

  component instr_shift_register is
    port (
      clk, rst : in std_logic;
      en : in std_logic_vector(1 downto 0);
      opcode0, funct0 : in std_logic_vector(5 downto 0);
      rs0, rt0, rd0 : in std_logic_vector(4 downto 0);
      opcode1, funct1 : out std_logic_vector(5 downto 0);
      rs1, rt1, rd1 : out std_logic_vector(4 downto 0);
      opcode2, funct2 : out std_logic_vector(5 downto 0);
      rs2, rt2, rd2 : out std_logic_vector(4 downto 0)
    );
  end component;

  component regw_cache
    port (
      clk, rst : in std_logic;
      calcs_wa : in std_logic_vector(4 downto 0);
      calcs_wd : in std_logic_vector(31 downto 0);
      calcs_we : in std_logic;
      memrds_wa : in std_logic_vector(4 downto 0);
      memrds_wd : in std_logic_vector(31 downto 0);
      memrds_we : in std_logic;
      memrds_load_s : in std_logic;
      -- for register wb
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0);
      reg_we : out std_logic;

      -- forwarding
      rs : in std_logic_vector(4 downto 0);
      rt : in std_logic_vector(4 downto 0);
      rds : out std_logic_vector(31 downto 0);
      rdt : out std_logic_vector(31 downto 0)
    );
  end component;


  component mux2
    generic(N : integer);
    port (
      d0 : in std_logic_vector(N-1 downto 0);
      d1 : in std_logic_vector(N-1 downto 0);
      s : in std_logic;
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

begin
  process(clk, rst) begin
    if rst = '1' then
      stateA <= InitS;
      stateB <= Wait3S;
      stateC <= Wait4S;
    elsif rising_edge(clk) then
      stateA <= nextStateA;
      stateB <= nextStateB;
      stateC <= nextStateC;
    end if;
  end process;

  process(stateA, stateB, stateC)
  begin
    dec_sa0 <= decode_state(stateA);
    dec_sb0 <= decode_state(stateB);
    dec_sc0 <= decode_state(stateC);
  end process;
  dec_sa <= dec_sa0; dec_sb <= dec_sb0; dec_sc <= dec_sc0;

  process(stateA)
  begin
    if stateA = InitS then
      load0 <= '1';
    else
      load0 <= '0';
    end if;
  end process;
  load <= load0;

  -- State Machine
  process(clk, rst, stateA, stateB, stateC, opcode, calcs_opcode, ena, enb, load0)
    variable nextstateA0 : statetype;
    variable nextstateB0 : statetype;
    variable nextstateC0 : statetype;
  begin
    nextstateA0 := get_nextstate(stateA, opcode, calcs_opcode, load0, ena, enb, is_branch);
    nextstateB0 := get_nextstate(stateB, opcode, calcs_opcode, load0, ena, enb, is_branch);
    nextstateC0 := get_nextstate(stateC, opcode, calcs_opcode, load0, ena, enb, is_branch);

    nextstateA <= nextstateA0;
    nextstateB <= nextstateB0;
    nextStateC <= nextStateC0;
  end process;

  -- store old instrs
  instr_shift_en <= "1" & ena;
  instr_shift_register0 : instr_shift_register port map (
    clk => clk, rst => rst, en => instr_shift_en,
    opcode0 => opcode, funct0 => funct,
    rs0 => rs, rt0 => rt, rd0 => rd,
    opcode1 => calcs_opcode, funct1 => calcs_funct,
    rs1 => calcs_rs, rt1 => calcs_rt, rd1 => calcs_rd,
    opcode2 => memrds_opcode, funct2 => memrds_funct,
    rs2 => memrds_rs_dummy, -- not used
    rt2 => memrds_rt,
    rd2 => memrds_rd_dummy -- not used
  );
  -- for regrw

  -- cache wa & wd
  process(calcs_opcode)
  begin
    case calcs_opcode is
      when OP_RTYPE =>
        calcs_rt_rd_s <= '1';
      when OP_ADDI =>
        calcs_rt_rd_s <= '0';
      when others =>
        -- do nothing
    end case;
  end process;

  calcs_rt_rd_mux : mux2 generic map(N=>5)
  port map (
    d0 => calcs_rt,
    d1 => calcs_rd,
    s => calcs_rt_rd_s,
    y => calcs_wa
  );

  process(stateA, stateB, stateC)
  begin
    if(stateA = MemReadS or stateB = MemReadS or stateC = MemReadS) then
      memrds_load_s <= '1';
    else
      memrds_load_s <= '0';
    end if;
  end process;

  process(calcs_opcode)
  begin
    case calcs_opcode is
      when OP_ADDI | OP_RTYPE =>
        alures_we <= '1';
      when others =>
        alures_we <= '0';
    end case;
  end process;

  process(memrds_opcode)
  begin
    if memrds_opcode = OP_LW then
      memrd_we <= '1';
    else
      memrd_we <= '0';
    end if;
  end process;

  regw_cache0 : regw_cache port map (
    clk => clk, rst => rst,
    -- cache calcs
    calcs_wa => calcs_wa, calcs_wd => alures, calcs_we => alures_we,
    memrds_wa => memrds_rt, memrds_wd => mem_rd, memrds_we => memrd_we,
    -- selector
    memrds_load_s => memrds_load_s,

    -- to regrw
    reg_wa => reg_wa, reg_wd => reg_wd, reg_we => reg_we,

    -- forwarding
    rs => rs,
    rds => cached_rds,
    rt => rt,
    rdt => cached_rdt
  );

  -- stall
  process(stateA, stateB, stateC, calcs_opcode, rs, rt)
    variable enaA, enaB, enaC : std_logic;
  begin
    enaA := get_ena(stateA, calcs_opcode, rs, rt, calcs_rt);
    enaB := get_ena(stateB, calcs_opcode, rs, rt, calcs_rt);
    enaC := get_ena(stateC, calcs_opcode, rs, rt, calcs_rt);
    ena <= enaA and enaB and enaC;
  end process;

  -- Judge whether the 2-states collide
  process(stateA, stateB, stateC, enb)
    variable enbAB, enbBC, enbCA : std_logic;
  begin
    enbAB := get_enb(stateA, stateB);
    enbBC := get_enb(stateB, stateC);
    enbCA := get_enb(stateC, stateA);
    enb <= enbAB and enbBC and enbCA;
  end process;

  process(stateA, stateB, stateC, ena, enb)
    variable pc_enA, pc_enB, pc_enC : std_logic;
    variable instr_enA, instr_enB, instr_enC : std_logic;
  begin
    -- for memadr
    pc_enA := get_pc_en(stateA); pc_enB := get_pc_en(stateB); pc_enC := get_pc_en(stateC);
    pc_en <= (pc_enA or pc_enB or pc_enC) and ena;

    -- for calc
    calc_en <= ena and enb;
    rw_en <= enb;

    -- for writeback
    instr_enA := get_instr_en(stateA);
    instr_enB := get_instr_en(stateB);
    instr_enC := get_instr_en(stateC);
    instr_en <= (instr_enA or instr_enB or instr_enC) and ena and enb;
  end process;

  process(stateA, stateB, stateC)
    -- for memadr
    variable pc_aluout_sA, pc_aluout_sB, pc_aluout_sC : std_logic;

    -- for memwrite
    variable mem_weA, mem_weB, mem_weC: std_logic;
    -- for decode
    -- for calc
    variable alucontA, alucontB, alucontC : std_logic_vector(2 downto 0);
    variable rdt_immext_sA, rdt_immext_sB, rdt_immext_sC : std_logic;
  begin

    -- for memadr
    pc_aluout_sA := get_pc_aluout_s(stateA);
    pc_aluout_sB := get_pc_aluout_s(stateB);
    pc_aluout_sC := get_pc_aluout_s(stateC);
    pc_aluout_s <= pc_aluout_sA or pc_aluout_sB or pc_aluout_sC;

    -- for memwrite
    mem_weA := get_mem_we(stateA);
    mem_weB := get_mem_we(stateB);
    mem_weC := get_mem_we(stateC);
    mem_we <= mem_weA or mem_weB or mem_weC;

    -- for decode

    rdt_immext_sA := get_rdt_immext_s(stateA);
    rdt_immext_sB := get_rdt_immext_s(stateB);
    rdt_immext_sC := get_rdt_immext_s(stateC);
    rdt_immext_s <= rdt_immext_sA or rdt_immext_sB or rdt_immext_sC;
  end process;

  -- depending on funct
  process(stateA, stateB, stateC, calcs_funct)
    variable alucontA, alucontB, alucontC : std_logic_vector(2 downto 0);
  begin
    -- for calc
    alucontA := get_alucont(stateA, calcs_funct);
    alucontB := get_alucont(stateB, calcs_funct);
    alucontC := get_alucont(stateC, calcs_funct);
    alucont <= alucontA or alucontB or alucontC;
  end process;

  -- depend on is_equal (Judge @ DecodeS)
  process(stateA, stateB, stateC, is_equal)
    variable pc4_br4_ja_sA, pc4_br4_ja_sB, pc4_br4_ja_sC : std_logic_vector(1 downto 0);
  begin
    pc4_br4_ja_sA := get_pc4_br4_ja_s(stateA, opcode, is_equal);
    pc4_br4_ja_sB := get_pc4_br4_ja_s(stateB, opcode, is_equal);
    pc4_br4_ja_sC := get_pc4_br4_ja_s(stateC, opcode, is_equal);
    pc4_br4_ja_s <= pc4_br4_ja_sA or pc4_br4_ja_sB or pc4_br4_ja_sC;
  end process;

  is_branch <= get_branch_flag(is_equal, opcode);
end architecture;
