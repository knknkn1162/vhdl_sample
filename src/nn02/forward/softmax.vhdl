library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity softmax is
  generic(N: natural);
  port (
    -- [-(2**23)/2**13, (2**23-1)/2**13)
    a : in aarr_type(0 to N-1);
    -- [0, (2**8-1)/2**8]
    z : out arr_type(0 to N-1)
  );
end entity;

architecture behavior of softmax is
  function conv(a : natural) return natural is
    variable b : natural range 0 to 2**ASIZE-1;
  begin
  if a = 0 then b := 256;
  elsif (a >= 0 and a < 64) then b := 258;
  elsif (a >= 64 and a < 576) then b := 275;
  elsif (a >= 576 and a < 1088) then b := 292;
  elsif (a >= 1088 and a < 1600) then b := 311;
  elsif (a >= 1600 and a < 2112) then b := 331;
  elsif (a >= 2112 and a < 2624) then b := 353;
  elsif (a >= 2624 and a < 3136) then b := 375;
  elsif (a >= 3136 and a < 3648) then b := 400;
  elsif (a >= 3648 and a < 4160) then b := 425;
  elsif (a >= 4160 and a < 4672) then b := 453;
  elsif (a >= 4672 and a < 5184) then b := 482;
  elsif (a >= 5184 and a < 5696) then b := 513;
  elsif (a >= 5696 and a < 6208) then b := 546;
  elsif (a >= 6208 and a < 6720) then b := 581;
  elsif (a >= 6720 and a < 7232) then b := 619;
  elsif (a >= 7232 and a < 7744) then b := 659;
  elsif (a >= 7744 and a < 8256) then b := 701;
  elsif (a >= 8256 and a < 8768) then b := 747;
  elsif (a >= 8768 and a < 9280) then b := 795;
  elsif (a >= 9280 and a < 9792) then b := 846;
  elsif (a >= 9792 and a < 10304) then b := 901;
  elsif (a >= 10304 and a < 10816) then b := 959;
  elsif (a >= 10816 and a < 11328) then b := 1020;
  elsif (a >= 11328 and a < 11840) then b := 1086;
  elsif (a >= 11840 and a < 12352) then b := 1156;
  elsif (a >= 12352 and a < 12864) then b := 1231;
  elsif (a >= 12864 and a < 13376) then b := 1310;
  elsif (a >= 13376 and a < 13888) then b := 1395;
  elsif (a >= 13888 and a < 14400) then b := 1485;
  elsif (a >= 14400 and a < 14912) then b := 1580;
  elsif (a >= 14912 and a < 15424) then b := 1682;
  elsif (a >= 15424 and a < 15936) then b := 1791;
  elsif (a >= 15936 and a < 16448) then b := 1906;
  elsif (a >= 16448 and a < 16960) then b := 2029;
  elsif (a >= 16960 and a < 17472) then b := 2160;
  elsif (a >= 17472 and a < 17984) then b := 2300;
  elsif (a >= 17984 and a < 18496) then b := 2448;
  elsif (a >= 18496 and a < 19008) then b := 2606;
  elsif (a >= 19008 and a < 19520) then b := 2774;
  elsif (a >= 19520 and a < 20032) then b := 2953;
  elsif (a >= 20032 and a < 20544) then b := 3143;
  elsif (a >= 20544 and a < 21056) then b := 3346;
  elsif (a >= 21056 and a < 21568) then b := 3562;
  elsif (a >= 21568 and a < 22080) then b := 3791;
  elsif (a >= 22080 and a < 22592) then b := 4036;
  elsif (a >= 22592 and a < 23104) then b := 4296;
  elsif (a >= 23104 and a < 23616) then b := 4573;
  elsif (a >= 23616 and a < 24128) then b := 4868;
  elsif (a >= 24128 and a < 24640) then b := 5182;
  elsif (a >= 24640 and a < 25152) then b := 5516;
  elsif (a >= 25152 and a < 25664) then b := 5872;
  elsif (a >= 25664 and a < 26176) then b := 6251;
  elsif (a >= 26176 and a < 26688) then b := 6654;
  elsif (a >= 26688 and a < 27200) then b := 7083;
  elsif (a >= 27200 and a < 27712) then b := 7540;
  elsif (a >= 27712 and a < 28224) then b := 8026;
  elsif (a >= 28224 and a < 28736) then b := 8544;
  elsif (a >= 28736 and a < 29248) then b := 9095;
  elsif (a >= 29248 and a < 29760) then b := 9682;
  elsif (a >= 29760 and a < 30272) then b := 10306;
  elsif (a >= 30272 and a < 30784) then b := 10971;
  elsif (a >= 30784 and a < 31296) then b := 11678;
  elsif (a >= 31296 and a < 31808) then b := 12432;
  elsif (a >= 31808 and a < 32320) then b := 13233;
  elsif (a >= 32320 and a < 32832) then b := 14087;
  elsif (a >= 32832 and a < 33344) then b := 14995;
  elsif (a >= 33344 and a < 33856) then b := 15962;
  elsif (a >= 33856 and a < 34368) then b := 16992;
  elsif (a >= 34368 and a < 34880) then b := 18088;
  elsif (a >= 34880 and a < 35392) then b := 19254;
  elsif (a >= 35392 and a < 35904) then b := 20496;
  elsif (a >= 35904 and a < 36416) then b := 21818;
  elsif (a >= 36416 and a < 36928) then b := 23225;
  elsif (a >= 36928 and a < 37440) then b := 24723;
  elsif (a >= 37440 and a < 37952) then b := 26318;
  elsif (a >= 37952 and a < 38464) then b := 28015;
  elsif (a >= 38464 and a < 38976) then b := 29822;
  elsif (a >= 38976 and a < 39488) then b := 31745;
  elsif (a >= 39488 and a < 40000) then b := 33792;
  elsif (a >= 40000 and a < 40512) then b := 35972;
  elsif (a >= 40512 and a < 41024) then b := 38292;
  elsif (a >= 41024 and a < 41536) then b := 40761;
  elsif (a >= 41536 and a < 42048) then b := 43390;
  elsif (a >= 42048 and a < 42560) then b := 46189;
  elsif (a >= 42560 and a < 43072) then b := 49168;
  elsif (a >= 43072 and a < 43584) then b := 52339;
  elsif (a >= 43584 and a < 44096) then b := 55714;
  elsif (a >= 44096 and a < 44608) then b := 59307;
  elsif (a >= 44608 and a < 45120) then b := 63132;
  elsif (a >= 45120 and a < 45632) then b := 67204;
  elsif (a >= 45632 and a < 46144) then b := 71538;
  elsif (a >= 46144 and a < 46656) then b := 76152;
  elsif (a >= 46656 and a < 47168) then b := 81064;
  elsif (a >= 47168 and a < 47680) then b := 86292;
  elsif (a >= 47680 and a < 48192) then b := 91857;
  elsif (a >= 48192 and a < 48704) then b := 97781;
  elsif (a >= 48704 and a < 49216) then b := 104088;
  else b := 110801;
  end if;
  return b;
  end function;

  function slt2(n: std_logic_vector; shiftn: natural) return natural is
  begin
    return to_integer(unsigned(n(n'length-1 downto shiftn)));
  end function;

  function min(a: aarr_type) return integer is
    variable amin : integer;
    variable sgn : std_logic_vector(ASIZE-1 downto 0);
  begin
    amin := to_integer(signed(a(0)));
    for i in 0 to N-1 loop
      sgn := std_logic_vector(signed(a(i)) - amin);
      if sgn(ASIZE-1)='1' then
        amin := to_integer(signed(a(i)));
      end if;
    end loop;
    return amin;
  end function;

begin
  process(a)
    variable num : natural;
    variable amin : integer;
    variable b : aarr_type(0 to N-1);
    variable sum : natural;
  begin
    sum := 0;
    if is_X(a(0)) then
      z <= (others => (others => '-'));
    else
      -- calc min of a
      amin := min(a);

      for i in 0 to N-1 loop
        num := to_integer(signed(a(i))-amin);
        b(i) := std_logic_vector(to_unsigned(conv(num), ASIZE));
        sum := sum + to_integer(unsigned(b(i)));
      end loop;


      -- denominator of z is 256, so the sum is multiplied in advance
      sum := slt2(std_logic_vector(to_unsigned(sum, ASIZE)), 8);
      for i in 0 to N-1 loop
        z(i) <= std_logic_vector(to_unsigned(to_integer(unsigned(b(i)))/sum, 8));
      end loop;
    end if;
  end process;
end architecture;
