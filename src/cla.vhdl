library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla is
  generic(N: integer := 4);
  port (
    a : in std_logic_vector(N-1 downto 0);
    b : in std_logic_vector(N-1 downto 0);
    cin : in std_logic;
    cout : out std_logic;
    s : out std_logic_vector(N-1 downto 0)
       );
end entity;

architecture behavior of cla is
  component and_or
    port (
      a : in std_logic;
      b : in std_logic;
      p : out std_logic;
      g : out std_logic
        );
  end component;
  signal p : std_logic_vector(N-1 downto 0);
  signal g : std_logic_vector(N-1 downto 0);
  signal g3_0 : std_logic;
  signal p3_0 : std_logic;
  signal c : std_logic_vector(N-1 downto 0);

  -- https://stackoverflow.com/questions/20296276/and-all-elements-of-an-n-bit-array-in-vhdl
  function and_reduct(slv : in std_logic_vector) return std_logic is
    variable res_v : std_logic := '1';
  begin
    for i in slv'range loop
      res_v := res_v and slv(i);
    end loop;
    return res_v;
  end function;

  function gen(g : in std_logic_vector; p : in std_logic_vector; N : in integer) return std_logic is
    variable res_v : std_logic := g(0);
  begin
    for i in 0 to N-1 loop
      res_v := g(i+1) or (p(i+1) and res_v);
    end loop;
    return res_v;
  end function;

begin
  and_or0 : and_or port map (a(0), b(0), p(0), g(0));
  and_or1 : and_or port map (a(1), b(1), p(1), g(1));
  and_or2 : and_or port map (a(2), b(2), p(2), g(2));
  and_or3 : and_or port map (a(3), b(3), p(3), g(3));

  g3_0 <= gen(g, p, N);
  p3_0 <= and_reduct(p);

  cout <= (cin and p3_0) or g3_0;

  c(0) <= g(0) or (p(0) and cin);
  process(c) begin
    for I in 0 to N-2 loop
      c(I+1) <= g(I+1) or (p(I+1) and c(I));
    end loop;
  end process;

  s <= a xor b xor c;
  --for i in 0 to N-1 loop
  --  s(i) <= a(i) xor b(i) xor c(i);
  --end loop;
end architecture;
