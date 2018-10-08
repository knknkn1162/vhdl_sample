library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity maindec is
  port (
    op: in std_logic_vector(5 downto 0);
    memtoreg, memwrite: out std_logic;
    branch, alusrc : out std_logic;
    regdst, regwrite : out std_logic;
    jump : out std_logic;
    aluop : out std_logic_vector(1 downto 0)
       );
end entity;

architecture behavior of maindec is
  signal controls : std_logic_vector(8 downto 0);
  signal a : std_logic_vector(0 downto 0);
  signal b : std_logic_vector(1 downto 0);
begin
  process(op) begin
    case op is
      when "000000" => controls <= "110000010";
      when "100011" => controls <= "101001000";
      when "101011" => controls <= "001010000";
      when "000100" => controls <= "000100001";
      when "001000" => controls <= "101000000";
      when "000010" => controls <= "000000100";
      when others => controls <=   "---------";
    end case;
  end process;

  --(regwrite, aluop(1 downto 0)) <= "000";
  regwrite <= controls(8);
  regdst <= controls(7);
  alusrc <= controls(6);
  branch <= controls(5);
  memwrite <= controls(4);
  memtoreg <= controls(3);
  jump <= controls(2);
  aluop <= controls(1 downto 0);
  --(regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump, aluop(1 downto 0)) <= controls;
end architecture;
