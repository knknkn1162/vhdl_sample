library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fetch_memrw is
  port (
    clk, rst: in std_logic;
    addr : in std_logic_vector(31 downto 0);
    wd : in std_logic_vector(31 downto 0);
    rd : out std_logic_vector(31 downto 0);
    -- controller
    we : in std_logic
  );
end entity;

architecture behavior of fetch_memrw is
  component mem
    port (
      clk, rst : in std_logic;
      we : in std_logic;
      -- program counter is 4-byte aligned
      a : in std_logic_vector(29 downto 0);
      wd : in std_logic_vector(31 downto 0);
      rd : out std_logic_vector(31 downto 0)
    );
  end component;

begin
  mem0 : mem port map (
    clk => clk, rst => rst,
    we => we,
    a => addr(31 downto 2),
    wd => wd,
    rd => rd
  );
end architecture;
