library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led is
  Port (switch1 : in STD_LOGIC;
        switch2 : in STD_LOGIC;
        led1 : out STD_LOGIC;
        -- must not have semicolon
        led2 : out STD_LOGIC
  );
end led;

architecture Behavioral of led is
begin
  led1 <= switch1;
  led2 <= switch2;
end Behavioral;
