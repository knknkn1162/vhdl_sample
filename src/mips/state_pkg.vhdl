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
end package;
