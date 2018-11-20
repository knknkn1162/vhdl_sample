library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calc is
  port (
    clk, rst : in std_logic;
    rds, rdt, immext : in std_logic_vector(31 downto 0);
    target : in std_logic_vector(25 downto 0);
    alures : out std_logic_vector(31 downto 0);
    aluzero : out std_logic;
    brplus : out std_logic_vector(31 downto 0);
    ja : out std_logic_vector(27 downto 0);
    mem_wd : out std_logic_vector(31 downto 0);
    -- controller
    alucont : in std_logic_vector(2 downto 0);
    rdt_immext_s : in std_logic;
    calc_en : in std_logic
  );
end entity;

architecture behavior of calc is
  component flopr_en
    generic(N : natural);
    port (
      clk, rst, en: in std_logic;
      a : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  component alu
    port (
      a, b : in std_logic_vector(31 downto 0);
      f : in std_logic_vector(2 downto 0);
      y : out std_logic_vector(31 downto 0);
      -- if a === b
      zero : out std_logic
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

  component slt2
    generic (N: natural);
    port (
      a : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
    );
  end component;


  signal srca, srcb : std_logic_vector(31 downto 0);
  signal rdt0, immext0 : std_logic_vector(31 downto 0);
  signal ja0 : std_logic_vector(27 downto 0);
  signal target28 : std_logic_vector(27 downto 0);

begin
  reg_rds : flopr_en generic map(N=>32)
  port map (
    clk => clk, rst => rst, en => calc_en,
    a => rds,
    y => srca
  );

  reg_rdt : flopr_en generic map(N=>32)
  port map (
    clk => clk, rst => rst, en => calc_en,
    a => rdt,
    y => rdt0
  );
  mem_wd <= rdt0;

  reg_immext : flopr_en generic map(N=>32)
  port map (
    clk => clk, rst => rst, en => calc_en,
    a => immext,
    y => immext0
  );

  rdt_immext_mux : mux2 generic map (N=>32)
  port map (
    d0 => rdt0,
    d1 => immext0,
    s => rdt_immext_s,
    y => srcb
  );

  immext_slt2 : slt2 generic map(N=>32)
  port map (
    a => immext0,
    y => brplus
  );

  target28 <= b"00" & target;
  target_slt2 : slt2 generic map (N=>28)
  port map (
    a => target28,
    y => ja0
  );
  ja <= ja0;

  alu0 : alu port map (
    a => srca, b => srcb,
    f => alucont,
    y => alures,
    zero => aluzero
  );
end architecture;
