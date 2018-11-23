library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regrw is
  generic(regfile : string := "./assets/reg/dummy.hex");
  port (
    clk, rst, load : in std_logic;
    rs, rt : in std_logic_vector(4 downto 0);
    imm : in std_logic_vector(15 downto 0);

    -- from controller
    wa : in std_logic_vector(4 downto 0);
    wd : in std_logic_vector(31 downto 0);
    we : in std_logic;
    cached_rds, cached_rdt : in std_logic_vector(31 downto 0);

    rds, rdt, immext : out std_logic_vector(31 downto 0)
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

  signal rd1, rd2 : std_logic_vector(31 downto 0);

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
      rds <= cached_rds;
    else
      rds <= rd1;
    end if;
  end process;

  process(cached_rdt, rd2)
  begin
    if not is_X(cached_rdt) then
      rdt <= cached_rdt;
    else
      rdt <= rd2;
    end if;
  end process;

  sgnext0 : sgnext port map (
    a => imm,
    y => immext
  );
end architecture;
