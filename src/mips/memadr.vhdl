library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memadr is
  port (
    clk, rst : in std_logic;
    alures : in std_logic_vector(31 downto 0);
    ja : in std_logic_vector(27 downto 0);
    brplus : in std_logic_vector(31 downto 0);
    addr : out std_logic_vector(31 downto 0);
    reg_aluout : out std_logic_vector(31 downto 0);
    -- controller
    pc_aluout_s : in std_logic;
    pc4_br4_ja_s : in std_logic_vector(1 downto 0);
    pc_en : in std_logic;
    instr_clr : in std_logic;
    rw_en : in std_logic;
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

  component mux4
    generic(N : natural);
    port (
      d00 : in std_logic_vector(N-1 downto 0);
      d01 : in std_logic_vector(N-1 downto 0);
      d10 : in std_logic_vector(N-1 downto 0);
      d11 : in std_logic_vector(N-1 downto 0);
      s : in std_logic_vector(1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
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

  signal pc0, pcprev0, pcnext0, aluout : std_logic_vector(31 downto 0);
  signal pc4plus, br4plus, ja32 : std_logic_vector(31 downto 0);
  signal en : std_logic_vector(1 downto 0);
begin

  en <= (not instr_clr) & pc_en;
  shift_register2_pc : shift_register2 generic map (N=>32)
  port map (
    clk => clk, rst => rst, en => en,
    a0 => pcnext0,
    a1 => pc0,
    a2 => pcprev0
  );
  pc <= pc0;

  flopr_aluout : flopr_en port map (
    clk => clk, rst => rst, en => rw_en,
    a => alures, y => aluout
  );
  reg_aluout <= aluout;

  br4plus <= std_logic_vector(unsigned(brplus) + unsigned(pcprev0) + 4);
  pc4plus <= std_logic_vector(unsigned(pc0) + 4);
  ja32 <= pcprev0(31 downto 28) & ja;

  pc4_br_mux4 : mux4 generic map (N=>32)
  port map (
    d00 => pc4plus,
    d01 => br4plus,
    d10 => ja32,
    d11 => pc4plus, -- dummy
    s => pc4_br4_ja_s,
    y => pcnext0
  );
  pcnext <= pcnext0;

  pc_aluout_mux : mux2 generic map (N=>32)
  port map (
    d0 => pc0,
    d1 => aluout,
    s => pc_aluout_s,
    y => addr
  );
end architecture;
