library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decode_tb is
end entity;

architecture testbench of decode_tb is
  component decode
    port (
      clk, rst : in std_logic;
      mem_rd : in std_logic_vector(31 downto 0);
      rs, rt, rd, shamt : out std_logic_vector(4 downto 0);
      imm : out std_logic_vector(15 downto 0);
      target : out std_logic_vector(25 downto 0);
      -- controller
      opcode, funct : out std_logic_vector(5 downto 0);
      instr_clr : in std_logic
    );
  end component;

  signal clk, rst : std_logic;
  signal mem_rd : std_logic_vector(31 downto 0);
  signal rs, rt, rd, shamt : std_logic_vector(4 downto 0);
  signal imm : std_logic_vector(15 downto 0);
  signal target : std_logic_vector(25 downto 0);
  signal opcode, funct : std_logic_vector(5 downto 0);
  signal instr_clr : std_logic;
  -- controller
  constant clk_period : time := 10 ns;
  signal stop : boolean;

begin
  uut : decode port map (
    clk => clk, rst => rst,
    mem_rd => mem_rd,
    rs => rs, rt => rt, rd => rd, shamt => shamt,
    imm => imm,
    target => target,
    -- controller
    opcode => opcode, funct => funct,
    instr_clr => instr_clr
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
    -- lw $s0, 1020($0) 1000/11 00/000 1/0000 0x03FC
    -- X"8C1003FC";
    rst <= '1'; wait for 1 ns; rst <= '0';
    -- read
    mem_rd <= X"8C1003FC"; wait for clk_period/2;
    assert rs = "00000"; assert imm = X"03FC"; assert opcode = "100011";
    
    -- j read 0x02
    mem_rd <= X"08000011"; wait for clk_period;
    assert target = b"00" & X"000011";

    -- sll $t2, $s0, 4  0000/00 00/000 1/0000/ 0101/0 001/00 00/0000
    -- X"00105100"
    mem_rd <= X"00105100"; wait for clk_period;
    assert rs = "00000"; assert rt = "10000"; assert rd = "01010"; assert shamt = "00100"; assert opcode = "000000";

    mem_rd <= X"00105101"; instr_clr <= '1'; wait for clk_period;
    assert rs = "00000"; assert rt = "00000"; assert rd = "00000"; assert shamt = "00000"; assert opcode = "000000";

    -- skip
    stop <= TRUE;
    -- success message
    assert false report "end of test" severity note;
    wait;
  end process;
end architecture;
