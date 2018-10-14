library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity regfile is
  port (
    clk : in std_logic;
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
end entity;

architecture behavior of regfile is
  -- $0($zero) ~ $31($ra)
  type ramtype is array (31 downto 0) of std_logic_vector(31 downto 0);
  signal mem : ramtype := (others => (others => '0'));
begin
  process(clk) begin
    if rising_edge(clk) then
      -- if write enables
      if we3='1' then
        -- avoid $zero register
        if a3/="00000" then
          if not is_X(a3) then
            mem(to_integer(unsigned(a3))) <= wd3;
          end if;
        end if;
      end if;
    end if;
  end process;

  process(a1) begin
    if not is_X(a1) then
      rd1 <= mem(to_integer(unsigned(a1)));
    end if;
  end process;

  process(a2) begin
    if not is_X(a2) then
      rd2 <= mem(to_integer(unsigned(a2)));
    end if;
  end process;
end architecture;
