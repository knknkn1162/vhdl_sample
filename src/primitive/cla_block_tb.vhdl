library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_block_tb is
end entity;

architecture testbench of cla_block_tb is
  component cla_block
    generic(N: integer := 4);
    port (
      a, b: in std_logic_vector(N-1 downto 0);
      cin : in std_logic;
      cout : out std_logic
      -- s : out std_logic_vector(N-1 downto 0)
        );
  end component;

  constant n : integer := 4;
  signal a, b: std_logic_vector(N-1 downto 0);
  signal cin : std_logic;
  signal cout : std_logic;

begin
  uut: cla_block port map (
    a, b, cin, cout
  );

  stim_proc: process
  begin
    wait for 10 ns;
    cin <= '0';
    a <= "0010"; b <= "0110"; wait for 10 ns; assert cout = '0';
    a <= "0111"; b <= "0001"; wait for 10 ns; assert cout = '1';
    cin <= '1';
    a <= "0100"; b <= "0001"; wait for 10 ns; assert cout = '0';
    a <= "0110"; b <= "0001"; wait for 10 ns; assert cout = '1';
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;




end architecture;
