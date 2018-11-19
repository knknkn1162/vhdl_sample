library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register2_load is
  generic(N: natural);
  port (
    clk, rst : in std_logic;
    en : in std_logic_vector(1 downto 0);
    load0, load1 : in std_logic_vector(N-1 downto 0);
    s : in std_logic;
    b1, b2 : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of shift_register2_load is
  component flopr_en is
    generic(N : natural);
    port (
      clk, rst, en : in std_logic;
      a : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component mux2
    generic(N : integer);
    port (
      d0 : in std_logic_vector(N-1 downto 0);
      d1 : in std_logic_vector(N-1 downto 0);
      s : in std_logic;
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  signal a1 : std_logic_vector(N-1 downto 0);
  signal b10 : std_logic_vector(N-1 downto 0);
begin
  flopr_rt0 : flopr_en generic map(N=>N)
  port map(
    clk => clk, rst => rst, en => en(0),
    a => load0, y => a1
  );

  mux20 : mux2 generic map (N=>N)
  port map(
    d0 => a1,
    d1 => load1,
    s => s,
    y => b10
  );

  b1 <= b10;

  flopr_rt1 : flopr_en generic map(N=>N)
  port map(
    clk => clk, rst => rst, en => en(1),
    a => b10, y => b2
  );
end architecture;
