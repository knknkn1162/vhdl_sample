library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips_tb is
end entity;

architecture behavior of mips_tb is
  component mips
    port (
      clk, rst : in std_logic;
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

  signal clk, rst : std_logic;
  signal pc, pcnext : std_logic_vector(31 downto 0);
  signal addr, mem_rd, mem_wd : std_logic_vector(31 downto 0);
  signal reg_wa : std_logic_vector(4 downto 0);
  signal reg_wd : std_logic_vector(31 downto 0);
  signal rds, rdt, immext : std_logic_vector(31 downto 0);
  signal ja : std_logic_vector(27 downto 0);
  signal alures : std_logic_vector(31 downto 0);

  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut: mips port map (
    clk => clk, rst => rst,
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
    -- InitS
    rst <= '1'; wait for 1 ns; rst <= '0';
    wait for clk_period/2;
    -- addi $rt, $rs, imm
    --    main:   addi $s0, $0, 5
    -- 0010/00 00/000 1/0000 0x0005
    -- FetchS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"20100005";
    -- (not yet)
    assert rds = X"00000000"; assert immext = X"00000000";
    wait for clk_period;
    -- DecodeS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"20100005";
    assert rds = X"00000000"; assert immext = X"00000005";
    wait for clk_period;
    -- AddiCalcS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"20100005";
    assert alures = X"00000005";
    wait for clk_period;
    -- AddiWritebackS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert reg_wa = "10000"; assert reg_wd = X"00000005";
    wait for clk_period;


    -- add $rd, $rs, $rt
    -- add $s1, $s0, $s0
    -- 0000/00 10/000 1/0000 /1000/1 000/00 10/0000
    -- ram(1) <= X"02108820";
    -- FetchS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"02108820";
    wait for clk_period;
    -- DecodeS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"02108820";
    assert rds = X"00000005"; assert rdt = X"00000005";
    wait for clk_period;
    -- RtypeCalcS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"02108820";
    assert alures = X"0000000A";
    wait for clk_period;
    -- ALUWriteBackS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"02108820";
    assert reg_wa = "10001"; assert reg_wd = X"0000000A";
    wait for clk_period;

    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
