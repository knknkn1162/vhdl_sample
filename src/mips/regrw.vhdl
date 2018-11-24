library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regrw is
  generic(regfile : string := "./assets/reg/dummy.hex");
  port (
    clk, rst, load : in std_logic;
    rs, rt : in std_logic_vector(4 downto 0);
    imm : in std_logic_vector(15 downto 0);
    target : in std_logic_vector(25 downto 0); -- J-type

    -- from controller
    wa : in std_logic_vector(4 downto 0);
    wd : in std_logic_vector(31 downto 0);
    we : in std_logic;
    cached_rds, cached_rdt : in std_logic_vector(31 downto 0);
    is_equal : out std_logic;

    rds, rdt, immext : out std_logic_vector(31 downto 0);
    brplus : out std_logic_vector(31 downto 0);
    ja : out std_logic_vector(27 downto 0)
  );
end entity;

architecture behavior of regrw is
  component reg
    generic(filename : string);
    port (
      clk, rst, load : in std_logic;
      -- 25:21(read)
      a1 : in std_logic_vector(4 downto 0);
      rd1 : out std_logic_vector(31 downto 0);
      -- 20:16(read)
      a2 : in std_logic_vector(4 downto 0);
      rd2 : out std_logic_vector(31 downto 0);

      a3 : in std_logic_vector(4 downto 0);
      wd3 : in std_logic_vector(31 downto 0);
      we3 : in std_logic
    );
  end component;

  component sgnext
    port (
      a : in std_logic_vector(15 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;

  component slt2
    generic (N: natural);
    port (
      a : in std_logic_vector(N-1 downto 0);
      y : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal rd1, rd2 : std_logic_vector(31 downto 0);
  signal rds0, rdt0 : std_logic_vector(31 downto 0);

  signal immext0 : std_logic_vector(31 downto 0);
  signal ja0 : std_logic_vector(27 downto 0);
  signal target28 : std_logic_vector(27 downto 0);
  constant zero : std_logic_vector(31 downto 0) := (others => '0');

begin
  reg0 : reg generic map(filename=>regfile)
  port map (
    clk => clk, rst => rst, load => load,
    a1 => rs, rd1 => rd1,
    a2 => rt, rd2 => rd2,
    a3 => wa, wd3 => wd, we3 => we
  );

  process(cached_rds, rd1)
  begin
    if not is_X(cached_rds) then
      rds0 <= cached_rds;
    else
      rds0 <= rd1;
    end if;
  end process;
  rds <= rds0;

  process(cached_rdt, rd2)
  begin
    if not is_X(cached_rdt) then
      rdt0 <= cached_rdt;
    else
      rdt0 <= rd2;
    end if;
  end process;
  rdt <= rdt0;

  -- support beq
  process(rds0, rdt0)
  begin
    if (rds0 xor rdt0) = zero then
      is_equal <= '1';
    else
      is_equal <= '0';
    end if;
  end process;

  sgnext0 : sgnext port map (
    a => imm,
    y => immext0
  );
  immext <= immext0;

  immext_slt2 : slt2 generic map(N=>32)
  port map (
    a => immext0,
    y => brplus
  );

  target28 <= b"00" & target;
  target_slt2 : slt2 generic map (N=>28)
  port map (
    a => target28,
    y => ja0
  );
  ja <= ja0;
end architecture;
