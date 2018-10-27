library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity relu_tb is
end entity;

architecture testbench of relu_tb is

  component relu
    port (
      sgn : in std_logic;
      a : out std_logic
    );
  end component;
  
  signal sgn, a : std_logic;

begin

  uut : relu port map (
    sgn => sgn, a => a
  );

  stim_proc : process
  begin
    wait for 20 ns;
    sgn <= '1'; wait for 10 ns; assert a = '1';
    sgn <= '0'; wait for 10 ns; assert a = '0';
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
