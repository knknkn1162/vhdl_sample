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

  function is_init(state: statetype) return std_logic;
end package;

package body state_pkg is
  function is_init(state: statetype) return std_logic is
    variable res : std_logic;
  begin
    if res = Wait4S or res = Wait3S or res = Wait2S or res = WaitS or res = InitS or res = LoadS then
      res = '1';
    else
      res = '0';
    end if;
    return res;
  end function;
end package body;
