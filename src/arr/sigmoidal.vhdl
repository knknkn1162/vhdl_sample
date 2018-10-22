library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.weight16_pkg.ALL;

entity sigmoidal is
  port (
    input : in std_logic_vector(DSIZE-1 downto 0);
    z : out std_logic_vector(SIZE-1 downto 0)
  );
end entity;

architecture behavior of sigmoidal is
  function conv(inp : std_logic_vector) return integer is
    variable a : integer range 0 to 2**(DSIZE-1)-1;
    variable b : integer range 0 to 2**SIZE-1;
  begin
    a := to_integer(abs(signed(inp)));
    if(a=0) then b := 0;
    elsif (a>0 and a<97) then b := 2;
    elsif (a>=97 and a < 198) then b := 6;
    elsif (a>=198 and a < 305) then b := 10;
    elsif (a>=305 and a < 425) then b := 14;
    elsif (a>=425 and a < 567) then b := 18;
    elsif (a>=567 and a < 753) then b := 22;
    elsif (a>=753 and a < 1047) then b := 26;
    else b := 30;
    end if;
    if inp(inp'length-1)='1' then
      return -b;
    else
      return b;
    end if;
  end function;
begin
  z <= std_logic_vector(to_unsigned(conv(input), SIZE));
end architecture;
