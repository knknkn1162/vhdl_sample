library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity smile_moore is
  port (
    clk, reset : in std_logic;
    a : in std_logic;
    y : out std_logic
       );
end entity;

architecture behavior of smile_moore is
  type statetype is (S0, S1, S2);
  signal state, nextstate: statetype;

begin
  process(clk, reset) begin
    if reset='1' then state <= S0;
    elsif rising_edge(clk) then state <= nextstate;
    end if;
  end process;

  process(clk, reset, a) begin
    case state is
      when S0 =>
        if a='1' then nextstate <= S0;
        else nextstate <= S1;
        end if;
      when S1 =>
        if a='1' then nextstate <= S2;
        else nextstate <= S1;
        end if;
      when S2 =>
        if a='1' then nextstate <= S0;
        else nextstate <= S1;
        end if;
    end case;
  end process;
  y <= '1' when state = S2 else '0';
end architecture;
