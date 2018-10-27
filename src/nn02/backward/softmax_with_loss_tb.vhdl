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
      y : in arr_type(0 to N-1);
      t : in std_logic_vector(N-1 downto 0);
      a : out arr1_type(0 to N-1)
    );
  end component;

  constant N : natural := 4;
  signal y : arr_type(0 to N-1);
  signal t : std_logic_vector(N-1 downto 0);
  signal a : arr1_type(0 to N-1);
  signal a0 : std_logic_vector(SIZE downto 0);

begin
  uut : softmax_with_loss generic map(N=>N)
  port map (
    y => y, t => t, a => a
  );

  stim_proc : process
  begin
    wait for 20 ns;
    y <= (X"09", X"04", X"E6", X"04"); t <= "0100"; wait for 10 ns;
    assert a = ("0" & X"09", "0" & X"04", "1" & X"E7", "0" & X"04");
    t <= "0010"; wait for 10 ns;
    assert a = ("0" & X"09", "1" & X"05", "0" & X"E6", "0" & X"04");
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
