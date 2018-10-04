library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led is
  Port (switch0 : in STD_LOGIC;
        switch1 : in STD_LOGIC;
        led0 : out STD_LOGIC;
        -- must not have semicolon
        led1 : out STD_LOGIC
  );
end led;

architecture Behavioral of led is
begin
  led0 <= switch0;
  led1 <= switch1;
end;
