library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package controller_pkg is
  type statetype is (
    -- soon after the initialization
    Wait2S, WaitS,
    InitS, LoadS,
    FetchS, DecodeS, AdrCalcS, MemReadS, RegWritebackS,
    MemWriteS,
    RtypeCalcS, ALUWriteBackS,
    BranchS,
    AddiCalcS, AddiWriteBackS,
    JumpS
  );
  subtype optype is std_logic_vector(5 downto 0);
  subtype functtype is std_logic_vector(5 downto 0);

  constant OP_LW : optype := "100011";
  constant OP_SW : optype := "101011";
  constant OP_ADDI : optype := "001000"; -- 0x08
  constant OP_ADDIU : optype := "001001"; -- 0x09
  constant OP_ANDI : optype := "001100"; -- 0x0C
  constant OP_SLTI : optype := "001010"; -- 0x0A

  constant OP_RTYPE : optype := "000000";
  constant OP_BEQ : optype := "000100";
  constant OP_J : optype := "000010"; -- 0x02

  constant FUNCT_ADD : functtype := "100000"; -- 0x20
  constant FUNCT_ADDU : functtype := "100001"; -- 0x21
  constant FUNCT_AND : functtype := "100100"; -- 0x24
  constant FUNCT_DIV : functtype := "011010"; -- 0x1A
  constant FUNCT_DIVU : functtype := "011011"; -- 0x1B
  constant FUNCT_JR : functtype := "001000"; -- 0x08
  constant FUNCT_NOR : functtype := "100111"; -- 0x27
  constant FUNCT_XOR : functtype := "100110"; -- 0x26
  constant FUNCT_OR : functtype := "100101"; -- 0x25
  constant FUNCT_SLT : functtype := "101010"; -- 0x2A
  constant FUNCT_SLL : functtype := "000000"; -- 0x00
  constant FUNCT_SRL : functtype := "000010"; -- 0x02
  constant FUNCT_SUB : functtype := "100010"; -- 0x22
  constant FUNCT_SUBU : functtype := "100011"; -- 0x23

  function decode_state(state: statetype) return std_logic_vector;
  function get_nextstate(state: statetype; opcode: std_logic_vector(5 downto 0); load : std_logic) return statetype;
  function get_pc_en(state: statetype) return std_logic;
  function get_instr_en(state: statetype) return std_logic;
  function get_pc0_br_s(state : statetype; aluzero : std_logic) return std_logic_vector;
  function get_mem_we(state : statetype) return std_logic;
  function get_reg_we(state : statetype) return std_logic;
  function get_alucont(state : statetype; funct : std_logic_vector(5 downto 0)) return std_logic_vector;
  function get_pc_aluout_s(state: statetype) return std_logic;
  function get_rdt_immext_s(state : statetype) return std_logic;
  function get_memrd_aluout_s(state : statetype) return std_logic;
  function get_rt_rd_s(state : statetype) return std_logic;
end package;

