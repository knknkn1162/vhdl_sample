library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regrw_tb is
end entity;

architecture testbench of regrw_tb is
  component regrw
    port (
      clk, rst : in std_logic;
      rs, rt : in std_logic_vector(4 downto 0);
      wd : in std_logic_vector(31 downto 0);
      imm : in std_logic_vector(15 downto 0);

      rds, rdt, immext : out std_logic_vector(31 downto 0);
      -- controller
      we : in std_logic;
      wa : out std_logic_vector(4 downto 0)
    );
  end component;

  signal clk, rst : std_logic;
  signal rs, rt : std_logic_vector(4 downto 0);
  signal wd : std_logic_vector(31 downto 0);
  signal imm : std_logic_vector(15 downto 0);
  signal rds, rdt, immext : std_logic_vector(31 downto 0);
  -- controller
  signal we : std_logic;
  signal wa : std_logic_vector(4 downto 0);

  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : regrw port map (
    clk => clk, rst => rst,
    rs => rs, rt => rt,
    wd => wd,
    imm => imm,
    rds => rds, rdt => rdt, immext => immext,
    we => we, wa => wa
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
    rst <= '1'; we <= '0'; wait for 1 ns; rst <= '0';

    -- mem writeback
    rt <= "00001"; we <= '1'; wd <= X"0000000A"; wait for clk_period/2;
    assert wa <= "00001";
    -- check whether the data is written
    rt <= "00001"; we <= '0'; wait for clk_period;

    imm <= X"0020"; wait for 1 ns; assert immext = X"00000020";

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
