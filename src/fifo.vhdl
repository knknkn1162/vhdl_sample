library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo is
  generic(ADDR_WIDTH : natural);
  port (
    clk, i_clear : in std_logic;
    i_wen : in std_logic;
    i_wdata : in std_logic_vector(31 downto 0);
    i_ren : in std_logic;
    o_rdata : out std_logic_vector(31 downto 0);
    o_full : out std_logic;
    o_empty : out std_logic;
    o_stop : out std_logic
  );
end entity;

architecture behavior of fifo is
  type ram_type is array(natural range<>) of std_logic_vector(31 downto 0);
  signal s_ram_data : ram_type(ADDR_WIDTH-1 downto 0);

  signal s_widx : integer range 0 to ADDR_WIDTH-1;
  signal s_ridx : integer range 0 to ADDR_WIDTH-1;
  -- Actually the range is [0 to ADDR_WIDTH]+-1 => [-1 to ADDR_WIDTH+1]
  -- but saving the bit size, the range is increased by 1.
  signal s_fifo_cnt : integer range 0 to ADDR_WIDTH+2;
  signal s_full, s_empty : std_logic;

begin
  process(clk)
  begin
    if rising_edge(clk) then
      if i_clear = '1' then
        s_widx <= 0;
        s_ridx <= 0;
        s_fifo_cnt <= 1;
      else
        if i_wen = '1' then
          s_fifo_cnt <= s_fifo_cnt + 1;
          s_ram_data(s_widx) <= i_wdata;
          if s_full = '0' then
            if s_widx = ADDR_WIDTH - 1 then
              s_widx <= 0;
            else
              s_widx <= s_widx + 1;
            end if;
          end if;
        elsif i_ren = '1' then
          s_fifo_cnt <= s_fifo_cnt - 1;
          if s_empty = '0' then
            if s_ridx = ADDR_WIDTH - 1 then
              s_ridx <= 0;
            else
              s_ridx <= s_ridx + 1;
            end if;
          end if;
        end if;
      end if;
    end if; -- rising_edge(clk);
  end process;
  o_rdata <= s_ram_data(s_ridx);

  s_full <= '1' when s_fifo_cnt = ADDR_WIDTH+2 else '0';
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
