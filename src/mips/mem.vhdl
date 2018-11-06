library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem is
  port (
    clk, rst : in std_logic;
    we : in std_logic;
    -- program counter is 4-byte aligned
    a : in std_logic_vector(29 downto 0);
    wd : in std_logic_vector(31 downto 0);
    rd : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of mem is
  constant SIZE : natural := 256; -- 0x0100
  type ramtype is array(natural range<>) of std_logic_vector(31 downto 0);
  signal ram : ramtype(0 to SIZE-1);

begin
  process(clk, rst, a)
  begin
    -- initialization
    if rst = '1' then
      -- text
      --    main:   addi $2, $0, 5      # initialize $2 = 5  0       20020005
      ram(0) <= X"20020005";
      --            addi $3, $0, 12     # initialize $3 = 12 4       2003000c
      ram(1) <= X"2003000c";
      --            addi $7, $3, -9     # initialize $7 = 3  8       2067fff7
      ram(2) <= X"2067fff7";
      --            or   $4, $7, $2     # $4 <= 3 or 5 = 7   c       00e22025
      ram(3) <= X"00e22025";
      --            and $5,  $3, $4     # $5 <= 12 and 7 = 4 10      00642824
      ram(4) <= X"00642824";
      --            add $5,  $5, $4     # $5 = 4 + 7 = 11    14      00a42820
      ram(5) <= X"00a42820";
      --            beq $5,  $7, end    # shouldnt be taken 18      10a7000a
      ram(6) <= X"10a7000a";
      --            slt $4,  $3, $4     # $4 = 12 < 7 = 0    1c      0064202a
      ram(7) <= X"0064202a";
      --            beq $4,  $0, around # should be taken    20      10800001
      ram(8) <= X"10800001";
      --            addi $5, $0, 0      # shouldnt happen   24      20050000
      ram(9) <= X"20050000";
      --    around: slt $4,  $7, $2     # $4 = 3 < 5 = 1     28      00e2202a
      ram(10) <= X"00e2202a";
      --            add $7,  $4, $5     # $7 = 1 + 11 = 12   2c      00853820
      ram(11) <= X"00853820";
      --            sub $7,  $7, $2     # $7 = 12 - 5 = 7    30      00e23822
      ram(12) <= X"00e23822";
      --            sw   $7, 68($3)     # [80] = 7           34      ac670044
      ram(13) <= X"ac670044";
      --            lw   $2, 80($0)     # $2 = [80] = 7      38      8c020050
      ram(14) <= X"8c020050";
      --            j    end            # should be taken    3c      08000011
      ram(15) <= X"08000011";
      --            addi $2, $0, 1      # shouldnt happen   40      20020001
      ram(16) <= X"20020001";
      --    end:    sw   $2, 84($0)     # write adr 84 = 7   44      ac020054
      ram(17) <= X"ac020054";

      -- initialize with zeros
      ram(18 to SIZE-2) <= (others => (others => '0'));
    -- write
    elsif rising_edge(clk) then
      if we = '1' then
        if not is_X(a) then
          ram(to_integer(unsigned(a))) <= wd;
        end if;
      end if;
    end if;
  end process;

  process(clk, rst, a, we)
  begin
    -- read
    if is_X(a) then
      rd <= (others => '0');
    else
      rd <= ram(to_integer(unsigned(a)));
    end if;
  end process;
end architecture;

