library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memadr is
  port (
    clk, rst : in std_logic;
    rs, rt, imm : in std_logic_vector(31 downto 0);
    alures : out std_logic_vector(31 downto 0);
    zero : out std_logic;
    -- controller
    alucont : in std_logic_vector(2 downto 0);
    rt_imm_s : in std_logic
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

  signal srca, srcb : std_logic_vector(31 downto 0);
  signal rt0 : std_logic_vector(31 downto 0);

begin
  reg_rs : flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => rs,
    y => srca
  );

  reg_rt : flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => rt,
    y => rt0
  );

  rt_imm_mux : mux2 generic map (N=>32)
  port map (
    d0 => rt0,
    d1 => imm,
    s => rt_imm_s,
    y => srcb
  );

  alu0 : alu port map (
    a => srca, b => srcb,
    f => alucont,
    y => alures,
    zero => zero
  );
end architecture;
