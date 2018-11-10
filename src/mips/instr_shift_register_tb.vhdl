library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instr_shift_register_tb is
end entity;

architecture testbench of instr_shift_register_tb is
  component instr_shift_register
    port (
      clk, rst, en : in std_logic;
      nxt_opcode, nxt_funct : in std_logic_vector(5 downto 0);
      nxt_rs, nxt_rt, nxt_rd : in std_logic_vector(4 downto 0);
      cur_opcode, cur_funct : out std_logic_vector(5 downto 0);
      cur_rs, cur_rt, cur_rd : out std_logic_vector(4 downto 0)
    );
  end component;

  signal clk, rst, en : std_logic;
  signal nxt_opcode, nxt_funct : std_logic_vector(5 downto 0);
  signal nxt_rs, nxt_rt, nxt_rd : std_logic_vector(4 downto 0);
  signal cur_opcode, cur_funct : std_logic_vector(5 downto 0);
  signal cur_rs, cur_rt, cur_rd : std_logic_vector(4 downto 0);

  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : instr_shift_register port map (
    clk => clk, rst => rst, en => en,
    nxt_opcode => nxt_opcode, nxt_funct => nxt_funct,
    nxt_rs => nxt_rs, nxt_rt => nxt_rt, nxt_rd => nxt_rd,
    cur_opcode => cur_opcode, cur_funct => cur_funct,
    cur_rs => cur_rs, cur_rt => cur_rt, cur_rd => cur_rd
  );

  clk_process: process
  begin
    while not stop loop
      clk <= '0'; wait for clk_period/2;
      clk <= '1'; wait for clk_period/2;
    end loop;
    wait;
  end process;

  stim_proc : process
  begin
    wait for clk_period;
    rst <= '1'; wait for 1 ns; rst <= '0'; en <= '1'; wait for 1 ns;
    -- 0000/00 10/000 1/0000 /1000/1 000/00 10/0000
    nxt_opcode <= "000000"; nxt_funct <= "100000";
    nxt_rs <= "10000"; nxt_rt <= "10000"; nxt_rd <= "10001";
    wait for clk_period/2;
    cur_opcode <= "100000"; cur_funct <= "100000";
    cur_rs <= "10000"; cur_rt <= "10000"; cur_rd <= "10001";
    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
