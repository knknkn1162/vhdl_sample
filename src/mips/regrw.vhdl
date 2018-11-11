library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regrw is
  port (
    clk, rst : in std_logic;
    rs, rt, rd : in std_logic_vector(4 downto 0);
    mem_rd : in std_logic_vector(31 downto 0);
    aluout : in std_logic_vector(31 downto 0);
    imm : in std_logic_vector(15 downto 0);

    rds, rdt, immext : out std_logic_vector(31 downto 0);
    -- forwarding for pipeline
    aluforward : in std_logic_vector(31 downto 0);
    -- controller
    we : in std_logic;
    memrd_aluout_s : in std_logic;
    rt_rd_s : in std_logic;
    -- forwarding for pipeline
    rd1_aluforward_s : in std_logic;
    rd2_aluforward_s : in std_logic;
    -- scan
    wa : out std_logic_vector(4 downto 0);
    wd : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of regrw is
  component reg
    port (
      clk, rst : in std_logic;
      -- 25:21(read)
      a1 : in std_logic_vector(4 downto 0);
      rd1 : out std_logic_vector(31 downto 0);
      -- 20:16(read)
      a2 : in std_logic_vector(4 downto 0);
      rd2 : out std_logic_vector(31 downto 0);

      a3 : in std_logic_vector(4 downto 0);
      wd3 : in std_logic_vector(31 downto 0);
      we3 : in std_logic
    );
  end component;

  component sgnext
    port (
      a : in std_logic_vector(15 downto 0);
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

  signal wa0 : std_logic_vector(4 downto 0);
  signal wd0 : std_logic_vector(31 downto 0);
  signal rd1, rd2 : std_logic_vector(31 downto 0);

begin
  memrd_aluout_mux : mux2 generic map(N=>32)
  port map (
    d0 => mem_rd,
    d1 => aluout,
    s => memrd_aluout_s,
    y => wd0
  );

  rt_rd_mux : mux2 generic map (N=>5)
  port map (
    d0 => rt,
    d1 => rd,
    s => rt_rd_s,
    y => wa0
  );

  reg0 : reg port map (
    clk => clk, rst => rst,
    a1 => rs, rd1 => rd1,
    a2 => rt, rd2 => rd2,
    a3 => wa0, wd3 => wd0, we3 => we
  );
  wa <= wa0; wd <= wd0;

  rd1_aluforward_mux : mux2 generic map(N=>32)
  port map (
    d0 => rd1,
    d1 => aluforward,
    s => rd1_aluforward_s,
    y => rds
  );

  rd2_aluforward_mux : mux2 generic map (N=>32)
  port map (
    d0 => rd2,
    d1 => aluforward,
    s => rd2_aluforward_s,
    y => rdt
  );


  sgnext0 : sgnext port map (
    a => imm,
    y => immext
  );
end architecture;
