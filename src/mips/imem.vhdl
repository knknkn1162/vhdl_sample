library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imem is
  port (
    a : in std_logic_vector(5 downto 0);
    rd : out std_logic_vector(31 downto 0)
     );
end entity;

architecture behavior of imem is
begin
  process is
    file mem_file: TEXT;
    variable L : line;
    variable ch: character;
    variable i, index, result: integer;
    type ramtype is array (63 downto 0) of std_logic_vector(31 downto 0);
    variable mem : ramtype;
  begin
    for i in 0 to 63 loop
      mem(i) := (others => '0');
    end loop;
    index := 0;
    FILE_OPEN(mem_file, "./memfile.dat", READ_MODE);
    while not endfile(mem_file) loop
      readline(mem_file, L);
      result := 0;
      for i in 1 to 8 loop
        read(L, ch);
        if '0' <= ch and ch <= '9' then
          result := character'pos(ch) - character'pos('0');
        elsif 'a' <= ch and ch <= 'f' then
          result := character'pos(ch) - character'pos('a') + 10;
        else report "Format error on line" & integer'
          image(index) severity error;
        end if;
        mem(index)(35-i*4 downto 32-i*4) := std_logic_vector(to_unsigned(result, 4));
      end loop;
    end loop;

    loop
      rd <= mem(to_integer(unsigned(a)));
      wait on a;
    end loop;
  end process;
end architecture;