package body controller_pkg is
  -- for debug
  function decode_state(state: statetype) return std_logic_vector is
    variable ret : std_logic_vector(6 downto 0);
  begin
    case state is
      when WaitS | Wait2S =>
        ret := "0000000";
      when InitS =>
        ret := "0000010";
      when LoadS =>
        ret := "0000011";
      when FetchS =>
        ret := "0000100";
      when DecodeS =>
        ret := "0001000";
      when AdrCalcS | RtypeCalcS | AddiCalcS | BranchS | JumpS =>
        ret := "0010000";
      when MemReadS =>
        ret := "0100000";
      when RegWriteBackS | ALUWriteBackS | AddiWriteBackS =>
        ret := "1000000";
      when others =>
        -- do nothing
    end case;
    return ret;
  end function;

  function get_nextstate(state: statetype; opcode: std_logic_vector(5 downto 0); load : std_logic) return statetype is
    variable nextstate : statetype;
  begin
    case state is
      when Wait2S =>
        nextstate := WaitS;
      when WaitS =>
        nextState := InitS;
      when InitS =>
        if load = '1' then
          nextstate := LoadS;
        else
          nextState := FetchS;
        end if;
      when LoadS =>
        nextState := FetchS;
      when FetchS =>
        nextState := DecodeS;
      when DecodeS =>
        case opcode is
          -- lw or sw
          when OP_LW | OP_SW =>
            nextState := AdrCalcS;
          when OP_RTYPE =>
            nextState := RtypeCalcS;
          when OP_ADDI =>
            nextState := AddiCalcS;
          when OP_BEQ =>
            nextState := BranchS;
          when OP_J =>
            nextstate := JumpS;
          when others =>
            nextState := FetchS;
        end case;
      when AdrCalcS =>
        case opcode is
          when OP_LW =>
            nextState := MemReadS;
          when OP_SW =>
            nextState := MemWriteS;
          when others =>
            nextState := FetchS;
        end case;
      when AddiCalcS =>
        nextState := AddiWriteBackS;
      when RtypeCalcS =>
        nextstate := ALUWriteBackS;
      when MemReadS =>
        nextState := RegWritebackS;
      -- when final state
      when RegWriteBackS | MemWriteS | AddiWriteBackS | ALUWriteBackS | BranchS | JumpS =>
        nextState := FetchS;
      -- if undefined
      when others =>
        nextState := WaitS;
    end case;
    return nextstate;
  end function;

  function get_pc_en(state: statetype) return std_logic is
    variable ret : std_logic;
  begin
    case state is
      when InitS | LoadS | WaitS | Wait2S =>
        ret := '0';
      when others =>
        ret := '1';
    end case;
    return ret;
  end function;

  function get_instr_en(state: statetype) return std_logic is
    variable ret : std_logic;
  begin
    if state = FetchS then
      ret := '1';
    else
      ret := '0';
    end if;
    return ret;
  end function;

  function get_pc0_br_s(state : statetype; aluzero : std_logic) return std_logic_vector is
    variable ret : std_logic_vector(1 downto 0);
  begin
    case state is
      when BranchS =>
        ret := "0" & aluzero;
      when JumpS =>
        ret := "10";
      when others =>
        -- pc+4
        ret := "00";
    end case;
    return ret;
  end function;

  function get_reg_we(state : statetype) return std_logic is
    -- for writeback
    variable ret : std_logic;
  begin
    case state is
      when RegWriteBackS | AddiWritebackS | ALUWriteBackS =>
        ret := '1';
      when others =>
        -- required : DecodeS
        ret := '0';
    end case;
    return ret;
  end function;

  function get_mem_we(state : statetype) return std_logic is
    -- for memwrite
    variable ret: std_logic;
  begin
    case state is
      when MemWriteS =>
        ret := '1';
      when others =>
        -- required : MemReadS
        ret := '0';
    end case;
    return ret;
  end function;

  function get_alucont(state : statetype; funct : std_logic_vector(5 downto 0)) return std_logic_vector is
    variable ret : std_logic_vector(2 downto 0);
  begin
    case state is
      when AdrCalcS =>
        ret := "010";
      when RtypeCalcS =>
        case funct is
          when FUNCT_ADD =>
            ret := "010";
          when FUNCT_AND =>
            ret := "000";
          when FUNCT_SUB =>
            ret := "110";
          when FUNCT_SLT =>
            ret := "111";
          when FUNCT_OR =>
            ret := "001";
          when others =>
            ret := "000";
        end case;
      when AddiCalcS =>
        ret := "010";
      when others =>
        ret := "000";
    end case;
    return ret;
  end function;

  function get_pc_aluout_s(state: statetype) return std_logic is
    variable ret : std_logic;
  begin
    case state is
      when MemReadS | MemWriteS =>
        ret := '1';
      when others =>
        -- required : FetchS
        ret := '0';
    end case;
    return ret;
  end function;

  function get_rdt_immext_s(state : statetype) return std_logic is
    variable ret : std_logic;
  begin
    case state is
      when AdrCalcS | AddiCalcS =>
        ret := '1';
      when others =>
        -- required : RtypeCalcS
        ret := '0';
    end case;
    return ret;
  end function;

  function get_memrd_aluout_s(state : statetype) return std_logic is
    variable ret : std_logic;
  begin
    case state is
      when AddiWritebackS | ALUWriteBackS =>
        ret := '1';
      when others =>
        -- required : RegWriteBackS
        ret := '0';
    end case;
    return ret;
  end function;

  function get_rt_rd_s(state : statetype) return std_logic is
    variable ret : std_logic;
  begin
    case state is
      when ALUWriteBackS =>
        ret := '1';
      when others =>
        -- required : AddiWritebackS
        ret := '0';
    end case;
    return ret;
  end function;
end package body;