library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.controller_pkg.ALL;
use work.state_pkg.ALL;
use work.debug_pkg.ALL;

entity controller is
  port (
    clk, rst, load : in std_logic;
    opcode, funct : in std_logic_vector(5 downto 0);
    rs, rt, rd : in std_logic_vector(4 downto 0);
    aluzero : in std_logic;
    -- for memadr
    pc_aluout_s : out std_logic;
    pc4_br4_ja_s : out std_logic_vector(1 downto 0);
    pc_en : out std_logic;

    -- for memwrite
    mem_we: out std_logic;
    -- for decode
    -- -- forwarding for pipeline
    rd1_aluforward_memrd_s, rd2_aluforward_memrd_s : out std_logic_vector(1 downto 0);
    -- for writeback
    instr_en, reg_we : out std_logic;
    memrd_aluout_s : out std_logic; -- for lw or addi
    rt_rd_s : out std_logic; -- Itype or Rtype
    memrds_rt, memrds_rd : out std_logic_vector(4 downto 0);
    -- for calc
    alucont : out std_logic_vector(2 downto 0);
    rdt_immext_s : out std_logic;
    calc_en : out std_logic;
    -- for scan
    dec_sa, dec_sb : out state_vector_type
  );
end entity;

architecture behavior of controller is
  signal stateA, nextstateA : statetype;
  signal dec_sa0, dec_sb0 : state_vector_type;
  signal stateB, nextstateB : statetype;
  signal calcs_opcode, calcs_funct : std_logic_vector(5 downto 0);
  signal calcs_rs, calcs_rt, calcs_rd : std_logic_vector(4 downto 0);
  signal memrw_opcode, memrw_funct : std_logic_vector(5 downto 0);
  signal memrw_rs, memrw_rt0, memrw_rd0 : std_logic_vector(4 downto 0);
  signal instr_shift_en : std_logic_vector(1 downto 0);
  signal ena : std_logic;

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

