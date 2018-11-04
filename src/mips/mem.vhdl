library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem is
  port (
    clk, rst : in std_logic;
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

begin
  process(clk, rst, a)
  begin
    -- initialization
    if rst = '1' then
      -- text
      -- lw $s0, 1020($0) 1000/11 00/000 1/0000 0x03FC
      ram(0) <= X"8C1003FC";
      -- sw $s0, 1016($0) 1010/11 00/000 1/0000 0x03F8
      ram(1) <= X"AC1003F8";
      -- initialize with zeros
      ram(2 to SIZE-2) <= (others => (others => '0'));
      -- data
      ram(SIZE-1) <= X"FFFFFFFF";
    -- write
    elsif rising_edge(clk) then
      if we = '1' then
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

