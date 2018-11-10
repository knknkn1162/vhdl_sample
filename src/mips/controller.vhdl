library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.controller_pkg.ALL;

entity controller is
  port (
    clk, rst : in std_logic;
    opcode, funct : in std_logic_vector(5 downto 0);
    rs, rt, rd : std_logic_vector(4 downto 0);
    aluzero : in std_logic;
    -- for memadr
    pc_aluout_s : out std_logic;
    pc0_br_s : out std_logic_vector(1 downto 0);
    pc_en : out std_logic;

    -- for memwrite
    mem_we: out std_logic;
    -- for decode
    -- -- forwarding for pipeline
    rd1_aluforward_s, rd2_aluforward_s : out std_logic;
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
  signal dec_sa, dec_sb : std_logic_vector(6 downto 0);
  signal stateB, nextstateB : statetype;
  signal instr_shift_en : std_logic;
  signal calcs_opcode, calcs_funct : std_logic_vector(5 downto 0);
  signal calcs_rs, calcs_rt, calcs_rd : std_logic_vector(4 downto 0);


  component instr_shift_register
    port (
      clk, rst, en : in std_logic;
      nxt_opcode, nxt_funct : in std_logic_vector(5 downto 0);
      nxt_rs, nxt_rt, nxt_rd : in std_logic_vector(4 downto 0);
      cur_opcode, cur_funct : out std_logic_vector(5 downto 0);
      cur_rs, cur_rt, cur_rd : out std_logic_vector(4 downto 0)
    );
  end component;

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

  process(stateA, stateB)
  begin
    dec_sa <= decode_state(stateA);
    dec_sb <= decode_state(stateB);
  end process;

  -- State Machine
  process(clk, rst, opcode, funct)
    variable stateA0, nextstateA0 : statetype;
    variable stateB0, nextstateB0 : statetype;
  begin
    nextstateA0 := get_nextstate(stateA, opcode);
    nextstateB0 := get_nextstate(stateB, opcode);
    -- todo : additional expr
    nextstateA <= nextstateA0;
    nextstateB <= nextstateB0;
  end process;


  instr_shift_en <= '1';
  instr_shift_register0 : instr_shift_register port map (
    clk => clk, rst => rst, en => instr_shift_en,
    nxt_opcode => opcode, nxt_funct => funct,
    nxt_rs => rs, nxt_rt => rt, nxt_rd => rd,
    cur_opcode => calcs_opcode, cur_funct => calcs_funct,
    cur_rs => calcs_rs, cur_rt => calcs_rt, cur_rd => calcs_rd
  );

  process(stateA, stateB)
    -- for memadr
    variable pc_aluout_sA, pc_aluout_sB : std_logic;
    variable pc_enA, pc_enB : std_logic;

    -- for memwrite
    variable mem_weA, mem_weB: std_logic;
    -- for decode
    -- -- forwarding for pipeline
    variable rd1_aluforward_s0 : std_logic;
    variable rd2_aluforward_s0 : std_logic;
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
    -- forwarding for pipeline
    rd1_aluforward_s0 := '0'; rd2_aluforward_s0 := '0';
    case stateA is
      when AddiCalcS =>
        if stateB = DecodeS then
          -- addi $s0, $t1, $t2 -- addi $rt, $rs, imm
          -- add $s1, $s0, $t1 -- add $rd, $rs, $rt
          if calcs_rt = rs then
            rd1_aluforward_s0 := '1';
          end if;

          -- addi $s0, $t1, $t2 -- addi $rt, $rs, imm
          -- add $s1, $t1, $s0 -- add $rd, $rs, $rt
          if calcs_rt = rt then
            rd2_aluforward_s0 := '1';
          end if;
        end if;
      when RtypeCalcS =>
        if stateB = DecodeS then
          -- add $s0, $t1, $t2 -- add $rd, $rs, $rt
          -- add $s1, $s0, $t1 -- add $rd, $rs, $rt
          if calcs_rd = rs then
            rd1_aluforward_s0 := '1';
          end if;

          -- add $s0, $t1, $t2 -- add $rd, $rs, $rt
          -- add $s1, $t1, $s0 -- add $rd, $rs, $rt
          if calcs_rd = rt then
            rd2_aluforward_s0 := '1';
          end if;
        end if;
      when others =>
        -- do nothing
    end case;
    rd1_aluforward_s <= rd1_aluforward_s0; rd2_aluforward_s <= rd2_aluforward_s0;

    -- for writeback
    instr_enA := get_instr_en(stateA); instr_enB := get_instr_en(stateB);
    instr_en <= instr_enA or instr_enB;

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
    variable pc0_br_sA, pc0_br_sB : std_logic_vector(1 downto 0);
  begin
    pc0_br_sA := get_pc0_br_s(stateA, aluzero); pc0_br_sB := get_pc0_br_s(stateB, aluzero);
    pc0_br_s <= pc0_br_sA or pc0_br_sB;
  end process;
end architecture;
