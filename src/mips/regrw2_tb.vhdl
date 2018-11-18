library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regrw2_tb is
end entity;

architecture testbench of regrw2_tb is
  component regrw2
    generic(regfile : string := "./assets/reg/dummy.hex");
    port (
      clk, rst, load : in std_logic;
      rs, rt : in std_logic_vector(4 downto 0);
      imm : in std_logic_vector(15 downto 0);

      -- from controller
      wa : in std_logic_vector(4 downto 0);
      wd : in std_logic_vector(31 downto 0);
      we : in std_logic;
      cached_rds, cached_rdt : in std_logic_vector(31 downto 0);

      rds, rdt, immext : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk, rst, load : std_logic;
  signal rs, rt : std_logic_vector(4 downto 0);
  signal imm : std_logic_vector(15 downto 0);

  signal wa : std_logic_vector(4 downto 0);
  signal wd : std_logic_vector(31 downto 0);
  signal we : std_logic;

  signal cached_rds, cached_rdt : std_logic_vector(31 downto 0);
  signal rds, rdt, immext : std_logic_vector(31 downto 0);

  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : regrw2 port map (
    clk => clk, rst => rst, load => load,
    rs => rs, rt => rt,
    imm => imm,

    -- from controller
    wa => wa, wd => wd, we => we,
    cached_rds => cached_rds, cached_rdt => cached_rdt,
    rds => rds, rdt => rdt, immext => immext
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
    rst <= '1'; wait for 1 ns; rst <= '0';

    -- read immediate extended 32 bit
    imm <= X"0020"; wait for 1 ns; assert immext = X"00000020";
    -- write
    wa <= "10000"; wd <= X"000000FF"; we <= '1'; wait for clk_period/2;
    we <= '0';
    -- read aluforwarding instead of regval
    rs <= "00001"; wait for 1 ns; assert rds = X"00000000";
    rs <= "10000"; wait for 1 ns; assert rds = X"000000FF";
    rt <= "00001"; wait for 1 ns; assert rdt = X"00000000";
    rt <= "10000"; wait for 1 ns; assert rdt = X"000000FF";

    rs <= "00001"; cached_rds <= X"00000005"; wait for 1 ns; assert rds = X"00000005";
    rt <= "10000"; cached_rdt <= X"00000005"; wait for 1 ns; assert rds = X"00000005";

    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
