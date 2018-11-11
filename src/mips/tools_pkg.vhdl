library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package tools_pkg is
  function char2int(ch : character) return natural;
end package;

package body tools_pkg is
  function char2int(ch : character) return natural is
    variable ret : natural range 0 to 15;
  begin
    if '0' <= ch and ch <= '9' then
      -- ?? - 0x30
      ret := character'pos(ch) - character'pos('0');
    elsif 'a' <= ch and ch <= 'f' then
      ret := character'pos(ch) - character'pos('a') + 10;
    else
      ret := 0;
    end if;
    return ret;
  end function;
end package body;
