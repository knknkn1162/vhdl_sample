library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.state_pkg.ALL;

package debug_pkg is
  function decode_state(state: statetype) return std_logic_vector;
  subtype state_vector_type is std_logic_vector(7 downto 0);
  constant CONST_WAITS : state_vector_type := "00000000";
  constant CONST_INITS : state_vector_type := "00000010";
  constant CONST_LOADS : state_vector_type := "00000011";
  constant CONST_FETCHS : state_vector_type := "00000100";
  constant CONST_DECODES : state_vector_type := "00001000";
  constant CONST_CALCS : state_vector_type := "00010000";
  constant CONST_MEMRWS : state_vector_type := "00100000";
  constant CONST_MEMWBS : state_vector_type := "01000000";
  constant CONST_UNKNOWNS : state_vector_type := "11111111";
end package;

package body debug_pkg is
  -- for debug
  function decode_state(state: statetype) return std_logic_vector is
    variable ret : state_vector_type;
  begin
    case state is
      when WaitS | Wait2S | Wait3S =>
        ret := CONST_WAITS;
      when InitS =>
        ret := CONST_INITS;
      when LoadS =>
        ret := CONST_LOADS;
      when FetchS =>
        ret := CONST_FETCHS;
      when DecodeS =>
        ret := CONST_DECODES;
      when AdrCalcS | RtypeCalcS | AddiCalcS =>
        ret := CONST_CALCS;
      when MemReadS =>
        ret := CONST_MEMRWS;
      when MemWriteBackS =>
        ret := CONST_MEMWBS;
      when UnknownS =>
        ret := CONST_UNKNOWNS;
      when others =>
        -- do nothing
    end case;
    return ret;
  end function;
end package body;
