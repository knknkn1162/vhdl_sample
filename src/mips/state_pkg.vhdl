library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package state_pkg is
  type statetype is (
    -- soon after the initialization
    InitWait2S, InitWaitS,
    InitS, LoadS,
    FetchS, DecodeS, AdrCalcS, MemReadS,
    MemWriteBackS,
    RtypeCalcS,
    BranchS,
    AddiCalcS,
    JumpS
  );

  function is_calcs(state : statetype) return boolean;
end package;

package body state_pkg is
  function is_calcs(state: statetype) return boolean is
  begin
    return state = AdrCalcS or state = RtypeCalcS or state = AddiCalcS or state = BranchS or state = JumpS;
  end function;
end package body;
