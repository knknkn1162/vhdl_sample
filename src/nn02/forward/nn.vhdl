package nn_const_pkg is
  constant BATCH_SIZE : natural := 100;
  constant BSIZE := 7;
end package;

use IEEE;
library IEEE.STD_LOGIC_1164.ALL;
library IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL
use work.nn_const_pkg.ALL
use work.two_layer_pkg.ALL;

entity nn is
  port (
    clk, rst : in std_logic;
    offset : in std_logic_vector(15 downto 0);
    -- maybe R/W in file or memory
    w1 : in warr_type(0 to N*N1-1);
    w2 : in warr_type(0 to N1*M-1);
    count : out std_logic_vector(BSIZE-1 downto 0)
  );
end entity;

architecture behavior of nn is
  component dmem
    generic(BATCH_SIZE: natural);
    port (
      a : in std_logic_vector(15 downto 0);
      -- [0, 60000)
      offset : in std_logic_vector(15 downto 0);
      -- image
      x : out arr_type(0 to IMAGE_SIZE*IMAGE_SIZE-1);
      -- [0, 9)
      t : out std_logic_vector(3 downto 0)
    );
  end component;

  component two_layer
    port (
      x : in arr_type(0 to M-1);
      -- 6bit
      w1 : in warr_type(0 to N*N1-1);
      w2 : in warr_type(0 to N1*M-1);
      z : out arr_type(0 to N-1);
      idx : out harr_type(0 to N-1)
    );
  end component;

  component umax
    generic(N: natural);
    port (
      z : in arr_type(0 to N-1);
      zmax : out std_logic_vector(SIZE-1 downto 0);
      idx : out std_logic_vector(HSIZE-1 downto 0)
    );
  end component;

  component counter is
    generic(N: natural);
    port (
      clk, rst : in std_logic;
      ena : in std_logic;
      cnt : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal addr : std_logic_vector(15 downto 0);
  signal x : arr_type(0 to IMAGE_SIZE*IMAGE_SIZE-1);
  signal t : std_logic_vector(3 downto 0);
  signal w10 : warr_type(0 to N*N1-1);
  signal w20 : warr_type(0 to N1*M-1);
  signal z : arr_type(0 to N-1);
  signal idx : std_logic_vector(HSIZE-1 downto 0);
  signal zmax : std_logic_vector(SIZE-1 downto 0);
  signal ena : std_logic;

begin
  addr_counter : counter generic map(N=>15)
  port map (
    clk => clk, rst => rst,
    ena => '1', cnt => addr
  );

  dmem0 : dmem generic map (BATCH_SIZE=>BATCH_SIZE)
  port map (
    a => addr,
    offset => offset,
    x => x, t => t
  );

  two_layer0 : two_layer port map (
    x => x,
    w1 => w1,
    w2 => w2,
    z => z,
  )
  
  umax0 : umax generic map(N=>N)
  port map (
    z => z,
    zmax => zmax,
    idx => idx
  );

  -- N depends on BATCH_SIZE
  ena <= '1' when t = idx else '0';
  training_counter : counter generic map(N=>7)
  port map (
    clk => clk, rst =>rst,
    ena => ena,
    cnt => count
  );

end architecture;
