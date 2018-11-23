package state_pkg is
  type statetype is (
    -- soon after the initialization
    Wait2S, WaitS,
    InitS, LoadS,
    FetchS, DecodeS, AdrCalcS, MemReadS,
    MemWriteBackS,
    RtypeCalcS,
    BranchS,
    AddiCalcS,
    JumpS
  );
end package;
