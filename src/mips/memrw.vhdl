library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memrw is
  generic(memfile : string);
  port (
    clk, rst, load: in std_logic;
    addr : in std_logic_vector(31 downto 0);
    wd : in std_logic_vector(31 downto 0);
    rd : out std_logic_vector(31 downto 0);
    -- controller
    we : in std_logic
  );
end entity;

architecture behavior of memrw is
  component mem
    generic(filename : string);
    port (
      clk, rst, load : in std_logic;
      we : in std_logic;
      -- program counter is 4-byte aligned
      a : in std_logic_vector(29 downto 0);
      wd : in std_logic_vector(31 downto 0);
      rd : out std_logic_vector(31 downto 0)
    );
  end component;

  component shift_register2
    generic(N: natural);
    port (
      clk, rst : in std_logic;
      en : in std_logic_vector(1 downto 0);
      a0 : in std_logic_vector(N-1 downto 0);
      a1 : out std_logic_vector(N-1 downto 0);
      a2 : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal wd1_dummy, wd2 : std_logic_vector(31 downto 0);

begin
  -- wait for DecodeS and CalcS
  reg_memwd0 : shift_register2 generic map(N=>32)
  port map (
    clk => clk, rst => rst,
    en => "11",
    a0 => wd,
    a1 => wd1_dummy,
    a2 => wd2
  );

  mem0 : mem generic map (filename=>memfile)
  port map (
    clk => clk, rst => rst, load => load,
    we => we,
    a => addr(31 downto 2),
    wd => wd2,
    rd => rd
  );
end architecture;
