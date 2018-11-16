library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instr_shift_register is
  port (
    clk, rst, en : in std_logic;
    opcode0, funct0 : in std_logic_vector(5 downto 0);
    rs0, rt0, rd0 : in std_logic_vector(4 downto 0);
    opcode1, funct1 : out std_logic_vector(5 downto 0);
    rs1, rt1, rd1 : out std_logic_vector(4 downto 0);
    opcode2, funct2 : out std_logic_vector(5 downto 0);
    rs2, rt2, rd2 : out std_logic_vector(4 downto 0)
  );
end entity;

architecture behavior of instr_shift_register is
  component flopr_en
    generic(N : natural := 32);
    port (
      clk, rst, en: in std_logic;
      a : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  -- opcode, rs, rt, rd, funct

  -- 5*3+6*2=27
  constant N : natural := 27;
  signal x0 : std_logic_vector(N-1 downto 0);
  signal x1 : std_logic_vector(N-1 downto 0);
  signal x2 : std_logic_vector(N-1 downto 0);
begin
  x0 <= opcode0 & rs0 & rt0 & rd0 & funct0;

  flopr_en0 : flopr_en generic map(N=>N)
  port map (
    clk => clk, rst => rst, en => en,
    a => x0, y => x1
  );

  flopr_en1 : flopr_en generic map(N=>N)
  port map (
    clk => clk, rst => rst, en => en,
    a => x1, y => x2
  );

  opcode1 <= x1(26 downto 21); rs1 <= x1(20 downto 16); rt1 <= x1(15 downto 11); rd1 <= x1(10 downto 6); funct1 <= x1(5 downto 0);
  opcode2 <= x2(26 downto 21); rs2 <= x2(20 downto 16); rt2 <= x2(15 downto 11); rd2 <= x2(10 downto 6); funct2 <= x2(5 downto 0);

end architecture;
