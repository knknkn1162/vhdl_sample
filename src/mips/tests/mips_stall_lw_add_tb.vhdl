library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips_stall_lw_add_tb is
end entity;

architecture testbench of mips_stall_lw_add_tb is
  component mips
    generic(memfile : string; regfile : string := "./assets/reg/dummy.hex");
    port (
      clk, rst, load : in std_logic;
      -- scan for testbench
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0);
      addr, mem_rd, mem_wd : out std_logic_vector(31 downto 0);
      reg_wa : out std_logic_vector(4 downto 0);
      reg_wd : out std_logic_vector(31 downto 0);
      rds, rdt, immext : out std_logic_vector(31 downto 0);
      ja : out std_logic_vector(27 downto 0);
      alures : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst, load : std_logic;
  signal pc, pcnext : std_logic_vector(31 downto 0);
  signal addr, mem_rd, mem_wd : std_logic_vector(31 downto 0);
  signal reg_wa : std_logic_vector(4 downto 0);
  signal reg_wd : std_logic_vector(31 downto 0);
  signal rds, rdt, immext : std_logic_vector(31 downto 0);
  signal ja : std_logic_vector(27 downto 0);
  signal alures : std_logic_vector(31 downto 0);

  constant memfile : string := "./assets/mem/stall_lw_add.hex";
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : mips generic map (memfile=>memfile)
  port map (
    clk => clk, rst => rst, load => load,
    pc => pc, pcnext => pcnext,
    addr => addr, mem_rd => mem_rd, mem_wd => mem_wd,
    reg_wa => reg_wa,
    reg_wd => reg_wd,
    rds => rds, rdt => rdt, immext => immext,
    ja => ja,
    alures => alures
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc: process
  begin
    -- wait until rising_edge
    wait for clk_period;
    -- (InitS, Wait2S)
    rst <= '1'; wait for 1 ns; rst <= '0';
    -- syncronous reset
    load <= '1'; wait for clk_period/2; load <= '0';
    -- (LoadS, WaitS)
    wait for clk_period;

    -- (FetchS, InitS)
    -- -- FetchS : lw $s0, 12($0)
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"8C10000C";
    -- (not yet)
    assert rds = X"00000000"; assert immext = X"00000000";
    wait for clk_period;

    -- (DecodeS, FetchS)
    -- -- DecodeS : lw $s0, 12($0)
    assert rds = X"00000000"; assert immext = X"0000000C";
    -- -- FetchS : add $s1, $s0, $s0
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"02108820";
    wait for clk_period;

    -- (CalcS, DecodeS)
    assert pc = X"00000008"; assert pcnext = X"0000000C";
    -- CalcS(AdrCalcS) : lw $s0, 12($0)
    assert alures = X"0000000C";
    -- DecodeS : add $s1, $s0, $s0
    assert rds = X"00000000"; assert rdt = X"00000000";
    wait for clk_period;

    -- (MemReadS, DecodeS) [Stall]
    -- MemReadS : lw $s0, 12($0)
    assert addr = X"0000000C"; assert mem_rd = X"00000048";
    -- DecodeS : add $s1, $s0, $s0
    assert alures = X"00000090";
    wait for clk_period;

    -- (RegWriteBackS, CalcS)
    -- -- RegWriteBackS : lw $s0, 12($0)
    assert reg_wa = "10000"; assert reg_wd = X"00000048";
    -- -- CalcS
    assert alures = X"00000090";
    wait for clk_period;

    -- (-, ALUWritebackS)
    -- -- ALUWriteBackS : add $s1, $s0, $s0
    assert reg_wa = "10001"; assert reg_wd = X"00000090";


    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
