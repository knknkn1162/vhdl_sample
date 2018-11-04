library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fetch_memrw is
  port (
    clk, rst: in std_logic;
    aluout : in std_logic_vector(31 downto 0);
    mem_wd : in std_logic_vector(31 downto 0);
    mem_rd : out std_logic_vector(31 downto 0);
    -- controller
    pc_aluout_s, mem_we : in std_logic;
    -- scan
    mem_addr, pcnext : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of fetch_memrw is
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

  signal pc0, mem_addr0 : std_logic_vector(31 downto 0);
  signal pcnext0 : std_logic_vector(31 downto 0);

begin
  reg_pc: flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => pcnext0,
    y => pc0
  );

  pcnext0 <= std_logic_vector(unsigned(pc0) + 4);
  pcnext <= pcnext0;

  pc_alu_mux : mux2 generic map (N=>32)
  port map (
    d0 => pc0,
    d1 => aluout,
    s => pc_aluout_s,
    y => mem_addr0
  );
  mem_addr <= mem_addr0;

  mem0 : mem port map (
    clk => clk, rst => rst,
    we => mem_we,
    a => mem_addr0(31 downto 2),
    wd => mem_wd,
    rd => mem_rd
  );
end architecture;
