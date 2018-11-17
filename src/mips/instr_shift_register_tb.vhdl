library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instr_shift_register_tb is
end entity;

architecture testbench of instr_shift_register_tb is
  component instr_shift_register is
    port (
      clk, rst : in std_logic;
      en : in std_logic_vector(1 downto 0);
      opcode0, funct0 : in std_logic_vector(5 downto 0);
      rs0, rt0, rd0 : in std_logic_vector(4 downto 0);
      opcode1, funct1 : out std_logic_vector(5 downto 0);
      rs1, rt1, rd1 : out std_logic_vector(4 downto 0);
      opcode2, funct2 : out std_logic_vector(5 downto 0);
      rs2, rt2, rd2 : out std_logic_vector(4 downto 0)
    );
  end component;

  signal clk, rst : std_logic;
  signal en :  std_logic_vector(1 downto 0);
  signal opcode0, funct0 : std_logic_vector(5 downto 0);
  signal rs0, rt0, rd0 : std_logic_vector(4 downto 0);
  signal opcode1, funct1 : std_logic_vector(5 downto 0);
  signal rs1, rt1, rd1 : std_logic_vector(4 downto 0);
  signal opcode2, funct2 : std_logic_vector(5 downto 0);
  signal rs2, rt2, rd2 : std_logic_vector(4 downto 0);

  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : instr_shift_register port map (
    clk => clk, rst => rst, en => en,
    opcode0 => opcode0, funct0 => funct0,
    rs0 => rs0, rt0 => rt0, rd0 => rd0,
    opcode1 => opcode1, funct1 => funct1,
    rs1 => rs1, rt1 => rt1, rd1 => rd1,
    opcode2 => opcode2, funct2 => funct2,
    rs2 => rs2, rt2 => rt2, rd2 => rd2
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
    rst <= '1'; wait for 1 ns; rst <= '0'; en <= "11"; wait for 1 ns;
    -- 0000/00 10/000 1/0000 /1000/1 000/00 10/0000
    opcode0 <= "000000"; funct0 <= "100000";
    rs0 <= "10000"; rt0 <= "10000"; rd0 <= "10001";
    wait for clk_period/2;
    assert opcode1 = "000000"; assert funct1 = "100000";
    assert rs1 = "10000"; assert rt1 = "10000"; assert rd1 = "10001";
    wait for clk_period;
    assert opcode2 = "000000"; assert funct2 = "100000";
    assert rs2 = "10000"; assert rt2 = "10000"; assert rd2 = "10001";

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
