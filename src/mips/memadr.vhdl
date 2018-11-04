library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memadr is
  port (
    clk, rst : in std_logic;
    alures : in std_logic_vector(31 downto 0);
    pc_aluout_s : in std_logic;
    addr : out std_logic_vector(31 downto 0);
    -- scan
    pc : out std_logic_vector(31 downto 0);
    pcnext : out std_logic_vector(31 downto 0)

  );
end entity;


architecture behavior of memadr is
  component flopr_en
    port (
      clk, rst, en: in std_logic;
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
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
  signal pc0, pcnext0, aluout : std_logic_vector(31 downto 0);
begin

  reg_pc : flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => pcnext0,
    y => pc0
  );
  pc <= pc0;

  reg_aluout : flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => alures, y => aluout
  );
  pcnext0 <= std_logic_vector(unsigned(pc0) + 4);
  pcnext <= pcnext0;

  pc_aluout_mux : mux2 generic map (N=>32)
  port map (
    d0 => pc0,
    d1 => aluout,
    s => pc_aluout_s,
    y => addr
  );
end architecture;
