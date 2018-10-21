library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.weight_pkg.ALL;

package nn3_const_pkg is
  constant M : integer := 2;
  constant N1 : integer := 3;
  constant N2 : integer := 2;
  constant N : integer := 2;

  constant w1 : mat_type(0 to M*N1-1) := (X"00000001", X"00000003", X"00000005", X"00000002", X"00000004", X"00000006");
  constant b1 : arr_type(0 to N1-1) := (X"00000001", X"00000002", X"00000003");
  constant w2 : mat_type(0 to N1*N2-1) := (X"00000001", X"00000004", X"00000002", X"00000005", X"00000003", X"00000006");
  constant b2 : arr_type(0 to N2-1) := (X"00000001", X"00000002");
  constant w3 : mat_type(0 to N2*N-1) := (X"00000001", X"00000003", X"00000002", X"00000004");
  constant b3 : arr_type(0 to N-1) := (X"00000001", X"00000002");
end package;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.weight_pkg.ALL;
use work.nn3_const_pkg.ALL;

entity nn3 is
  port (
    x : in arr_type(0 to M-1);
    z : out arr_type(0 to N-1)
  );
end entity;

architecture behavior of nn3 is
  component weight
    generic(M: integer; N : integer);
    port (
      x : in arr_type(0 to M-1);
      b : in arr_type(0 to N-1);
      w : in mat_type(0 to N*M-1);
      a : out arr_type(0 to N-1)
    );
  end component;

  component relu_n is
    generic(N: integer);
    port (
      a : in arr_type(0 to N-1);
      z : out arr_type(0 to N-1)
    );
  end component;

  signal a1 : arr_type(0 to N1-1);
  signal z1 : arr_type(0 to N1-1);
  signal a2 : arr_type(0 to N2-1);
  signal z2 : arr_type(0 to N2-1);

begin
  weight1 : weight generic map (M=>M, N=>N1)
    port map (
      x => x, b => b1, w => w1, a => a1
  );

  relu_n1 : relu_n generic map (N=>N1)
    port map (
      a => a1, z => z1
  );

  weight2 : weight generic map (M=>N1, N=>N2)
    port map (
      x => z1, b => b2, w => w2, a => a2
  );

  relu_n2 : relu_n generic map (N=>N2)
    port map (
      a => a2, z => z2
  );

  weight3 : weight generic map (M=>N2, N=>N)
  port map (
    x => z2, b => b3, w => w3, a => z
  );
end architecture;
