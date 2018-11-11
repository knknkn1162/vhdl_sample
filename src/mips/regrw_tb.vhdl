library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regrw_tb is
end entity;

architecture testbench of regrw_tb is
  component regrw
    generic(regfile : string := "./assets/dummy.hex");
    port (
      clk, rst, load : in std_logic;
      rs, rt, rd : in std_logic_vector(4 downto 0);
      mem_rd, aluout : in std_logic_vector(31 downto 0);
      imm : in std_logic_vector(15 downto 0);

      rds, rdt, immext : out std_logic_vector(31 downto 0);
      -- forwarding for pipeline
      aluforward : in std_logic_vector(31 downto 0);
      -- controller
      we : in std_logic;
      memrd_aluout_s , rt_rd_s: in std_logic;
      -- -- forwarding for pipeline
      rd1_aluforward_s, rd2_aluforward_s : in std_logic;
      -- scan
      wa : out std_logic_vector(4 downto 0);
      wd : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst, load : std_logic;
  signal rs, rt, rd : std_logic_vector(4 downto 0);
  signal mem_rd, aluout : std_logic_vector(31 downto 0);
  signal imm : std_logic_vector(15 downto 0);
  signal rds, rdt, immext : std_logic_vector(31 downto 0);
  signal aluforward : std_logic_vector(31 downto 0);
  -- controller
  signal we : std_logic;
  signal memrd_aluout_s, rt_rd_s : std_logic;
  -- forwarding or pipeline
  signal rd1_aluforward_s, rd2_aluforward_s : std_logic;

  -- scan
  signal wa : std_logic_vector(4 downto 0);
  signal wd : std_logic_vector(31 downto 0);

  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : regrw port map (
    clk => clk, rst => rst, load => load,
    rs => rs, rt => rt, rd => rd,
    mem_rd => mem_rd, aluout => aluout,
    imm => imm,
    rds => rds, rdt => rdt, immext => immext,
    -- pipeline
    aluforward => aluforward,
    -- controller
    we => we,
    memrd_aluout_s => memrd_aluout_s, rt_rd_s => rt_rd_s,
    -- forwarding for pipeline
    rd1_aluforward_s => rd1_aluforward_s, rd2_aluforward_s => rd2_aluforward_s,
    -- scan
    wa => wa, wd => wd
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for clk_period;
    rt_rd_s <= '0';
    rst <= '1'; we <= '0'; wait for 1 ns; rst <= '0';

    -- read immediate extended 32 bit
    imm <= X"0020"; wait for 1 ns; assert immext = X"00000020";
    -- read aluforwarding instead of regval
    rs <= "00001"; aluforward <= X"0000000F"; rd1_aluforward_s <= '1'; wait for 1 ns;
    assert rds = X"0000000F"; rd1_aluforward_s <= '0';
    rt <= "00001"; aluforward <= X"0000000E"; rd2_aluforward_s <= '1'; wait for 1 ns;
    assert rdt = X"0000000E"; rd2_aluforward_s <= '0';

    -- reg writeback
    rt <= "00001"; we <= '1'; mem_rd <= X"0000000A"; memrd_aluout_s <= '0'; wait for clk_period/2;
    assert wa <= "00001"; assert wd <= X"0000000A";
    rt <= "00001"; we <= '0'; wait for clk_period; assert rdt = X"0000000A"; -- check
    
    -- immediate writeback
    rt <= "00001"; we <= '1'; aluout <= X"0000000B"; memrd_aluout_s <= '1'; wait for clk_period;
    assert wa <= "00001"; assert wd <= X"0000000B";
    rt <= "00001"; we <= '0'; wait for clk_period; assert rdt = X"0000000B"; -- check
    
    -- Rtype writeback
    rd <= "00001"; we <= '1'; aluout <= X"0000000C"; memrd_aluout_s <= '1'; rt_rd_s <= '1'; wait for clk_period;
    assert wa <= "00001"; assert wd <= X"0000000C";
    rt <= "00001"; we <= '0'; wait for clk_period; assert rdt = X"0000000C";

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
