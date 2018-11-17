package state_pkg is
  type statetype is (
    -- soon after the initialization
    Wait3S, Wait2S, WaitS,
    InitS, LoadS,
    FetchS, DecodeS, AdrCalcS, MemReadS, RegWritebackS,
    MemWriteS,
    RtypeCalcS, ALUWriteBackS,
    BranchS,
    AddiCalcS, AddiWriteBackS,
    JumpS
  );
end package;
