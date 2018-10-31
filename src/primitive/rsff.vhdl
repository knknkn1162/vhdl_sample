library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rsff is
  port (
    set, reset : in std_logic;
    q : out std_logic;
    qbar : out std_logic
  );
end entity;

architecture behavior of rsff is
  signal q0, qbar0 : std_logic;
begin
  q0 <= reset nor qbar0;
  qbar0 <= set nor q0;
  q <= q0;
  qbar <= qbar0;
end architecture;
