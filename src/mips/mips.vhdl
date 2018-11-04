library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mips is
  port (
    clk, rst : in std_logic;
    addr : in std_logic_vector(31 downto 0);
    -- scan for testbench
    pc : out std_logic_vector(31 downto 0);
    pcnext : out std_logic_vector(31 downto 0);
    mem_rd : out std_logic_vector(31 downto 0);
    a3 : out std_logic_vector(4 downto 0);
    --dmem_wd  : out std_logic_vector(31 downto 0)
    reg_wd : out std_logic_vector(31 downto 0);
    rs, rt : out std_logic_vector(31 downto 0);
    imm : out std_logic_vector(31 downto 0);
    aluout : out std_logic_vector(31 downto 0)
      );
end entity;

architecture behavior of mips is
  component flopr_en is
    port (
      clk, rst, en: in std_logic;
      a : in std_logic_vector(31 downto 0);
      y : out std_logic_vector(31 downto 0)
        );
  end component;

  component mem
    port (
      clk, rst : in std_logic;
      we : in std_logic;
      -- program counter is 4-byte aligned
      a : in std_logic_vector(29 downto 0);
      wd : in std_logic_vector(31 downto 0);
      rd : out std_logic_vector(31 downto 0)
    );
  end component;

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

  component alu
    port (
      a, b : in std_logic_vector(31 downto 0);
      f : in std_logic_vector(2 downto 0);
      y : out std_logic_vector(31 downto 0);
      -- if a === b
      zero : out std_logic
    );
  end component;

  component mux2
    generic(N : integer);
    port (
      d0 : in std_logic_vector(N-1 downto 0);
      d1 : in std_logic_vector(N-1 downto 0);
      s : in std_logic;
      y : out std_logic_vector(N-1 downto 0)
        );
  end component;

  signal pc0, pcnext0 : std_logic_vector(31 downto 0);
  signal mem_rd0, mem_wd0, reg_wd0 : std_logic_vector(31 downto 0);
  signal instr0 : std_logic_vector(31 downto 0);
  signal rs0, rt0, imm0 : std_logic_vector(31 downto 0);
  signal srca0, srcb0 : std_logic_vector(31 downto 0);
  signal alures0, aluout0 : std_logic_vector(31 downto 0);
  signal mem_addr0 : std_logic_vector(31 downto 0);
  signal a30 : std_logic_vector(4 downto 0);
  signal pc_aluout_s : std_logic;
  signal mem_we, reg_we : std_logic;
  signal instr_en : std_logic;
  signal zero0 : std_logic;
begin
  reg_pc: flopr_en port map (
    clk => clk, rst => rst,
    a => pcnext0,
    y => pc0
  );
  pc <= pc0;
  pcnext0 <= std_logic_vector(unsigned(pc0) + 4);
  pcnext <= pcnext0;

  pc_alu_mux : mux2 generic map (N=>32)
  port map (
    d0 => pc0,
    d1 => aluout0,
    s => pc_aluout_s,
    y => mem_addr0
  );

  mem0 : mem port map (
    clk => clk, rst => rst,
    we => mem_we,
    a => mem_addr0(31 downto 2),
    -- wd => mem_wd,
    rd => mem_rd0
  );
  mem_rd <= mem_rd0;

  reg_instr : flopr_en port map (
    clk => clk, rst => rst, en => instr_en,
    a => mem_rd0,
    y => instr0
  );

  reg_memdata : flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => mem_rd0,
    y => reg_wd0
  );

  a30 <= instr0(15 downto 11);
  regfile0 : regfile port map (
    clk => clk, rst => rst,
    a1 => instr0(25 downto 21),
    rd1 => rs0,
    a2 => instr0(20 downto 16),
    rd2 => rt0,
    a3 => a30,
    wd3 => reg_wd0,
    we3 => reg_we
  );
  rs <= rs0;
  rt <= rt0;
  a3 <= a30;
  reg_wd <= reg_wd0;

  reg_rs : flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => rs0,
    y => srca0
  );

  sgnext0 : sgnext port map (
    a => instr0(15 downto 0),
    y => imm0
  );
  imm <= imm0;
  srcb0 <= imm0;

  alu0 : alu port map (
    a => srca0, b => srcb0,
    f => "010",
    y => alures0,
    zero => zero0
  );

  reg_alu : flopr_en port map (
    clk => clk, rst => rst, en => '1',
    a => alures0,
    y => aluout0
  );
  aluout <= aluout0;
end architecture;
