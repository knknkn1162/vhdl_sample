library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
  generic(N: natural);
  port (
    clk, rst : in std_logic;
    ena : in std_logic;
    cnt : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of counter is
  component flopr
    generic(N: integer);
    port (
      clk, rst: in std_logic;
      a : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  signal nxt : std_logic_vector(N-1 downto 0);
  signal cnt0 : std_logic_vector(N-1 downto 0);
begin
  flopr0 : flopr generic map (N=>N)
    port map (
      clk => clk, rst => rst,
      a => nxt,
      y => cnt0 -- not cnt as entity counter
  );
  cnt <= cnt0;
  nxt <= std_logic_vector(unsigned(cnt0) + 1) when ena='1' else cnt0;
end architecture;
