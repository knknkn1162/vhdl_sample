library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imem is
  port (
    -- pc(7 downto 2)
    idx : in std_logic_vector(5 downto 0);
    rd : out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of imem is
  constant N : integer := 6;
  type ramtype is array (2**N-1 downto 0) of std_logic_vector(31 downto 0);
  signal mem : ramtype;
  signal is_init : std_logic := '1';
begin
  -- initialization (write instruction into mem)
  process(is_init) begin
    if is_init='1' then
      for i in 0 to 63 loop
        mem(i) <= (others => '0');
      end loop;
--    main:   addi $2, $0, 5      # initialize $2 = 5  0       20020005
      mem(0) <= X"20020005";
--            addi $3, $0, 12     # initialize $3 = 12 4       2003000c
      mem(1) <= X"2003000c";
--            addi $7, $3, -9     # initialize $7 = 3  8       2067fff7 
      mem(2) <= X"2067fff7";
--            or   $4, $7, $2     # $4 <= 3 or 5 = 7   c       00e22025
      mem(3) <= X"00e22025";
--            and $5,  $3, $4     # $5 <= 12 and 7 = 4 10      00642824
      mem(4) <= X"00642824";
--            add $5,  $5, $4     # $5 = 4 + 7 = 11    14      00a42820
      mem(5) <= X"00a42820";
--            beq $5,  $7, end    # shouldnt be taken 18      10a7000a
      mem(6) <= X"10a7000a";
--            slt $4,  $3, $4     # $4 = 12 < 7 = 0    1c      0064202a
      mem(7) <= X"0064202a";
--            beq $4,  $0, around # should be taken    20      10800001
      mem(8) <= X"10800001";
--            addi $5, $0, 0      # shouldnt happen   24      20050000
      mem(9) <= X"20050000";
--    around: slt $4,  $7, $2     # $4 = 3 < 5 = 1     28      00e2202a
      mem(10) <= X"00e2202a";
--            add $7,  $4, $5     # $7 = 1 + 11 = 12   2c      00853820
      mem(11) <= X"00853820";
--            sub $7,  $7, $2     # $7 = 12 - 5 = 7    30      00e23822
      mem(12) <= X"00e23822";
--            sw   $7, 68($3)     # [80] = 7           34      ac670044
      mem(13) <= X"ac670044";
--            lw   $2, 80($0)     # $2 = [80] = 7      38      8c020050
      mem(14) <= X"8c020050";
--            j    end            # should be taken    3c      08000011
      mem(15) <= X"08000011";
--            addi $2, $0, 1      # shouldnt happen   40      20020001
      mem(16) <= X"20020001";
--    end:    sw   $2, 84($0)     # write adr 84 = 7   44      ac020054
      mem(17) <= X"ac020054";
    end if;
    is_init <= '0';
  end process;

  process(idx) begin
    if is_init = '0' then
      -- read memory
      if Is_X(idx) then
        rd <= (others => '0');
      else
        rd <= mem(to_integer(unsigned(idx)));
      end if;
    end if;
  end process;
end architecture;
