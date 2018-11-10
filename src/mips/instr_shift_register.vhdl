library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instr_shift_register is
  port (
    clk, rst, en : in std_logic;
    nxt_opcode, nxt_funct : in std_logic_vector(5 downto 0);
    nxt_rs, nxt_rt, nxt_rd : in std_logic_vector(4 downto 0);
    cur_opcode, cur_funct : out std_logic_vector(5 downto 0);
    cur_rs, cur_rt, cur_rd : out std_logic_vector(4 downto 0)
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
  signal nxt : std_logic_vector(N-1 downto 0);
  signal cur : std_logic_vector(N-1 downto 0);
begin
  nxt <= nxt_opcode & nxt_rs & nxt_rt & nxt_rd & nxt_funct;

  flopr_en0 : flopr_en generic map(N=>N)
  port map (
    clk => clk, rst => rst, en => en,
    a => nxt, y => cur
  );

  cur_opcode <= cur(26 downto 21);
  cur_rs <= cur(20 downto 16);
  cur_rt <= cur(15 downto 11);
  cur_rd <= cur(10 downto 6);
  cur_funct <= cur(5 downto 0);
end architecture;
