library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity mem is
  generic(filename : string);
  port (
    clk, rst, load : in std_logic;
    we : in std_logic;
    -- program counter is 4-byte aligned
    a : in std_logic_vector(29 downto 0);
    wd : in std_logic_vector(31 downto 0);
    rd : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of mem is
  constant SIZE : natural := 256; -- 0x0100
  type ramtype is array(natural range<>) of std_logic_vector(31 downto 0);
  signal ram : ramtype(0 to SIZE-1);

  function char2int(ch : character) return natural is
    variable ret : natural range 0 to 15;
  begin
    if '0' <= ch and ch <= '9' then
      -- ?? - 0x30
      ret := character'pos(ch) - character'pos('0');
    elsif 'a' <= ch and ch <= 'f' then
      ret := character'pos(ch) - character'pos('a') + 10;
    else
      ret := 0;
    end if;
    return ret;
  end function;

begin
  process(clk, rst, a)
    file memfile : text;
    variable idx : integer;
    variable lin : line;
    variable ch : character;
    variable result : natural range 0 to 15; -- hex
   begin
    -- initialization
    if rst = '1' then
      -- initialize with zeros
      ram <= (others => (others => '0'));
      file_open(memfile, filename, READ_MODE);
      idx := 0;
    elsif rising_edge(clk) then
      if load = '1' then
        while not endfile(memfile) loop
          readline(memfile, lin);
          for i in 0 to 7 loop
            read(lin, ch);
            result := char2int(ch);
            ram(idx)(31-i*4 downto 28-i*4) <= std_logic_vector(to_unsigned(result, 4));
          end loop;
          idx := idx + 1;
        end loop;
        file_close(memfile);
      elsif we = '1' then
        if not is_X(a) then
          ram(to_integer(unsigned(a))) <= wd;
        end if;
      end if;
    end if;
  end process;

  process(clk, rst, a, we)
  begin
    -- read
    if is_X(a) then
      rd <= (others => '0');
    else
      rd <= ram(to_integer(unsigned(a)));
    end if;
  end process;
end architecture;
