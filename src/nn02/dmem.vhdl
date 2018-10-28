library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package dmem_const_pkg is
  constant IMAGE_SIZE : natural := 28;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.dmem_const_pkg.ALL;
use work.nn_pkg.ALL;

entity dmem is
  port (
    a : in std_logic_vector(15 downto 0);
    id : out std_logic_vector(31 downto 0);
    cnt : out std_logic_vector(31 downto 0);
    -- image
    --x : out arr_type(0 to IMAGE_SIZE*IMAGE_SIZE-1);
    -- [0, 9)
    t : out std_logic_vector(3 downto 0)
  );
end entity;

architecture behavior of dmem is
  constant N : natural := 60000;
  type char_file_type is file of character;
  type labeltype is array(0 to N-1) of std_logic_vector(3 downto 0);
  -- type imgtype is array(0 to N-1) of std_logic_vector(SIZE*IMAGE_SIZE*IMAGE_SIZE - 1 downto 0);
  signal label_mem : labeltype;
  --signal data_mem : imgtype;

begin
  process is
      file label_file_in : char_file_type open read_mode is "./assets/train-labels-idx1-ubyte";
      --file image_file_in : char_file_type open read_mode is "./assets/train-images-idx3-ubyte";
      variable char_buf : character;
      variable idx : natural;
  begin
    -- initialization
    for i in 3 downto 0 loop
      read(label_file_in, char_buf);
      id(i*8+7 downto i*8) <= std_logic_vector(to_unsigned(character'pos(char_buf),8));
    end loop;

    for i in 3 downto 0 loop
      read(label_file_in, char_buf);
      cnt(i*8+7 downto i*8) <= std_logic_vector(to_unsigned(character'pos(char_buf),8));
    end loop;

    idx := 0;
    while not endfile(label_file_in) loop
      read(label_file_in, char_buf);
      label_mem(idx) <= std_logic_vector(to_unsigned(character'pos(char_buf), 4));
      idx := idx + 1;
    end loop;
    file_close(label_file_in);

    loop
      if is_X(a) then
        --x <= (others => (others => '-'));
        t <= (others => '-');
      else
        t <= label_mem(to_integer(unsigned(a)));
      end if;
      wait on a;
    end loop;
  end process;
end architecture;
