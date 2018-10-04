library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity when_else is
  port (
    A : in std_logic;
    B : in std_logic;
    C : in std_logic;
    assign_A : in std_logic;
    assign_B : in std_logic;
    Z : out std_logic
       );
end when_else;

architecture Behavioral of when_else is
begin
  Z <= A when assign_A = '1' else
       B when assign_B = '1' else
       C;
end Behavioral;
