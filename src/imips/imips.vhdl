library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imips is
  port (
    clk, reset : in std_logic;
    addr : in std_logic_vector(31 downto 0);
    -- for testbench
    pc : out std_logic_vector(31 downto 0);
    instr : out std_logic_vector(31 downto 0);
    rs : out std_logic_vector(31 downto 0);
    rt : out std_logic_vector(31 downto 0);
    pcnext : out std_logic_vector(31 downto 0);
    zero : out std_logic
       );
end entity;

architecture behavior of imips is
  component mux2
    port (
      d0 : in std_logic_vector(31 downto 0);
      d1 : in std_logic_vector(31 downto 0);
      s : in std_logic;
      y : out std_logic_vector(31 downto 0)
        );
  end component;
  component flopr
    port (
      clk, reset: in std_logic;
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;

  component imem
    port (
      idx : in std_logic_vector(5 downto 0);
      rd : out std_logic_vector(31 downto 0)
    );
  end component;

  component regfile
    port (
      clk : in std_logic;
      -- 25:21(read)
      a1 : in std_logic_vector(4 downto 0);
      rd1 : out std_logic_vector(31 downto 0);
      -- 20:16(read)
      a2 : in std_logic_vector(4 downto 0);
      rd2 : out std_logic_vector(31 downto 0);
      -- 20:16(write)
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

  component slt2
    port (
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
    );
  end component;

  component alu
    port (
      a, b : in std_logic_vector(31 downto 0);
      f : in std_logic_vector(2 downto 0);
      y : out std_logic_vector(31 downto 0);
      sgn : out std_logic;
      zero : out std_logic
        );
  end component;
  signal instr0, rs0, rt0, pcnext0, immext : std_logic_vector(31 downto 0);
  signal pc0 : std_logic_vector(31 downto 0); -- buffer
  signal pcplus : std_logic_vector(31 downto 0);
  signal pcjump : std_logic_vector(31 downto 0);
  signal pcn : std_logic_vector(31 downto 0);
  signal zero0 : std_logic;

begin
  mux2_pc : mux2 port map (
    d0 => pcn,
    d1 => pcjump,
    s => zero0,
    y => pcnext0
  );

  pcreg: flopr port map(clk, reset, pcnext0, pc0);

  pcn <= std_logic_vector(unsigned(pc0) + 4);

  pc <= pc0;
  pcnext <= pcnext0;

  imem0: imem port map (
    -- Each size of the instruction is 4 byte.
    idx => pc0(7 downto 2),
    rd => instr0
  );
  instr <= instr0;

  reg0 : regfile port map (
    clk => clk,
    a1 => instr0(25 downto 21),
    rd1 => rs0,
    a2 => instr0(20 downto 16),
    rd2 => rt0,
    -- a3, wd3 is not used
    a3 => instr0(20 downto 16),
    wd3 => (others => '0'),
    we3 => '0'
  );
  rs <= rs0;
  rt <= rt0;

  sgnext0 : sgnext port map (
    a => instr0(15 downto 0),
    y => immext
  );

  slt2_0 : slt2 port map (
    a => immext,
    y => pcplus
  );

  pcjump <= std_logic_vector(unsigned(pcplus) + unsigned(pcn));

  alu0: alu port map (
    a => rs0,
    b => rt0,
    f => "---", -- not specified
    -- y => res, -- not used
    -- sgn => sgn, -- not used
    zero => zero0
  );
  zero <= zero0;

end architecture;
