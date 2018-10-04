LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity when_else_tb is
end when_else_tb;

architecture behavior of when_else_tb is
  component when_else
    port (
      A : in std_logic;
      B : in std_logic;
      C : in std_logic;
      assign_A : in std_logic;
      assign_B : in std_logic;
      Z : out std_logic
    );
  end component;

  signal A : std_logic := '0';
  signal B : std_logic := '0';
  signal C : std_logic := '0';
  signal assign_A : std_logic := '0';
  signal assign_B : std_logic := '0';

  signal Z : std_logic;

begin
  uut: when_else port map (
    A => A,
    B => B,
    C => C,
    assign_A => assign_A,
    assign_B => assign_B,
    Z => Z
  );

  stim_proc: process
  begin
    wait for 100 ns;
    -- fix
    A<= '1'; B<= '0'; C<='1';
    -- assign_A, assign_B changes
    assign_A<='0'; assign_B<='1';
    wait for 10 ns;
    assign_A<='1'; assign_B<='0';
    wait for 10 ns;
    assign_A<='0'; assign_B<='0';
    wait;
  end process;
end;
