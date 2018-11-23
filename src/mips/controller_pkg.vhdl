library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.state_pkg.ALL;

package controller_pkg is
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

  function get_nextstate(state: statetype; decs_op: std_logic_vector(5 downto 0); calcs_op: std_logic_vector(5 downto 0); load : std_logic; ena : std_logic; enb : std_logic) return statetype;
  function get_pc_en(state: statetype) return std_logic;
  function get_instr_en(state: statetype) return std_logic;
  function get_pc4_br4_ja_s(state : statetype; aluzero : std_logic) return std_logic_vector;
  function get_mem_we(state : statetype) return std_logic;
  function get_alucont(state : statetype; funct : std_logic_vector(5 downto 0)) return std_logic_vector;
  function get_pc_aluout_s(state: statetype) return std_logic;
  function get_rdt_immext_s(state : statetype) return std_logic;
  function get_ena(state: statetype; calcs_opcode : std_logic_vector(5 downto 0); rs : std_logic_vector(4 downto 0); rt: std_logic_vector(4 downto 0); calcs_rt : std_logic_vector(4 downto 0)) return std_logic;
  function get_enb(state1: statetype; state2: statetype) return std_logic;
end package;

package body controller_pkg is
  function get_enb(state1: statetype; state2 : statetype) return std_logic is
    variable enb : std_logic;
  begin
    enb := '1';
    if state1 = MemReadS or state1 = MemWriteBackS then
      -- AdrCalcS is not the end of the state, so the condition `state = AdrCalcS` must not be added
      if state2 = RtypeCalcS or state2 = AddiCalcS or state2 = BranchS or state2 = JumpS then
        enb := '0';
      end if;
    end if;
    return enb;
  end function;

  function get_ena(state: statetype; calcs_opcode : std_logic_vector(5 downto 0); rs : std_logic_vector(4 downto 0); rt: std_logic_vector(4 downto 0); calcs_rt : std_logic_vector(4 downto 0)) return std_logic is
    variable ena : std_logic;
  begin
    ena := '1';
    if state = AdrCalcS and calcs_opcode = OP_LW then
      if calcs_rt = rt or calcs_rt = rs then
        ena := '0';
      end if;
    end if;
    return ena;
  end function;

  function get_nextstate(state: statetype; decs_op: std_logic_vector(5 downto 0); calcs_op: std_logic_vector(5 downto 0); load : std_logic; ena : std_logic; enb : std_logic) return statetype is
    variable nextstate : statetype;
  begin
    case state is
      when InitWait3S =>
        nextState := InitWait2S;
      when InitWait2S =>
        nextstate := InitWaitS;
      when InitWaitS =>
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
        -- stall
        if ena = '1' then
          nextState := DecodeS;
        else
          -- stay the same state
          nextstate := FetchS;
        end if;
      when DecodeS =>
        -- stall
        if ena = '1' and enb = '1' then
          case decs_op is
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
              nextState := UnknownS;
          end case;
        else
          -- stay the same state
          nextState := DecodeS;
        end if;
      when AdrCalcS =>
        case calcs_op is
          when OP_LW =>
            nextState := MemReadS;
          when OP_SW =>
            nextState := MemWriteBackS;
          when others =>
            nextState := UnknownS;
        end case;
      -- when final state
      when AddiCalcS | RtypeCalcS | BranchS | JumpS =>
        if enb = '1' then
          nextState := FetchS;
        else
          nextState := state;
        end if;
      when MemReadS | MemWriteBackS =>
        nextState := FetchS;
      -- if undefined
      when others =>
        nextState := UnknownS;
    end case;
    return nextstate;
  end function;

  function get_pc_en(state: statetype) return std_logic is
    variable ret : std_logic;
  begin
    case state is
      -- when initialization
      when InitS | LoadS | InitWaitS | InitWait2S | InitWait3S =>
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

  function get_pc4_br4_ja_s(state : statetype; aluzero : std_logic) return std_logic_vector is
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

  function get_mem_we(state : statetype) return std_logic is
    -- for memwrite
    variable ret: std_logic;
  begin
    case state is
      when MemWriteBackS =>
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
      when MemReadS | MemWriteBackS =>
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
end package body;
