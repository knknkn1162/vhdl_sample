library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regrw is
  port (
    clk, rst : in std_logic;
    rs, rt : in std_logic_vector(4 downto 0);
    wd : in std_logic_vector(31 downto 0);
    imm : in std_logic_vector(15 downto 0);

    rds, rdt, immext : out std_logic_vector(31 downto 0);
    -- controller
    we : in std_logic;
    -- scan
    wa : out std_logic_vector(4 downto 0)
  );
end entity;

architecture behavior of regrw is
  component regfile
    port (
      clk, rst : in std_logic;
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
  signal wa0 : std_logic_vector(4 downto 0);
begin
  wa0 <= rt;
  regfile0 : regfile port map (
    clk => clk, rst => rst,
    a1 => rs, rd1 => rds,
    a2 => rt, rd2 => rdt,
    a3 => wa0, wd3 => wd, we3 => we
  );
  wa <= wa0;

  sgnext0 : sgnext port map (
    a => imm,
    y => immext
  );
end architecture;
