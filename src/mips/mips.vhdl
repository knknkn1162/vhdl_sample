library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips is
  port (
    clk, reset : in std_logic;
    addr : in std_logic_vector(31 downto 0);
    -- for testbench
    pc : out std_logic_vector(31 downto 0);
    instr : out std_logic_vector(31 downto 0);
    rs : out std_logic_vector(31 downto 0);
    aluout : out std_logic_vector(31 downto 0)
       );
end entity;

architecture behavior of mips is
  component mux
    generic(N : integer);
    port (
      d0 : in std_logic_vector(N-1 downto 0);
      d1 : in std_logic_vector(N-1 downto 0);
      s : in std_logic;
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

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

  component sltn
    port (
      a : in std_logic_vector(31 downto 0);
      -- shamt
      n : in std_logic_vector(4 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component

  component alu
    port (
      a, b : in std_logic_vector(31 downto 0);
      f : in std_logic_vector(2 downto 0);
      y : out std_logic_vector(31 downto 0);
      zero : out std_logic
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

  signal instr0, rs0, rt0, aluout0, rt_imm0 : std_logic_vector(31 downto 0);
  signal immext : std_logic_vector(31 downto 0);
  signal res : std_logic_vector(31 downto 0);
  signal pc0 : std_logic_vector(31 downto 0); -- buffer
  signal pcnext : std_logic_vector(31 downto 0);
  signal reg_we3 : std_logic;
  signal addr_rt_rd : std_logic_vector(4 downto 0);
  signal shamt : std_logic_vector(31 downto 0);
  -- selector
  signal rt_rd_s, rt_imm_s : std_logic;
  signal alu_func : std_logic_vector(2 downto 0);
  signal alu_sgn, alu_zero : std_logic;

begin
  pcreg: flopr port map(clk, reset, pcnext, pc0);
  pc <= pc0;
  pcnext <= std_logic_vector(unsigned(pc0) + 4);

  imem0: imem port map (
    -- every instruction is 4 byte size
    idx => pc0(7 downto 2),
    rd => instr0
  );
  instr <= instr0;

  -- TODO: logic reg_we3

  reg0 : regfile port map (
    clk => clk,
    a1 => instr0(25 downto 21),
    rd1 => rs0, -- out
    a2 => instr0(20 downto 16),
    rd2 => rt0,
    a3 => instr0(20 downto 16),
    wd3 => wdata0,
    we3 => reg_we3
  );
  rs <= rs0;
  rt <= rt0;
  wdata <= wdata0;

  -- TODO logic rt_rd_s

  rt_rd_mux: mux port map (
    d0 : instr0(20 downto 16),
    d1 : instr0(15 downto 11),
    s : rt_rd_s,
    y : addr_rt_rd
  );

  sltn0: sltn port map (
    a : rt0,
    n : instr0(10 downto 6),
    y : shamt
  );

  sgnext0 : sgnext port map (
    a => instr0(15 downto 0),
    y => immext
  );

  rt_imm_mux : mux port map (
    d0 : rt0,
    d1 : immext,
    s : rt_imm_s,
    y : rt_imm0
  );
  rt_imm <= rt_imm0;

  -- TODO logic alufunc

  alu0: alu port map (
    a => rs0,
    b => rt_imm0,
    f => alu_func,,
    y => aluout0 -- zero port is ignored
    -- if negative or not
    sgn => alu_sgn,
    -- if a === b
    zero => alu_zero
  );
  aluout <= aluout0;

  -- for lw, sw instruction
  dmem0 : dmem port map (
    clk => clk,
    -- write enable
    we => dmem_we,
    -- write data
    wd => rt0,
    addr: aluout0,
    -- read data
    rd : rdata0
  );
  rdata <= rdata0;

  aluout_sltn_mux : mux port map (
    d0 : aluout0,
    d1 : shamt,
    s : aluout_shamt_s,
    y : calc_data0
  );
  calc_data <= calc_data0;

  -- impl calc_r_s

  mux port map (
    d0 : aluout_shamt0,
    d1 : rdata0,
    s : calc_r_s,
    y : result0,
  );
  result <= result0;



end architecture;
