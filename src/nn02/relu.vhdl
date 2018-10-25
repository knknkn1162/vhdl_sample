library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.nn_pkg.ALL;

entity relu is
  port (
    -- [-(2**23)/2**13, (2**23-1)/2**13)
    a : in std_logic_vector(ASIZE-1 downto 0);
    -- [0, (2**8-1)/2**8]
    z : out std_logic_vector(SIZE-1 downto 0)
  );
end entity;

architecture behavior of relu is
begin
  process(a) begin
    -- when positive
    if a(ASIZE-1)='0' then
      -- a(23 downto 13)="0"
      if a(ASIZE-2 downto SIZE+WSIZE-1)="0" then
        -- a(12 downto 5)
        z <= a(SIZE+WSIZE-2 downto WSIZE-1);
      else
        z <= (others => '1');
      end if;
    else
      z <= (others => '0');
    end if;
  end process;
end architecture;
