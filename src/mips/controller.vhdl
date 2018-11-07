library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
  port (
    clk, rst : in std_logic;
    opcode, funct : in std_logic_vector(5 downto 0);
    aluzero : in std_logic;
    -- for memadr
    pc_aluout_s, pc4_br_s : out std_logic;
    pc_en : out std_logic;

    -- for memwrite
    mem_we: out std_logic;
    -- for writeback
    instr_en, reg_we : out std_logic;
    memrd_aluout_s : out std_logic; -- for lw or addi
    rt_rd_s : out std_logic; -- Itype or Rtype
    -- for calc
    alucont : out std_logic_vector(2 downto 0);
    rdt_immext_s : out std_logic
  );
end entity;

architecture behavior of controller is
  type statetype is (
    -- soon after the initialization
    InitS,
    FetchS, DecodeS, AdrCalcS, MemReadS, RegWritebackS,
    MemWriteS,
    RtypeCalcS, ALUWriteBackS,
    BranchS,
    AddiCalcS, AddiWriteBackS
    -- JumpS
  );
  subtype optype is std_logic_vector(5 downto 0);
  constant OP_LW : optype := "100011";
  constant OP_SW : optype := "101011";
  constant OP_ADDI : optype := "001000";
  constant OP_RTYPE : optype := "000000";
  constant OP_BEQ : optype := "000100";

  subtype functtype is std_logic_vector(5 downto 0);
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

  signal state, nextstate : statetype;
begin
  process(clk, rst) begin
    if rst = '1' then
      state <= InitS;
    elsif rising_edge(clk) then
      state <= nextState;
    end if;
  end process;

  -- State Machine
  process(clk, rst, opcode, funct) begin
    case state is
      when InitS =>
        nextState <= FetchS;
      when FetchS =>
        nextState <= DecodeS;
      when DecodeS =>
        case opcode is
          -- lw or sw
          when OP_LW | OP_SW =>
            nextState <= AdrCalcS;
          when OP_RTYPE =>
            nextState <= RtypeCalcS;
          when OP_ADDI =>
            nextState <= AddiCalcS;
          when OP_BEQ =>
            nextState <= BranchS;
          when others =>
            nextState <= FetchS;
        end case;
      when AdrCalcS =>
        case opcode is
          when OP_LW =>
            nextState <= MemReadS;
          when OP_SW =>
            nextState <= MemWriteS;
          when others =>
            nextState <= FetchS;
        end case;
      when AddiCalcS =>
        nextState <= AddiWriteBackS;
      when RtypeCalcS =>
        nextstate <= ALUWriteBackS;
      when MemReadS =>
        nextState <= RegWritebackS;
      -- when final state
      when RegWriteBackS | MemWriteS | AddiWriteBackS | ALUWriteBackS | BranchS =>
        nextState <= FetchS;
      -- if undefined
      when others =>
        nextState <= FetchS;
    end case;
  end process;

  -- for sequential logic
  -- ex) D-flipflop enable signal should be turned on before rising_edge(clk)
  process(state)
    variable pc_en0 : std_logic;
    variable instr_en0 : std_logic;
  begin
    pc_en0 := '0';
    instr_en0 := '0';
    case state is
      when InitS =>
        -- pc_en0 := '0';
      when FetchS =>
        instr_en0 := '1';
      when DecodeS =>
      when RtypeCalcS =>
      when AddiCalcS =>
      when AdrCalcS =>
        -- do nothing
      when MemReadS =>
        -- do nothing
      when MemWriteS | RegWriteBackS | AddiWritebackS | ALUWriteBackS | BranchS =>
        pc_en0 := '1'; -- for fetchS
      when others =>
        -- do nothing;
    end case;

    pc_en <= pc_en0;
    instr_en <= instr_en0;
  end process;

  -- for combinatorial logic
  process(state)
    -- for memadr
    variable pc_aluout_s0 : std_logic;
    variable pc4_br_s0 : std_logic;

    variable rdt_immext_s0 : std_logic;
    -- for regwriteback
    variable memrd_aluout_s0 : std_logic;
    variable rt_rd_s0 : std_logic;

    -- write in the end of the clk process
    -- for memwrite
    variable mem_we0: std_logic;
    -- for writeback
    variable reg_we0 : std_logic;
  begin
    pc_aluout_s0 := '0';
    pc4_br_s0 := '0';
    rdt_immext_s0 := '0';
    memrd_aluout_s0 := '0';
    rt_rd_s0 := '0';
    reg_we0 := '0';
    mem_we0 := '0';
    case state is
      when InitS =>
        -- do nothing
      when FetchS =>
        -- for decoding
        -- pc_aluout_s0 := '0';
      when DecodeS =>
        -- reg_we0 := '0';
      when AdrCalcS =>
        rdt_immext_s0 := '1';
      when RtypeCalcS =>
        -- rdt_immext_s0 := '0';
      when AddiCalcS =>
        rdt_immext_s0 := '1';
      when BranchS =>
        pc4_br_s0 := aluzero;
      when MemReadS =>
        pc_aluout_s0 := '1';
      when MemWriteS =>
        mem_we0 := '1';
        pc_aluout_s0 := '1';
      when RegWriteBackS =>
        reg_we0 := '1';
        -- memrd_aluout_s := '0';
      when AddiWritebackS =>
        reg_we0 := '1';
        memrd_aluout_s0 := '1';
      when ALUWriteBackS =>
        reg_we0 := '1';
        rt_rd_s0 := '1';
        memrd_aluout_s0 := '1';
      when others =>
        -- do nothing
    end case;
    pc_aluout_s <= pc_aluout_s0;
    pc4_br_s <= pc4_br_s0;
    rdt_immext_s <= rdt_immext_s0;
    memrd_aluout_s <= memrd_aluout_s0;
    rt_rd_s <= rt_rd_s0;
    mem_we <= mem_we0;
    reg_we <= reg_we0;
  end process;

  -- alucontroller
  process(state)
    -- for memadr
    variable alucont0 : std_logic_vector(2 downto 0);
  begin
    alucont0 := "000";
    case state is
      when InitS =>
      when FetchS =>
      when DecodeS =>
      when AdrCalcS =>
        alucont0 := "010";
      when RtypeCalcS =>
        case funct is
          when FUNCT_ADD =>
            alucont0 := "010";
          when FUNCT_AND =>
            alucont0 := "000";
          when FUNCT_SUB =>
            alucont0 := "110";
          when FUNCT_SLT =>
            alucont0 := "111";
          when FUNCT_OR =>
            alucont0 := "001";
          when others =>
            alucont0 := "000";
        end case;
      when AddiCalcS =>
        alucont0 := "010";
      when MemReadS =>
      when MemWriteS =>
      when RegWriteBackS =>
      when AddiWritebackS =>
      when others =>
        -- do nothing
    end case;
    alucont <= alucont0;
  end process;
end architecture;
