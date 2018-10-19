library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sigmoid is
  generic(N : integer := 6);
  port (
    a : in std_logic_vector(2*N-1 downto 0);
    b : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture behavior of sigmoid is
begin
  process(a) 
    variable num : integer;
    variable res : integer;
  begin
  num := to_integer(abs(signed(a)));
  if (num = 0) then res := 0;
  elsif (num>0 and num < 97) then res := 2;
  elsif (num >= 97 and  num < 198) then res := 6;
  elsif (num >= 198 and num < 305) then res := 10;
  elsif (num >= 305 and num < 425) then res := 14;
  elsif (num >= 425 and num < 567) then res := 18;
  elsif (num >= 567 and num < 753) then res := 22;
  elsif (num >= 753 and num < 1047) then res := 26;
  else res := 30;
  end if;
  if a(2*N-1)='1' then 
    res := -1 * res;
  end if;
  b <= std_logic_vector(to_signed(res, N));
  end process;


end architecture;
