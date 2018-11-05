library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
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
end entity;

architecture behavior of controller is
  type statetype is (
    FetchS, DecodeS, MemAdrS, MemReadS, MemWritebackS,
    MemWriteS
    -- ExecuteS, ALUWriteBackS,
    -- BranchS,
    -- AddiExecuteS, AddiWriteBackS,
    -- JumpS
  );
  subtype optype is std_logic_vector(5 downto 0);
  constant op_lw : optype := "100011";
  constant op_sw : optype := "101011";
  constant op_rtype : optype := "000000";
  signal state, nextstate : statetype;
begin
  process(clk, rst) begin
    if rst = '1' then
      state <= FetchS;
    elsif rising_edge(clk) then
      state <= nextState;
    end if;
  end process;

  -- State Machine
  process(clk, rst, opcode, funct) begin
    case state is
      when FetchS =>
        nextState <= DecodeS;
      when DecodeS =>
        case opcode is
          -- lw or sw
          when op_lw | op_sw =>
            nextState <= MemAdrS;
          --when op_rtype =>
          --  nextState <= ExecuteS;
          when others =>
            nextState <= FetchS;
        end case;
      when MemAdrS =>
        case opcode is
          when op_lw =>
            nextState <= MemWriteS;
          when others =>
            nextState <= FetchS;
        end case;
      when MemReadS =>
        nextState <= MemWritebackS;
      -- when final state
      when MemWriteBackS | MemWriteS =>
        nextState <= FetchS;
      -- if undefined
      when others =>
        nextState <= FetchS;
    end case;
  end process;
  process(state)
    -- for memadr
    variable pc_aluout_s0, pc_en0 : std_logic;
    -- for memwrite
    variable mem_we: std_logic;
    -- for decode
    variable instr_en,
    -- for writeback
    variable reg_we : std_logic;
    -- for memadr
    variable alucont : std_logic_vector(2 downto 0);
    variable rt_imm_s : std_logic
  begin
    pc_aluout_s0 := '0';
    pc_en0 := '0';
    mem_we0 := '0';
    instr_en0 := '0';
    reg_we0 := '0';
    alucont0 := "000";
    rt_imm_s0 := '0';

    case state is
      when FetchS =>
        -- for memadr
        pc_en0 := '1';
        pc_aluout_s0 := '0';
      when DecodeS =>
        instr_en0 := '1';
      when others =>
        -- do nothing
    end case;
    pc_aluout_s <= pc_aluout_s0;
  end process;
end architecture;
