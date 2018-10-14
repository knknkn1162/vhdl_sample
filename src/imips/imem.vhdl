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
      -- beq $s1, $s2, 25
      -- 0x04(6bit) 17(5bit) 18(5bit) 25(16bit)
      -- 0001/00 10/001 1/0010 /0000/0000/0001/1001
      mem(0) <= X"12320019";
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
