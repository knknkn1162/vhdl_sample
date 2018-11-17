library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regrw2 is
  generic(regfile : string := "./assets/reg/dummy.hex");
  port (
    clk, rst, load : in std_logic;
    rs, rt, rd : in std_logic_vector(4 downto 0);
    mem_rd : in std_logic_vector(31 downto 0);
    aluout : in std_logic_vector(31 downto 0);
    imm : in std_logic_vector(15 downto 0);

    rds, rdt, immext : out std_logic_vector(31 downto 0);
    -- forwarding for pipeline
    aluforward : in std_logic_vector(31 downto 0);
    -- from controller
    wa : in std_logic_vector(4 downto 0);
    wd : in std_logic_vector(31 downto 0);
    we : in std_logic;
    cached_rds, cached_rdt : in std_logic_vector(31 downto 0);

    -- -- forwarding for pipeline
    rd1_aluforward_memrd_s, rd2_aluforward_memrd_s : in std_logic_vector(1 downto 0)
  );
end entity;

architecture behavior of regrw2 is
  component reg
    generic(filename : string);
    port (
      clk, rst, load : in std_logic;
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

  component shift_register2
    generic(N: natural);
    port (
      clk, rst, en : in std_logic;
      a0 : in std_logic_vector(N-1 downto 0);
      a1 : out std_logic_vector(N-1 downto 0);
      a2 : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component flopr_en
    generic(N : natural := 32);
    port (
      clk, rst, en: in std_logic;
      a : in std_logic_vector(N-1 downto 0);
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

  signal rd1, rd2 : std_logic_vector(31 downto 0);

begin
  reg0 : reg generic map(filename=>regfile)
  port map (
    clk => clk, rst => rst, load => load,
    a1 => rs, rd1 => rd1,
    a2 => rt, rd2 => rd2,
    a3 => wa, wd3 => wd, we3 => we
  );

  rd1_aluforward_memrd_mux : mux4 generic map(N=>32)
  port map (
    d00 => rd1,
    d01 => aluforward,
    d10 => cached_rds, -- from memrw
    d11 => rd1, -- dummy
    s => rd1_aluforward_memrd_s,
    y => rds
  );

  rd2_aluforward_memrd_mux : mux4 generic map(N=>32)
  port map (
    d00 => rd2,
    d01 => aluforward,
    d10 => cached_rdt, -- from memrw
    d11 => rd2, -- dummy
    s => rd2_aluforward_memrd_s,
    y => rdt
  );

  sgnext0 : sgnext port map (
    a => imm,
    y => immext
  );
end architecture;
