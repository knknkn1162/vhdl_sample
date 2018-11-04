library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
  port (
    clk, rst : in std_logic;
    opcode, funct : in std_logic_vector(5 downto 0);
    -- for memadr
    pc_aluout_s, pc_en : out std_logic;
    -- for memwrite
    mem_we: out std_logic;
    -- for writeback
    instr_en, reg_we : out std_logic;
    -- for memadr
    alucont : out std_logic_vector(2 downto 0);
    rt_imm_s : out std_logic
  );
end entity;

architecture behavior of controller is
begin
end architecture;
