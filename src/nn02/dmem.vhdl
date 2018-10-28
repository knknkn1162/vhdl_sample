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
  generic(BATCH_SIZE: natural);
  port (
    a : in std_logic_vector(15 downto 0);
    -- [0, 60000)
    offset : in std_logic_vector(15 downto 0);
    -- image
    x : out arr_type(0 to IMAGE_SIZE*IMAGE_SIZE-1);
    -- [0, 9)
    t : out std_logic_vector(3 downto 0)
  );
end entity;

architecture behavior of dmem is
  constant N : natural := BATCH_SIZE;
  type char_file_type is file of character;
  type labeltype is array(0 to N-1) of std_logic_vector(3 downto 0);
  subtype imgtype is arr_type(0 to N*IMAGE_SIZE*IMAGE_SIZE-1);
  signal label_mem : labeltype;
  signal image_mem : imgtype;

begin
  process(offset)
    file label_file_in : char_file_type; -- open read_mode is "./assets/train-labels-idx1-ubyte";
    file image_file_in : char_file_type; -- open read_mode is "./assets/train-images-idx3-ubyte";
    variable char_buf : character;
    variable idx : natural;
  begin
    if not is_X(offset) then

      file_open(label_file_in, "./assets/train-labels-idx1-ubyte", READ_MODE);
      file_open(image_file_in, "./assets/train-images-idx3-ubyte", READ_MODE);
      -- initialization
      for i in 7 downto 0 loop
        -- trash
        read(label_file_in, char_buf);
      end loop;

      for i in 15 downto 0 loop
        -- trash
        read(image_file_in, char_buf);
      end loop;


      idx := to_integer(unsigned(offset));
      for i in 0 to idx-1 loop
        read(label_file_in, char_buf);
        for j in 0 to IMAGE_SIZE*IMAGE_SIZE-1 loop
          read(image_file_in, char_buf);
        end loop;
      end loop;
      for i in 0 to N-1 loop
        read(label_file_in, char_buf);
        label_mem(i) <= std_logic_vector(to_unsigned(character'pos(char_buf), 4));
      end loop;

      idx := 0;
      for i in 0 to N-1 loop
        for j in IMAGE_SIZE*IMAGE_SIZE-1 downto 0 loop
          read(image_file_in, char_buf);
          image_mem(i) <= std_logic_vector(to_unsigned(character'pos(char_buf), 8));
          idx := idx + 1;
        end loop;
      end loop;
      file_close(label_file_in);
      file_close(image_file_in);
    end if;
  end process;

  process(a)
    variable idx : natural;
  begin
    if not is_X(offset) then
      idx := to_integer(unsigned(a)-unsigned(offset));
      if is_X(a) then
        x <= (others => (others => '-'));
        t <= (others => '-');
      else
        x <= image_mem(idx*IMAGE_SIZE*IMAGE_SIZE to (idx+1)*IMAGE_SIZE*IMAGE_SIZE-1);
        t <= label_mem(idx);
      end if;
    end if;
  end process;
end architecture;
