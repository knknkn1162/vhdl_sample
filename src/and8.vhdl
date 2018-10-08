library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and8 is
  port (
    a: in std_logic_vector(7 downto 0);
    y: out std_logic
  );
end entity;
architecture synth of and8 is

  -- https://stackoverflow.com/questions/20296276/and-all-elements-of-an-n-bit-array-in-vhdl
  function and_reduct(slv : in std_logic_vector) return std_logic is
    variable res_v : std_logic := '1';  -- Null slv vector will also return '1'
  begin
    for i in slv'range loop
      res_v := res_v and slv(i);
    end loop;
    return res_v;
  end function;

begin
  y <= and_reduct(a);
  --y <= a(7) and a(6) and a(5) and a(4) and a(3) and a(2) and a(1) and a(0);
end architecture;
