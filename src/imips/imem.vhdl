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
      -- addi $s0, $0, 5
      -- 8(6bit) 0(5bit) 16(5bit) 5(16bit)
      -- 0010/00  00/000  1/0000/ 0000/0000/0000/0101
      -- "20100005"
      mem(0) <= X"20100005";

      -- addi $s1, $s0, 10
      -- 8(6bit) 16(5bit) 17(5bit) 10(16bit)
      -- 0010/00 10/000 1/0001/ 0000/0000/0000/1010
      -- "2211000a"
      mem(1) <= X"2211000a";
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
