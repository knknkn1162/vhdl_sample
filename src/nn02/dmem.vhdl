library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;

entity dmem is
  port (
    a : in std_logic_vector(15 downto 0);
    id : out std_logic_vector(31 downto 0);
    cnt : out std_logic_vector(31 downto 0);
    data : out std_logic_vector(7 downto 0)
  );
end entity;

architecture behavior of dmem is
  constant N : natural := 60000;
  type char_file_type is file of character;
  type ramtype is array(0 to N-1) of std_logic_vector(7 downto 0);
  signal mem : ramtype;
  signal count : std_logic_vector(31 downto 0);

begin
  process is
      file file_in : char_file_type open read_mode is "./assets/train-labels-idx1-ubyte";
      variable char_buf : character;
      variable idx : natural;
  begin
    -- initialization
    for i in 3 downto 0 loop
      read(file_in, char_buf);
      id(i*8+7 downto i*8) <= std_logic_vector(to_unsigned(character'pos(char_buf),8));
    end loop;

    for i in 3 downto 0 loop
      read(file_in, char_buf);
      count(i*8+7 downto i*8) <= std_logic_vector(to_unsigned(character'pos(char_buf),8));
    end loop;

    cnt <= count;

    while not endfile(file_in) loop
      read(file_in, char_buf);
      mem(idx) <= std_logic_vector(to_unsigned(character'pos(char_buf), 8));
      idx := idx+1;
    end loop;
    file_close(file_in);

    loop
      if is_X(a) then
        data <= (others => '-');
      else
        data <= mem(to_integer(unsigned(a)));
      end if;
      wait on a;
    end loop;
  end process;
end architecture;
