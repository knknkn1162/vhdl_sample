library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seven_seg_decoder is
  port (
    data : in std_logic_vector(3 downto 0);
    segments : out std_logic_vector(6 downto 0)
       );
end entity;

architecture synth of seven_seg_decoder is
begin
process(data) begin
  case data is
    when X"0" => segments <= "1111110";
    when X"1" => segments <= "0110000";
    when X"2" => segments <= "1101101";
    when X"3" => segments <= "1111001";
    when X"4" => segments <= "0110011";
    when X"5" => segments <= "1011011";
    when X"6" => segments <= "1011111";
    when X"7" => segments <= "1110000";
    when X"8" => segments <= "1111111";
    when X"9" => segments <= "1110011";
    when others => segments <= "0000000";
  end case;
end process;
end architecture;
