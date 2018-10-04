library IEEE;
use IEEE.STd_LOGIC_1164.ALL;

entity led_tb is
end led_tb;

architecture behavior of led_tb is
  component led is
    Port (switch0 : in STD_LOGIC;
          switch1 : in STD_LOGIC;
          led0 : out STD_LOGIC;
          -- must not have semicolon
          led1 : out STD_LOGIC
    );
  end component;

  signal switch0 : STD_LOGIC := '0';
  signal switch1 : STD_LOGIC := '0';

  signal led0 : STD_LOGIC;
  signal led1 : STD_LOGIC;

begin
  uut: led port map (
    switch0 => switch0,
    switch1 => switch1,
    led0 => led0,
    led1 => led1
  );

  stim_proc: process
  begin
    wait for 100 ns;
    -- initialize input
    switch0 <= '0';
    switch1 <= '0';
    wait for 10 ns;
    switch0 <= '1';
    switch1 <= '0';
    wait for 10 ns;
    switch0 <= '0';
    switch1 <= '1';
    wait for 10 ns;
    switch0 <= '1';
    switch1 <= '1';
    wait for 10 ns;

    wait;
  end process;
end;
