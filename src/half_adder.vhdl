library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
  Port (A, B: in BIT; sum, carry: out BIT);
end half_adder;

-- structual style of modeling
architecture structure_HA of half_adder is
  component xor1
    Port (p, q: in BIT; r: out BIT);
  end component;

  component and1
    Port (x, y: in BIT; z: out BIT);
  end component;

begin
  X1: xor1 port map(A, B, sum);
  A1: and1 port map(A, B, carry);
end structure_HA;

architecture dataflow_HA of half_adder is
begin
  sum <= A xor B;
  carry <= A and B;
end dataflow_HA;
