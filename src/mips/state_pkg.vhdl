library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package state_pkg is
  type statetype is (
    -- soon after the initialization
    Wait4S, Wait3S, Wait2S, WaitS,
    InitS, LoadS,
    FetchS, DecodeS, AdrCalcS, MemReadS,
    MemWriteBackS,
    RtypeCalcS,
    AddiCalcS,
    UnknownS
  );
end package;
