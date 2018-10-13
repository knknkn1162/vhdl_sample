library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dmem is
  port (
    clk : in std_logic;
    -- write enable
    we : in std_logic;
    -- write data
    wd : in std_logic_vector(31 downto 0);
    addr: in std_logic_vector(31 downto 0);
    -- read data
    rd : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of dmem is
  constant N: integer := 64;
  type ramtype is array(N-1 downto 0) of std_logic_vector(31 downto 0);
  signal is_init : std_logic := '1';
  signal mem : ramtype;
begin
  process(clk) begin
    -- initialization (write instruction into mem)
    -- TODO: how to write initialization? Is it right??
    if is_init='1' then
      mem(16) <= X"000000ff";
      is_init <= '0';
    end if;

    if rising_edge(clk) then
      if we='1' then mem(to_integer(unsigned(addr(7 downto 2)))) <= wd;
      end if;
    end if;
  end process;

  -- when we change `we`, always read latest data from memory.
  process(addr, we) begin
    if Is_X(addr) then
      rd <= (others => 'Z');
    else
      rd <= mem(to_integer(unsigned(addr(7 downto 2))));
    end if;
  end process;
end architecture;
