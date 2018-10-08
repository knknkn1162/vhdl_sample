library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram is
  port (
    datain : in std_logic_vector(7 downto 0);
    address : in std_logic_vector(7 downto 0);
    w_r : in std_logic;
    dataout : out std_logic_vector(7 downto 0)
  );
end entity;

architecture behavior of ram is
  type mem is array(255 downto 0) of std_logic_vector(7 downto 0);
  signal memory : mem;
  signal addr : integer range 0 to 255;
  begin
  process(address, datain, w_r) begin
    addr <= to_integer(unsigned(address));
    if(w_r='0') then
      memory(addr) <= datain;
    elsif(w_r='1') then
      dataout <= memory(addr);
    else
      dataout <= "ZZZZZZZZ";
    end if;
  end process;
end architecture;
