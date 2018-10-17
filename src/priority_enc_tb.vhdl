library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity priority_enc_tb is
end entity;

architecture behavior of priority_enc_tb is
  component priority_enc
    generic(N: integer := 8);
    port (
      x : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(3 downto 0)
    );
  end component;

  constant N : integer := 8;
  signal x : std_logic_vector(N-1 downto 0);
  signal y : std_logic_vector(3 downto 0);

begin
  uut : priority_enc port map (
    x => x, y => y
  );

  stim_proc : process
  begin
    wait for 20 ns;
    x <= "00000000"; wait for 5 ns; y <= "0000";
    x <= "00000001"; wait for 5 ns; y <= "0001";
    x <= "00000010"; wait for 5 ns; y <= "0010";
    x <= "00000011"; wait for 5 ns; y <= "0010";
    x <= "00000100"; wait for 5 ns; y <= "0011";
    x <= "10000000"; wait for 5 ns; y <= "1000";
    x <= "10000100"; wait for 5 ns; y <= "1000";
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
