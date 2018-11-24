library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
  generic(memfile : string; regfile : string := "./assets/reg/dummy.hex");
  port (
    clk, rst, load : in std_logic;

    -- controller
    opcode, funct : out std_logic_vector(5 downto 0);
    rs, rt, rd : out std_logic_vector(4 downto 0);
    -- for memadr
    pc_aluout_s : in std_logic;
    pc4_br4_ja_s : in std_logic_vector(1 downto 0);
    pc_en : in std_logic;
    rw_en : in std_logic;
    -- for memwrite
    mem_we: in std_logic;
    -- for decode
    cached_rds, cached_rdt : in std_logic_vector(31 downto 0);
    is_equal : out std_logic;
    -- for writeback
    instr_en : in std_logic;
    reg_wa : in std_logic_vector(4 downto 0);
    reg_wd : in std_logic_vector(31 downto 0);
    reg_we : in std_logic;
    -- for calc
    alucont : in std_logic_vector(2 downto 0);
    rdt_immext_s : in std_logic;
    calc_en : in std_logic;

    -- scan for testbench
    pc : out std_logic_vector(31 downto 0);
    pcnext : out std_logic_vector(31 downto 0);
    addr, mem_rd, mem_wd : out std_logic_vector(31 downto 0);
    rds, rdt, immext : out std_logic_vector(31 downto 0);
    ja : out std_logic_vector(27 downto 0);
    alures : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of datapath is

  component memrw
    generic(memfile : string);
    port (
      clk, rst, load: in std_logic;
      addr : in std_logic_vector(31 downto 0);
      rdt : in std_logic_vector(31 downto 0);
      rd : out std_logic_vector(31 downto 0);
      -- controller
      we : in std_logic;
      -- scan
      wd : out std_logic_vector(31 downto 0)
    );
  end component;

  component decode
    port (
      clk, rst : in std_logic;
      mem_rd : in std_logic_vector(31 downto 0);
      rs, rt, rd, shamt : out std_logic_vector(4 downto 0);
      imm : out std_logic_vector(15 downto 0);
      target : out std_logic_vector(25 downto 0);
      -- controller
      opcode, funct : out std_logic_vector(5 downto 0);
      instr_en : in std_logic
    );
  end component;

  component regrw
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
  end component;

  component calc
    port (
      clk, rst : in std_logic;
      rds, rdt, immext : in std_logic_vector(31 downto 0);
      target : in std_logic_vector(25 downto 0);
      alures : out std_logic_vector(31 downto 0);
      aluzero : out std_logic;
      brplus : out std_logic_vector(31 downto 0);
      ja : out std_logic_vector(27 downto 0);
      -- controller
      alucont : in std_logic_vector(2 downto 0);
      rdt_immext_s : in std_logic;
      calc_en : in std_logic
    );
  end component;

  component memadr
    port (
      clk, rst : in std_logic;
      alures : in std_logic_vector(31 downto 0);
      ja : in std_logic_vector(27 downto 0);
      brplus : in std_logic_vector(31 downto 0);
      addr : out std_logic_vector(31 downto 0);
      reg_aluout : out std_logic_vector(31 downto 0);
      -- controller
      pc_aluout_s : in std_logic;
      pc4_br4_ja_s : in std_logic_vector(1 downto 0);
      pc_en, rw_en : in std_logic;
      -- scan
      pc : out std_logic_vector(31 downto 0);
      pcnext : out std_logic_vector(31 downto 0)
    );
  end component;

  signal mem_rd0, mem_addr0 : std_logic_vector(31 downto 0);
  signal rs0, rt0, rd0, shamt0 : std_logic_vector(4 downto 0);
  signal imm0 : std_logic_vector(15 downto 0);
  signal target0 : std_logic_vector(25 downto 0);
  signal rds0, rdt0, immext0 : std_logic_vector(31 downto 0);
  signal ja0 : std_logic_vector(27 downto 0);
  signal reg_aluout0 : std_logic_vector(31 downto 0);
  signal alures0 : std_logic_vector(31 downto 0);
  signal brplus0 : std_logic_vector(31 downto 0);

begin
  memrw0 : memrw generic map (memfile=>memfile)
  port map (
    clk => clk, rst => rst, load => load,
    rdt => rdt0,
    addr => mem_addr0,
    rd => mem_rd0, -- out
    -- controller
    we => mem_we,
    -- scan
    wd => mem_wd
  );
  mem_rd <= mem_rd0;
  addr <= mem_addr0; -- for scan

  decode0 : decode port map (
    clk => clk, rst => rst,
    mem_rd => mem_rd0,
    rs => rs0, rt => rt0, rd => rd0, shamt => shamt0,
    imm => imm0,
    target => target0,
    -- controller
    opcode => opcode, funct => funct,
    instr_en => instr_en
  );
  rs <= rs0; rt <= rt0; rd <= rd0;

  regrw0 : regrw generic map(regfile=>regfile)
  port map (
    clk => clk, rst => rst, load => load,
    rs => rs0, rt => rt0, imm => imm0,
    target => target0,
    -- from controller
    wa => reg_wa, wd => reg_wd, we => reg_we,
    cached_rds => cached_rds, cached_rdt => cached_rdt,
    is_equal => is_equal,
    -- out
    rds => rds0, rdt => rdt0, immext => immext0,
    brplus => brplus0,
    ja => ja0
  );

  rds <= rds0; rdt <= rdt0; immext <= immext0;

  calc0 : calc port map (
    clk => clk, rst => rst,
    rds => rds0, rdt => rdt0, immext => immext0,
    alures => alures0,
    -- controller
    alucont => alucont,
    rdt_immext_s => rdt_immext_s,
    calc_en => calc_en
  );
  alures <= alures0;

  memadr0 : memadr port map (
    clk => clk, rst => rst,
    alures => alures0,
    ja => ja0,
    brplus => brplus0,
    addr => mem_addr0,
    reg_aluout => reg_aluout0,
    -- controller
    pc_aluout_s => pc_aluout_s, pc4_br4_ja_s => pc4_br4_ja_s,
    pc_en => pc_en,
    rw_en => rw_en,
    -- scan
    pc => pc, pcnext => pcnext
  );
end architecture;
