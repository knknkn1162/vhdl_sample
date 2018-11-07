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
      alures : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst : std_logic;
  signal pc, pcnext : std_logic_vector(31 downto 0);
  signal addr, mem_rd, mem_wd : std_logic_vector(31 downto 0);
  signal reg_wa : std_logic_vector(4 downto 0);
  signal reg_wd : std_logic_vector(31 downto 0);
  signal rds, rdt, immext : std_logic_vector(31 downto 0);
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
    --         addi $rt, $rs, imm
    -- main:   addi $2, $0, 5      # initialize $2 = 5  0       20020005
    -- 0010/00 00/000 0/0010/ X0005
    -- FetchS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"20020005";
    -- (not yet)
    assert rds = X"00000000"; assert immext = X"00000000";
    wait for clk_period;
    -- DecodeS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"20020005";
    assert rds = X"00000000"; assert immext = X"00000005";
    wait for clk_period;
    -- AddiCalcS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert mem_rd = X"20020005";
    assert alures = X"00000005";
    wait for clk_period;
    -- AddiWritebackS
    assert pc = X"00000000"; assert pcnext = X"00000004";
    assert reg_wa = "00010"; assert reg_wd = X"00000005";
    wait for clk_period;

    -- addi $rt, $rs, imm
    -- addi $3, $0, 12     # initialize $3 = 12 4       2003000c
    -- 0010/00 00/000 0/0011/ X000C
    -- FetchS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"2003000C";
    wait for clk_period;
    -- DecodeS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"2003000C";
    assert rds = X"00000000"; assert immext = X"0000000C";
    wait for clk_period;
    -- AddiCalcS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert mem_rd = X"2003000C";
    assert alures = X"0000000C";
    wait for clk_period;
    -- AddiWritebackS
    assert pc = X"00000004"; assert pcnext = X"00000008";
    assert reg_wa = "00011"; assert reg_wd = X"0000000C";
    wait for clk_period;

    -- addi $rt, $rs, imm
    -- addi $7, $3, -9     # initialize $7 = 3  8       2067fff7
    -- 0010/00 00/011 0/0111/ XFFF7
    -- FetchS
    assert pc = X"00000008"; assert pcnext = X"0000000C";
    assert mem_rd = X"2067FFF7";
    wait for clk_period;
    -- DecodeS
    assert pc = X"00000008"; assert pcnext = X"0000000C";
    assert mem_rd = X"2067FFF7";
    assert rds = X"0000000C"; assert immext = X"FFFFFFF7";
    wait for clk_period;
    -- AddiCalcS
    assert pc = X"00000008"; assert pcnext = X"0000000C";
    assert mem_rd = X"2067FFF7";
    assert alures = X"00000003";
    wait for clk_period;
    -- AddiWritebackS
    assert pc = X"00000008"; assert pcnext = X"0000000C";
    assert reg_wa = "00111"; assert reg_wd = X"00000003";
    wait for clk_period;

    -- or $rd, $rs, $rt
    -- or   $4, $7, $2     # $4 <= 3 or 5 = 7   c       00e22025
    -- 0000/00 00/111 0/0010/ 0010/0 000/00 10/0101
    -- FetchS
    assert pc = X"0000000C"; assert pcnext = X"00000010";
    assert mem_rd = X"00E22025";
    wait for clk_period;

    -- DecodeS
    assert pc = X"0000000C"; assert pcnext = X"00000010";
    assert mem_rd = X"00E22025";
    assert rds = X"00000003"; assert rdt = X"00000005";
    wait for clk_period;

    -- RtypeCalcS
    assert pc = X"0000000C"; assert pcnext = X"00000010";
    assert mem_rd = X"00E22025";
    assert alures = X"00000007";
    wait for clk_period;

    -- ALUWriteBackS
    assert pc = X"0000000C"; assert pcnext = X"00000010";
    assert reg_wa = "00100"; assert reg_wd = X"00000007";
    wait for clk_period;


    -- and $rd, $rs, $rt
    -- and $5,  $3, $4     # $5 <= 12 and 7 = 4 10      00642824
    -- FetchS
    -- assert pc = X"00000010"; assert pcnext = X"00000014";



    -- add $rd, $rs, $rt
    -- add $5,  $5, $4     # $5 = 4 + 7 = 11    14      00a42820
    -- FetchS
    -- assert pc = X"00000014"; assert pcnext = X"00000018";

    assert false report "end of test" severity note;
    stop <= TRUE;
    wait;
  end process;
  

end architecture;
