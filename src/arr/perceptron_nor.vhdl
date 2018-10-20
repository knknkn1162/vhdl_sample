library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.perceptron_type.ALL;

entity perceptron_nor is
  generic(N : integer := N);
  port (
    x : in arrN_type;
    y : out std_logic
  );
end entity;

architecture behavior of perceptron_nor is
  constant w : weight_type := (5, 5);
  constant theta : short_type := 2;
begin
  process(x)
    variable sum : integer;
    variable s : std_logic_vector(DIM-1 downto 0);
  begin
    sum := 0;
    for i in 0 to N-1 loop
      if x(i)='1' then
        sum := sum + w(i);
      end if;
    end loop;
    s := std_logic_vector(to_signed(sum - theta, DIM));
    y <= s(DIM-1);
  end process;
end architecture;

