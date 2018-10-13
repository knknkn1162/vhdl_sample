library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imips is
  port (
    clk, reset : in std_logic;
    addr : in std_logic_vector(31 downto 0);
    -- for testbench
    pc : out std_logic_vector(31 downto 0);
    instr : out std_logic_vector(31 downto 0);
    rs, rt : out std_logic_vector(31 downto 0);
    aluout : out std_logic_vector(31 downto 0);
    data : out std_logic_vector(31 downto 0)
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
      idx : in std_logic_vector(5 downto 0);
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
      a2 : in std_logic_vector(4 downto 0);
      rd2 : out std_logic_vector(31 downto 0);
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
      sgn : out std_logic
        );
  end component;

  component dmem
    port (
      clk : in std_logic;
      -- write enable
      we : in std_logic;
      -- write data
      wd : in std_logic_vector(31 downto 0);
      addr: in std_logic_vector(31 downto 0);
      -- read data
      rd : out std_logic_vector(31 downto 0)
    );
  end component;
  signal instr0, rs0, rt0, immext, aluout0, data0 : std_logic_vector(31 downto 0);
  signal res : std_logic_vector(31 downto 0);
  signal pc0 : std_logic_vector(31 downto 0); -- buffer
  signal pcnext : std_logic_vector(31 downto 0);
  signal regfile_we : std_logic;
  signal dmem_we : std_logic;

begin
  -- TODO: impl program counter
  pcreg: flopr port map(clk, reset, pcnext, pc0);
  pcnext <= std_logic_vector(unsigned(pc0) + 4);
  pc <= pc0;

  imem0: imem port map (
    -- Each size of the instruction is 4 byte.
    idx => pc0(7 downto 2),
    rd => instr0
  );
  instr <= instr0;

  process(instr0) is
  begin
    case (instr0(31 downto 26)) is
      -- lw instruction(0x23)
      when "100011" =>
        regfile_we <= '1';
        dmem_we <= '0';
      -- sw instruction(0x2B)
      when "101011" =>
        regfile_we <= '0';
        dmem_we <= '1';
      when others =>
        regfile_we <= '0';
        dmem_we <= '0';
    end case;
  end process;

  reg0 : regfile port map (
    clk => clk,
    a1 => instr0(25 downto 21),
    rd1 => rs0, -- out
    a2 => instr0(20 downto 16),
    rd2 => rt0, -- out
    a3 => instr0(20 downto 16),
    wd3 => data0,
    we3 => regfile_we
  );
  rs <= rs0;
  rt <= rt0;

  sgnext0 : sgnext port map (
    a => instr0(15 downto 0),
    y => immext
  );

  alu0: alu port map (
    a => rs0,
    b => immext,
    f => "010",
    y => aluout0
  );
  aluout <= aluout0;

  dmem0: dmem port map (
    clk => clk,
    we => dmem_we,
    wd => rt0,
    addr => aluout0,
    rd => data0
  );
  data <= data0;

end architecture;
