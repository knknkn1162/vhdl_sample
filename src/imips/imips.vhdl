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
    addr_rt_rd : out std_logic_vector(4 downto 0);
    aluout : out std_logic_vector(31 downto 0);
    shamt : out std_logic_vector(31 downto 0);
    wdata : out std_logic_vector(31 downto 0)
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

  component mux2
    generic (N: integer);
    port (
      d0 : in std_logic_vector(N-1 downto 0);
      d1 : in std_logic_vector(N-1 downto 0);
      s : in std_logic;
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  component alu
    port (
      a, b : in std_logic_vector(31 downto 0);
      f : in std_logic_vector(2 downto 0);
      y : out std_logic_vector(31 downto 0);
      sgn : out std_logic;
      zero : out std_logic
        );
  end component;

  component sltn
    port (
      a : in std_logic_vector(31 downto 0);
      -- shamt
      n : in std_logic_vector(4 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;

  signal instr0, rs0, rt0, wdata0, aluout0 : std_logic_vector(31 downto 0);
  signal immext : std_logic_vector(31 downto 0);
  signal addr_rt_rd0 : std_logic_vector(4 downto 0);
  signal pc0 : std_logic_vector(31 downto 0); -- buffer
  signal pcnext : std_logic_vector(31 downto 0);
  signal shamt0 : std_logic_vector(31 downto 0);
  signal alu_func : std_logic_vector(2 downto 0);
  signal is_alu_slt : std_logic;

begin
  -- TODO: impl program counter
  pcreg: flopr port map(clk, reset, pcnext, pc0);
  pcnext <= std_logic_vector(unsigned(pc0) + 4);
  pc <= pc0;

  imem0: imem port map (
    idx => pc0(7 downto 2),
    rd => instr0
  );
  instr <= instr0;

  reg0 : regfile port map (
    clk => clk,
    a1 => instr0(25 downto 21),
    rd1 => rs0, -- out
    a2 => instr0(20 downto 16),
    rd2 => rt0,
    a3 => addr_rt_rd0,
    wd3 => wdata0,
    we3 => '1'
  );
  rs <= rs0;
  rt <= rt0;

  mux_r : mux2 generic map (N => 5)
    port map (
    d0 => instr0(20 downto 16),
    d1 => instr0(15 downto 11),
    s => '1',
    y => addr_rt_rd0
  );

  -- funct
  process(instr0) is
  begin
    case instr0(5 downto 0) is
      -- sll
      when "000000" =>
        is_alu_slt <= '1';
        alu_func <= (others => '-');
      -- add
      when "100000" =>
        alu_func <= "010";
        is_alu_slt <= '0';
      -- and
      when "100100" =>
        alu_func <= "000";
        is_alu_slt <= '0';
      -- sub
      when "100010" =>
        alu_func <= "110";
        is_alu_slt <= '0';
      -- or
      when "100101" =>
        alu_func <= "001";
        is_alu_slt <= '0';
      when others =>
        alu_func <= (others => '-');
        is_alu_slt <= '0';
    end case;
  end process;

  alu0: alu port map (
    a => rs0,
    b => rt0,
    f => alu_func,
    y => aluout0 -- zero port is ignored
  );
  aluout <= aluout0; -- out

  slt_rd2 : sltn port map (
    a => rt0,
    n => instr0(10 downto 6),
    y => shamt0
  );
  shamt <= shamt0;

  mux_alu_slt: mux2 generic map (N => 32)
    port map (
    d0 => aluout0,
    d1 => shamt0,
    s => is_alu_slt,
    y => wdata0
  );
  wdata <= wdata0;

end architecture;