begin
  process(clk, rst) begin
    if rst = '1' then
      stateA <= InitS;
      stateB <= Wait2S;
    elsif rising_edge(clk) then
      stateA <= nextStateA;
      stateB <= nextStateB;
    end if;
  end process;

  process(stateA, stateB)
  begin
    dec_sa0 <= decode_state(stateA);
    dec_sb0 <= decode_state(stateB);
  end process;
  dec_sa <= dec_sa0; dec_sb <= dec_sb0;

  -- State Machine
  process(clk, rst, opcode, funct)
    variable stateA0, nextstateA0 : statetype;
    variable stateB0, nextstateB0 : statetype;
  begin
    nextstateA0 := get_nextstate(stateA, opcode, calcs_opcode, load, ena);
    nextstateB0 := get_nextstate(stateB, opcode, calcs_opcode, load, ena);
    -- todo : additional expr
    nextstateA <= nextstateA0;
    nextstateB <= nextstateB0;
  end process;

  instr_shift_en <= "1" & ena;
  instr_shift_register0 : instr_shift_register port map (
    clk => clk, rst => rst, en => instr_shift_en,
    opcode0 => opcode, funct0 => funct,
    rs0 => rs, rt0 => rt, rd0 => rd,
    opcode1 => calcs_opcode, funct1 => calcs_funct,
    rs1 => calcs_rs, rt1 => calcs_rt, rd1 => calcs_rd,
    opcode2 => memrw_opcode, funct2 => memrw_funct,
    rs2 => memrw_rs, rt2 => memrw_rt0, rd2 => memrw_rd0
  );
  -- for regrw
  memrds_rt <= memrw_rt0;
  memrds_rd <= memrw_rd0;

  -- forwarding for pipeline
  process(stateA, stateB, rs, rt, rd, memrw_rt0)
    variable rd1_aluforward_memrd_s0, rd2_aluforward_memrd_s0 : std_logic_vector(1 downto 0);
  begin
    rd1_aluforward_memrd_s0 := "00"; rd2_aluforward_memrd_s0 := "00";
    case stateA is
      when AddiCalcS =>
        if stateB = DecodeS then
          -- addi $s0, $t1, $t2 -- addi $rt, $rs, imm
          -- add $s1, $s0, $t1 -- add $rd, $rs, $rt
          if stateB = DecodeS and calcs_rt = rs then
            rd1_aluforward_memrd_s0 := "01";
          end if;

          -- addi $s0, $t1, $t2 -- addi $rt, $rs, imm
          -- add $s1, $t1, $s0 -- add $rd, $rs, $rt
          if stateB = DecodeS and calcs_rt = rt then
            rd2_aluforward_memrd_s0 := "01";
          end if;
        end if;

      when RtypeCalcS =>
        if stateB = DecodeS then
          -- add $s0, $t1, $t2 -- add $rd, $rs, $rt
          -- add $s1, $s0, $t1 -- add $rd, $rs, $rt
          -- or
          -- add $s1, $s0, $t1 -- add $rd, $rs, $rt
          -- addi $s1, $s1, 5 -- addi $rt, $rs, imm
          if calcs_rd = rs then
            rd1_aluforward_memrd_s0 := "01";
          end if;

          -- add $s0, $t1, $t2 -- add $rd, $rs, $rt
          -- add $s1, $t1, $s0 -- add $rd, $rs, $rt
          if calcs_rd = rt then
            rd2_aluforward_memrd_s0 := "01";
          end if;
        end if;

      -- lw $s0, 20($t2) -- lw $rt, imm($rs)
      -- add $s1, $t0, $s0 -- add $rd, $rs, $rt
      when MemReadS =>
        if stateB = DecodeS then
          if memrw_rt0 = rs then
            rd1_aluforward_memrd_s0 := "10";
          end if;

          -- lw $s0, 20($t2) -- lw $rt, imm($rs)
          -- add $s1, $t1, $s0 -- add $rd, $rs, $rt
          if memrw_rt0 = rt then
            rd2_aluforward_memrd_s0 := "10";
          end if;
        end if;
      when others =>
        -- do nothing
    end case;
    rd1_aluforward_memrd_s <= rd1_aluforward_memrd_s0;
    rd2_aluforward_memrd_s <= rd2_aluforward_memrd_s0;
  end process;

  -- stall
  process(stateA, stateB, calcs_opcode, rs, rt)
    variable ena0 : std_logic;
  begin
    ena0 := '1';
    if stateA = AdrCalcS and calcs_opcode = OP_LW then
      if calcs_rt = rt or calcs_rt = rs then
        ena0 := '0';
      end if;
    end if;
    ena <= ena0;
  end process;

  process(stateA, stateB, ena)
    variable pc_enA, pc_enB : std_logic;
    variable instr_enA, instr_enB : std_logic;
  begin
    -- for memadr
    pc_enA := get_pc_en(stateA); pc_enB := get_pc_en(stateB);
    pc_en <= (pc_enA or pc_enB) and ena;

    -- for calc
    calc_en <= ena;

    -- for writeback
    instr_enA := get_instr_en(stateA); instr_enB := get_instr_en(stateB);
    instr_en <= (instr_enA or instr_enB) and ena;
  end process;

  process(stateA, stateB)
    -- for memadr
    variable pc_aluout_sA, pc_aluout_sB : std_logic;

    -- for memwrite
    variable mem_weA, mem_weB: std_logic;
    -- for decode
    -- for writeback
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

    -- for memwrite
    mem_weA := get_mem_we(stateA); mem_weB := get_mem_we(stateB);
    mem_we <= mem_weA or mem_weB;

    -- for decode

    -- for writeback
    reg_weA := get_reg_we(stateA); reg_weB := get_reg_we(stateB);
    reg_we <= reg_weA or reg_weB;

    memrd_aluout_sA := get_memrd_aluout_s(stateA); memrd_aluout_sB := get_memrd_aluout_s(stateB);
    memrd_aluout_s <= memrd_aluout_sA or memrd_aluout_sB;

    rt_rd_sA := get_rt_rd_s(stateA); rt_rd_sB := get_rt_rd_s(stateB);
    rt_rd_s <= rt_rd_sA or rt_rd_sB;

    rdt_immext_sA := get_rdt_immext_s(stateA); rdt_immext_sB := get_rdt_immext_s(stateB);
    rdt_immext_s <= rdt_immext_sA or rdt_immext_sB;
  end process;

  -- depending on funct
  process(stateA, stateB, funct)
    variable alucontA, alucontB : std_logic_vector(2 downto 0);
  begin
    -- for calc
    alucontA := get_alucont(stateA, funct); alucontB := get_alucont(stateB, funct);
    alucont <= alucontA or alucontB;
  end process;

  -- depend on aluzero
  process(stateA, stateB, aluzero)
    variable pc4_br4_ja_sA, pc4_br4_ja_sB : std_logic_vector(1 downto 0);
  begin
    pc4_br4_ja_sA := get_pc4_br4_ja_s(stateA, aluzero); pc4_br4_ja_sB := get_pc4_br4_ja_s(stateB, aluzero);
    pc4_br4_ja_s <= pc4_br4_ja_sA or pc4_br4_ja_sB;
  end process;
end architecture;
