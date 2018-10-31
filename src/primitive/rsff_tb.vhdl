library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rsff_tb is
end entity;

architecture testbench of rsff_tb is

  component rsff is
    port (
      reset, set : in std_logic;
      q : out std_logic;
      qbar : out std_logic
    );
  end component;

  signal reset, set, q, qbar : std_logic;
begin
  uut : rsff port map (
    reset => reset, set => set, q =>q, qbar => qbar
  );

  stim_proc : process
  begin
    wait for 20 ns;
    set <= '1'; reset <= '0'; wait for 10 ns;
    assert q = '1'; assert qbar = '0';
    set <= '0'; reset <= '1'; wait for 10 ns;
    assert q = '0'; assert qbar = '1';
    set <= '0'; reset <= '0'; wait for 10 ns;
    assert q = '0'; assert qbar = '1';
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;
