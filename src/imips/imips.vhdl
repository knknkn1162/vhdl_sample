library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imips is
  port (
    clk, reset : in std_logic;
    addr : in std_logic_vector(31 downto 0);
    pc : out std_logic_vector(31 downto 0);
    aluout : out std_logic_vector(31 downto 0)
       );
end entity;

architecture behavior of imips is
  component flopr
    port (
      clk, reset: in std_logic;
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;

  component imem
    port (
      addr : in std_logic_vector(7 downto 0);
      rd : out std_logic_vector(31 downto 0)
    );
  end component;

  component regfile
    port (
      clk : in std_logic;
      -- 25:21(read)
      a1 : in std_logic_vector(4 downto 0);
      rd1 : out std_logic_vector(31 downto 0);
      -- 20:16(read)
      -- a2 : in std_logic_vector(4 downto 0);
      -- rd2 : out std_logic_vector(31 downto 0);

      -- 20:16(write)
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

  component alu
    port (
      a, b : in std_logic_vector(31 downto 0);
      f : in std_logic_vector(2 downto 0);
      y : out std_logic_vector(31 downto 0);
      zero : out std_logic
        );
  end component;
  signal instr, rs, rt, immext : std_logic_vector(31 downto 0);
  signal res : std_logic_vector(31 downto 0);
  signal pc0 : std_logic_vector(31 downto 0); -- buffer
  signal pcnext : std_logic_vector(31 downto 0);

begin
  -- TODO: impl program counter
  pcreg: flopr port map(clk, reset, pcnext, pc0);
  pc <= std_logic_vector(unsigned(pc0) + 4);

  -- imem0: imem port map (
  --   addr => pc0(7 downto 0),
  --   rd => instr
  -- );

  -- reg0 : regfile port map (
  --   clk => clk,
  --   a1 => instr(25 downto 21),
  --   rd1 => rt,
  --   a3 => instr(20 downto 16),
  --   wd3 => res,
  --   we3 => '1'
  -- );

  -- sgnext0 : sgnext port map (
  --   a => instr(15 downto 0),
  --   y => immext
  -- );

  -- alu0: alu port map (
  --   a => rt,
  --   b => immext,
  --   f => "010",
  --   y => res -- zero port is ignored
  -- );
  -- aluout <= res;

end architecture;
