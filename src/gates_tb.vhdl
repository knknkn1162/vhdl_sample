library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity gates_tb is
end gates_tb;


architecture behavior of gates_tb is

  component gates is
    port (
      a, b: in std_logic_vector(3 downto 0);
      y1, y2, y3, y4, y5: out std_logic_vector(3 downto 0)
         );
  end component;


  signal a: std_logic_vector(3 downto 0);
  signal b: std_logic_vector(3 downto 0);
  signal y1: std_logic_vector(3 downto 0);
  signal y2: std_logic_vector(3 downto 0);
  signal y3: std_logic_vector(3 downto 0);
  signal y4: std_logic_vector(3 downto 0);
  signal y5: std_logic_vector(3 downto 0);

begin
  uut: gates port map (
    a => a,
    b => b,
    y1 => y1,
    y2 => y2,
    y3 => y3,
    y4 => y4,
    y5 => y5
  );


  stim_proc: process
  begin
    wait for 20 ns;
    a <= "0101"; b <= "0110"; wait for 10 ns;
    assert y1 = "0100"; assert y2 = "0111"; assert y3 = "0011"; assert y4 = "1011"; assert y5 = "1000";
    wait;
  end process;
end;
