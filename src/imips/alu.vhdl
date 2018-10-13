library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
  port (
    a, b : in std_logic_vector(31 downto 0);
    f : in std_logic_vector(2 downto 0);
    y : out std_logic_vector(31 downto 0);
    -- if negative or not
    sgn : out std_logic;
       );
end entity;

architecture behavior of alu is
begin
  process(a, b, f)
    variable tmp : std_logic_vector(31 downto 0);
  begin
    case f is
      when "000" => y <= a and b;
      when "001" => y <= a or b;
      when "010" => y <= std_logic_vector(signed(a) + signed(b));
      when "100" => y <= a and (not b);
      when "101" => y <= a or (not b);
      when "110" => y <= std_logic_vector(signed(a) - signed(b));
      when "111" =>
        -- when concurrent assignment(<=), error
        tmp := std_logic_vector(signed(a) - signed(b));
        sgn <= tmp(31);
        y <= tmp;
      when others => y <= (others => '-');
    end case;
  end process;
end architecture;
