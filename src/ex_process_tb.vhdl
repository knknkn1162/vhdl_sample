library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ex_process_tb is
end entity;

architecture testbench of ex_process_tb is
  component ex_process is
    port (
      clk, rst, ld : in std_logic;
      data : in unsigned(3 downto 0);
      q : out std_logic_vector(3 downto 0);
      a, b : in std_logic_vector(3 downto 0);
      c : out std_logic_vector(3 downto 0)
        );
  end component;

  type Operation is (Load, Store, Move, Halt);
  constant clk_period : time := 10 ns;
  signal stop : boolean;
  signal clk, rst : std_logic;
  signal a, b : std_logic_vector(7 downto 0);
  signal op : Operation;
  signal q, c : std_logic_vector(3 downto 0);

begin
  uut : ex_process port map(
    clk, rst, b(0), unsigned(b(7 downto 4)), q, a(7 downto 4), a(3 downto 0), c
  );
  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  resetgen: process
  begin
    rst <= '0'; wait for 10 ns;
    rst <= '1'; wait for 90 ns;
    rst <= '0'; wait for 20 ns;
    rst <= '1'; wait for 180 ns;
    wait;
  end process;

  stim_proc: process
  type Table is array (Natural range <>) of std_logic_vector(7 downto 0);
  constant Lookup : Table := (
    "00000000",
    "00000001",
    "00000011",
    "00001000",
    "00001111",
    "10000000",
    "11111000",
    "11111111"
  );
  begin
    for lp in 1 to 2 loop
      for i in Lookup'range loop
        b <= Lookup(I);
        for j in Lookup'range loop
          a <= Lookup(j);
          for k in operation loop
            op <= k;
            wait for clk_period;
          end loop;
        end loop;
      end loop;
      stop <= True;
    end loop;
    wait;
  end process;
end architecture;
