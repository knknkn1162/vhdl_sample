library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.perceptron_type.ALL;

entity perceptron_and is
  generic(N : integer := N);
  port (
    x : in arrN_type;
    y : out std_logic
  );
end entity;

architecture behavior of perceptron_and is
  constant w : weight_type := (5, 5);
  constant theta : short_type := 7;
begin
  process(x)
    variable sum : integer;
  begin
    sum := 0;
    for i in 0 to N-1 loop
      if x(i)='1' then
        sum := sum + w(i);
      end if;
    end loop;
    if sum - theta > 0 then
      y <= '1';
    else
      y <= '0';
    end if;
  end process;
end architecture;

