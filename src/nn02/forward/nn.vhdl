library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.dmem_const_pkg.ALL;

package nn_const_pkg is
  constant BATCH_SIZE : natural := 100;
  constant BSIZE : natural := 7;
  constant INPUT_SIZE : natural := IMAGE_SIZE2-1;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;
use work.nn_const_pkg.ALL;
use work.two_layer_pkg.ALL;
use work.dmem_const_pkg.ALL;

entity nn is
  port (
    clk, rst : in std_logic;
    offset : in std_logic_vector(15 downto 0);
    -- maybe R/W in file or memory
    w1 : in warr_type(0 to INPUT_SIZE*HIDDEN_SIZE-1);
    w2 : in warr_type(0 to HIDDEN_SIZE*OUTPUT_SIZE-1);
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
      x : out arr_type(0 to IMAGE_SIZE2-1);
      -- [0, 9)
      t : out std_logic_vector(3 downto 0)
    );
  end component;

  component two_layer is
    generic(INPUT_SIZE: natural);
    port (
      x : in arr_type(0 to INPUT_SIZE-1);
      -- 6bit
      w1 : in warr_type(0 to INPUT_SIZE*HIDDEN_SIZE-1);
      w2 : in warr_type(0 to HIDDEN_SIZE*OUTPUT_SIZE-1);
      z : out arr_type(0 to OUTPUT_SIZE-1)
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
  signal x : arr_type(0 to IMAGE_SIZE2-1);
  signal t : std_logic_vector(3 downto 0);
  signal w10 : warr_type(0 to INPUT_SIZE*HIDDEN_SIZE-1);
  signal w20 : warr_type(0 to HIDDEN_SIZE*OUTPUT_SIZE-1);
  signal z : arr_type(0 to OUTPUT_SIZE-1);
  signal idx : std_logic_vector(HSIZE-1 downto 0);
  signal zmax : std_logic_vector(SIZE-1 downto 0);
  signal ena : std_logic;

begin
  w10 <= (others => (others => '0'));
  w20 <= (others => (others => '0'));

  addr_counter : counter generic map(N=>16)
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

  two_layer0 : two_layer generic map(INPUT_SIZE=>INPUT_SIZE)
  port map (
    x => x,
    w1 => w1,
    w2 => w2,
    z => z
  );
  
  umax0 : umax generic map(N=>OUTPUT_SIZE)
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
