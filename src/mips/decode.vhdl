library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decode is
  port (
    clk, rst : in std_logic;
    mem_rd : in std_logic_vector(31 downto 0);
    rs, rt : out std_logic_vector(4 downto 0);
    imm : out std_logic_vector(15 downto 0);
    wd : out std_logic_vector(31 downto 0);
    -- controller
    opcode, funct : out std_logic_vector(5 downto 0);
    instr_en : in std_logic
  );
end entity;

architecture behavior of decode is
  component flopr_en
    port (
      clk, rst, en: in std_logic;
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;

  signal instr0 : std_logic_vector(31 downto 0);
begin
  reg_instr : flopr_en port map (
    clk => clk, rst => rst, en => instr_en,
    a => mem_rd,
    y => instr0
  );
  -- for controller
  opcode <= instr0(31 downto 26);
  rs <= instr0(25 downto 21);
  rt <= instr0(20 downto 16);
  imm <= instr0(15 downto 0);
  funct <= instr0(5 downto 0);

  reg_wdata : flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => mem_rd,
    y => wd
  );
end architecture;
