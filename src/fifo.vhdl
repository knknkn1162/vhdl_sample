library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo is
  generic(ADDR_WIDTH : natural; DATA_WIDTH : natural);
  port (
    clk, i_clear : in std_logic;
    i_wen : in std_logic;
    i_wdata : in std_logic_vector(DATA_WIDTH-1 downto 0);
    i_ren : in std_logic;
    o_rdata : out std_logic_vector(DATA_WIDTH-1 downto 0);
    o_full : out std_logic;
    o_empty : out std_logic;
    o_stop : out std_logic
  );
end entity;

architecture behavior of fifo is
  constant RAM_SIZE : natural := 2**ADDR_WIDTH;
  type ram_type is array(natural range<>) of std_logic_vector(DATA_WIDTH-1 downto 0);

  signal s_ram_data : ram_type(0 to RAM_SIZE-1);

  -- avoid if expression
  signal s_widx : std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal s_ridx : std_logic_vector(ADDR_WIDTH-1 downto 0);

  -- Actually the range is [0 to RAM_SIZE-1]+-1 => [-1 to RAM_SIZE]
  -- but avoiding if expression, the range is increased by 1.
  signal s_fifo_cnt : integer range 0 to RAM_SIZE+1;
  signal s_full, s_empty : std_logic;

begin
  process(clk)
  begin
    if rising_edge(clk) then
      if i_clear = '1' then
        s_widx <= (others => '0');
        s_ridx <= (others => '0');
        s_fifo_cnt <= 1;
      else
        if i_wen = '1' then
          s_fifo_cnt <= s_fifo_cnt + 1;
          s_ram_data(to_integer(unsigned(s_widx))) <= i_wdata;
          if s_full = '0' then
            s_widx <= std_logic_vector(unsigned(s_widx) + 1);
          end if;
        elsif i_ren = '1' then
          s_fifo_cnt <= s_fifo_cnt - 1;
          if s_empty = '0' then
            s_ridx <= std_logic_vector(unsigned(s_ridx) + 1);
          end if;
        end if;
      end if;
    end if; -- rising_edge(clk);
  end process;

  o_rdata <= s_ram_data(to_integer(unsigned(s_ridx)));

  -- when reaches upper limit
  s_full <= '1' when s_fifo_cnt = RAM_SIZE else '0';
  -- when reaches lower limit
  s_empty <= '1' when s_fifo_cnt = 1 else '0';
  o_full <= s_full; o_empty <= s_empty;

  process(clk)
  begin
    if rising_edge(clk) then
      if (s_full and i_wen) = '1' or (s_empty and i_ren) = '1' then
        o_stop <= '1';
      end if;
    end if;
  end process;
end  architecture;
