library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity sigmoidal is
  port (
    a : in std_logic_vector(DSIZE-1 downto 0);
    z : out std_logic_vector(SIZE-1 downto 0)
  );
end entity;

architecture behavior of sigmoidal is
  function conv(a : std_logic_vector) return integer is
    variable input : integer range 0 to 2**DSIZE-1;
    variable b : integer range 0 to 2**SIZE-1;
  begin
    input := to_integer(abs(signed(a)));
    if(input=0) then b := 0;
    elsif (input>0 and input<97) then b := 2;
    elsif (input>=97 and input < 198) then b := 6;
    elsif (input>=198 and input < 305) then b := 10;
    elsif (input>=305 and input < 425) then b := 14;
    elsif (input>=425 and input < 567) then b := 18;
    elsif (input>=567 and input < 753) then b := 22;
    elsif (input>=753 and input < 1047) then b := 26;
    else b := 30;
    end if;
    if a(a'length-1)='1' then
      return -b;
    else
      return b;
    end if;
  end function;
begin
  process(a) begin
    if is_X(a) then
      z <= (others => '-');
    else
      z <= std_logic_vector(to_signed(conv(a), SIZE));
    end if;
  end process;
end architecture;
