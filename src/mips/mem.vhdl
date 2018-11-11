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
      -- addi $rt, $rs, imm
      --    main:   addi $s0, $0, 5
      -- 0010/00 00/000 1/0000 0x0005
      ram(0) <= X"20100005";
      -- add $rd, $rs, $rt
      -- add $s1, $s0, $s0
      -- 0000/00 10/000 1/0000 /1000/1 000/00 10/0000
      ram(1) <= X"02108820";
      -- addi $rt, $rs, imm
      --    main:   addi $s1, $s1, 5
      -- 0010/00 10/001 1/0001 0x0005
      -- ram(2) <= X"22310005";

      -- initialize with zeros
      ram(3 to SIZE-2) <= (others => (others => '0'));
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

