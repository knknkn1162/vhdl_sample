library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_sample is
  port (
    clk, rst : in std_logic;
    a : in std_logic;
    b, c : out std_logic
  );
end entity;


architecture behavior of fsm_sample is
  type statetype is (S0, S1, S2);
  signal state, nextstate: statetype;
begin
  process(clk, rst)
  begin
    if rst = '1' then
      state <= S0;
    elsif rising_edge(clk) then
      state <= nextstate;
    end if;
  end process;

  process(clk, rst, a)
  begin
    case state is
      when S0 =>
        if a = '1' then
          nextstate <= S1;
        else
          nextstate <= S2;
        end if;
      when S1|S2 =>
          nextState <= S0;
    end case;
  end process;

  -- sensitivity list is state
  process(state)
    variable b0, c0 : std_logic;
  begin
    -- default
    b0 := '0';
    c0 := '0';
    case state is
      when S0 =>
        -- do nothing
      when S1 =>
        b0 := '1';
      when S2 =>
        c0 := '1';
      when others =>
        -- do nothing
    end case;
    b <= b0;
    c <= c0;
  end process;
end architecture;
