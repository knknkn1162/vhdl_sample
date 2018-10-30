library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

entity two_layer_tb is
end entity;

architecture testbench of two_layer_tb is
  component two_layer
    generic(INPUT_SIZE: natural; HIDDEN_SIZE: natural; OUTPUT_SIZE: natural);
    port (
      x : in arr_type(0 to INPUT_SIZE-1);
      -- 6bit
      w1 : in warr_type(0 to INPUT_SIZE*HIDDEN_SIZE-1);
      w2 : in warr_type(0 to HIDDEN_SIZE*OUTPUT_SIZE-1);
      z : out arr_type(0 to OUTPUT_SIZE-1)
    );
  end component;

  constant INPUT_SIZE : natural := 6;
  constant HIDDEN_SIZE : natural := 4;
  constant OUTPUT_SIZE : natural := 3;
  signal x : arr_type(0 to INPUT_SIZE-1);
  signal w1 : warr_type(0 to INPUT_SIZE*HIDDEN_SIZE-1);
  signal w2 : warr_type(0 to HIDDEN_SIZE*OUTPUT_SIZE-1);
  signal z : arr_type(0 to OUTPUT_SIZE-1);

begin

  uut : two_layer generic map (INPUT_SIZE=>INPUT_SIZE, HIDDEN_SIZE=>HIDDEN_SIZE, OUTPUT_SIZE=>OUTPUT_SIZE)
  port map (
    x => x,
    w1 => w1,
    w2 => w2,
    z => z
  );

  stim_proc : process
  begin
    wait for 20 ns;
    x <= (X"01", X"02", X"03", X"04", X"05", X"06");
    w1 <= (others => (others => '0'));
    w2 <= (others => (others => '0'));
    wait for 10 ns;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
