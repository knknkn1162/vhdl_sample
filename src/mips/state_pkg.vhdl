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

  function is_calcs(state : statetype) return std_logic;
end package;

package body state_pkg is
  function is_calcs(state: statetype) return std_logic is
    variable ret : std_logic;
  begin
    if state = AdrCalcS or state = RtypeCalcS or state = AddiCalcS or state = BranchS or state = JumpS then
      ret = '1';
    else
      ret = '0';
    end if;
    return ret;
  end function;
end package body;
