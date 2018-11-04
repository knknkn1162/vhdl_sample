library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decode is
  port (
    clk, rst : in std_logic;
    mem_rd : in std_logic_vector(31 downto 0);
    rs, rt : out std_logic_vector(31 downto 0);
    imm : out std_logic_vector(31 downto 0);
    -- controller
    instr_en, reg_we : in std_logic
    
  );
end entity;

architecture behavior of decode is
  component regfile
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

  component flopr_en
    port (
      clk, rst, en: in std_logic;
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;

  signal instr0, wd0 : std_logic_vector(31 downto 0);

begin
  reg_instr : flopr_en port map (
    clk => clk, rst => rst, en => instr_en,
    a => mem_rd,
    y => instr0
  );

  reg_wdata : flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => mem_rd,
    y => wd0
  );

  regfile0 : regfile port map (
    clk => clk, rst => rst,
    a1 => instr0(25 downto 21),
    rd1 => rs,
    a2 => instr0(20 downto 16),
    rd2 => rt,
    a3 => instr0(20 downto 16),
    wd3 => wd0,
    we3 => reg_we
  );

  sgnext0 : sgnext port map (
    a => instr0(15 downto 0),
    y => imm
  );


end architecture;
