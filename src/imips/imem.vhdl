library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imem is
  port (
    addr : in std_logic_vector(7 downto 0);
    rd : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of imem is
  type ramtype is array (63 downto 0) of std_logic_vector(31 downto 0);
  signal mem : ramtype;
  signal is_init : std_logic := '1';
begin
  process(addr) begin
    if is_init='1' then
      -- initialization (write instruction into mem)
      for i in 0 to 63 loop
        mem(i) <= (others => '0');
      end loop;
      -- addi $s0, $0, 5
      -- 8(6bit) 0(5bit) 16(5bit) 5(15bit)
      -- 0010/00  00/000  1/0000/ 0000/0000/0000/0101
      -- "20100005"
      mem(0) <= X"20100005";
    end if;
    is_init <= '0';
    -- read memory
    if Is_X(addr) then
      rd <= (others => '0');
    else
      rd <= mem(to_integer(unsigned(addr)));
    end if;
  end process;
end architecture;