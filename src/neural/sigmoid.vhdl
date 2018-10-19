library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sigmoid is
  port (
    a : in std_logic_vector(11 downto 0);
    b : out std_logic_vector(5 downto 0)
  );
end entity;

architecture behavior of sigmoid is
  function sgm(num : in integer; msb : in std_logic) return std_logic_vector is
    variable res : integer;
  begin
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
    if msb = '1' then
      return std_logic_vector(to_signed(-res, 6));
    else
      return std_logic_vector(to_signed(res, 6));
    end if;
  end function;
begin
  process(a) begin
    if is_X(a) then
      b <= (others => '-');
    else
      b <= sgm(to_integer(abs(signed(a))), a(11));
    end if;
  end process;
end architecture;
