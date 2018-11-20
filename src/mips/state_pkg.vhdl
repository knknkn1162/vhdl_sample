package state_pkg is
  type statetype is (
    -- soon after the initialization
    Wait2S, WaitS,
    InitS, LoadS,
    FetchS, DecodeS, AdrCalcS, MemReadS, RegWritebackS,
    MemWriteBackS,
    RtypeCalcS, ALUWriteBackS,
    BranchS,
    AddiCalcS, AddiWriteBackS,
    JumpS
  );
end package;
