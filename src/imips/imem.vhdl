library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imem is
  port (
    -- pc(7 downto 2)
    idx : in std_logic_vector(5 downto 0);
    rd : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of imem is
  constant N : integer := 6;
  type ramtype is array (2**N-1 downto 0) of std_logic_vector(31 downto 0);
  signal mem : ramtype;
  signal is_init : std_logic := '1';
begin
  process(idx) begin
    if is_init='1' then
      -- initialization (write instruction into mem)
      for i in 0 to 63 loop
        mem(i) <= (others => '0');
      end loop;
      -- lw $s0, 64($0)
      -- 0x23(6bit) 0(5bit) 16(5bit) 64(16bit)
      -- 1000/11  00/000  1/0000/ 0000/0000/0100/0000
      -- "8c100040"
      mem(0) <= X"8c100040";

      -- sw $s0, 60($0)
      -- 0x2B(6bit) 0(5bit) 16(5bit) 60(16bit)
      -- 1010/11 00/000 1/0000/ 0000/0000/0011/1100
      -- "ac10003c"
      mem(1) <= X"ac10003c";
    end if;
    is_init <= '0';
    -- read memory
    if Is_X(idx) then
      rd <= (others => '0');
    else
      rd <= mem(to_integer(unsigned(idx)));
    end if;
  end process;
end architecture;
