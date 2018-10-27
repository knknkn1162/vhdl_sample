library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity softmax_with_loss_tb is
end entity;

architecture testbench of softmax_with_loss_tb is
  component softmax_with_loss is
    generic(N: integer);
    port (
      y : in std_logic_vector(N-1 downto 0);
      t : in std_logic;
      a : out std_logic_vector(N downto 0)
    );
  end component;

  constant N : natural := 8;
  signal y : std_logic_vector(N-1 downto 0);
  signal t : std_logic;
  signal a : std_logic_vector(N downto 0);

begin
  uut : softmax_with_loss generic map(N=>N)
  port map (
    y => y, t => t, a => a
  );

  stim_proc : process
  begin
    wait for 20 ns;
    y <= X"09"; t <= '0'; wait for 10 ns; assert a = "0" & X"09";
    y <= X"E6"; t <= '1'; wait for 10 ns; assert a = "1" & X"E7";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
