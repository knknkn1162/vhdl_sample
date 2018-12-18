library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity countern is
  generic(N: natural);
  port (
    clk : in std_logic;
    i_rst : in std_logic;
    o_cnt : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of countern is
begin
  process(clk, i_rst)
    variable v_q : natural range 0 to 2**N-1;
  begin
    if i_rst = '1' then
      v_q := 0;
    elsif rising_edge(clk) then
      if v_q = 2**N-1 then
        v_q := 0;
      else
        v_q := v_q + 1;
      end if;
    end if;
    o_cnt <= std_logic_vector(to_unsigned(v_q, N));
  end process;
end architecture;
