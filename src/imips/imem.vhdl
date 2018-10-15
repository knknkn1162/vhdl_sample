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
      -- add $t0, $s0, $s1
      -- 0x00(6bit) 16(5bit) 17(5bit), 8(5bit), 0(5bit), 0x20(6bit)
      -- 0000/00 10/000 1/0001 /0100/0 000/00 10/0000
      mem(0) <= X"02114020";

      -- sub $t1, $s0, $s1
      -- 0x00(6bit) 16(5bit) 17(5bit), 9(5bit), 0(5bit), 0x22(6bit)
      -- 0000/00 10/000 1/0001 /0100/1 000/00 10/0010
      mem(1) <= X"02114822";

      -- or $t2, $s0, $s1
      -- 0x00(6bit) 16(5bit) 17(5bit), 10(5bit), 0(5bit), 0x25(6bit)
      -- 0000/00 10/000 1/0001 /0101/0 000/00 10/0101
      mem(2) <= X"02114025";

      -- and $t3, $s0, $s1
      -- 0x00(6bit) 16(5bit) 17(5bit), 11(5bit), 0(5bit), 0x24(6bit)
      -- 0000/00 10/000 1/0001/ 0101/1 000/00 10/0100
      mem(3) <= X"02115824";

      -- sll $t4, $s0, 4
      -- 0x00(6bit) 0(5bit) 16(5bit), 12(5bit), 4(5bit), 0x00(6bit)
      -- 0000/00 00/000 1/0000 /0110/0 001/00 00/0000
      mem(4) <= X"00106100";
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
