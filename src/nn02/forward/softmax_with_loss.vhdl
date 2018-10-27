library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity softmax_with_loss is
  generic(N: natural);
  port (
    -- [-(2**23)/2**13, (2**23-1)/2**13)
    a : in aarr_type(0 to N-1);
    -- [0, (2**8-1)/2**8]
    z : out arr_type(0 to N-1)
  );
end entity;

architecture behavior of softmax_with_loss is
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

  -- [0, inf) -> [256/256, inf)
  function log(a: natural) return natural is
    variable b : natural;
  begin
    if a = 0 then b := 256;
    elsif (a >= 0 and a < 2) then b := 177;
    elsif (a >= 2 and a < 4) then b := 355;
    elsif (a >= 4 and a < 6) then b := 459;
    elsif (a >= 6 and a < 8) then b := 532;
    elsif (a >= 8 and a < 10) then b := 589;
    elsif (a >= 10 and a < 12) then b := 636;
    elsif (a >= 12 and a < 14) then b := 676;
    elsif (a >= 14 and a < 16) then b := 710;
    elsif (a >= 16 and a < 18) then b := 740;
    elsif (a >= 18 and a < 20) then b := 767;
    elsif (a >= 20 and a < 22) then b := 791;
    elsif (a >= 22 and a < 24) then b := 814;
    elsif (a >= 24 and a < 26) then b := 834;
    elsif (a >= 26 and a < 28) then b := 853;
    elsif (a >= 28 and a < 30) then b := 871;
    elsif (a >= 30 and a < 32) then b := 887;
    elsif (a >= 32 and a < 34) then b := 903;
    elsif (a >= 34 and a < 36) then b := 917;
    elsif (a >= 36 and a < 38) then b := 931;
    elsif (a >= 38 and a < 40) then b := 944;
    elsif (a >= 40 and a < 42) then b := 957;
    elsif (a >= 42 and a < 44) then b := 969;
    elsif (a >= 44 and a < 46) then b := 980;
    elsif (a >= 46 and a < 48) then b := 991;
    elsif (a >= 48 and a < 50) then b := 1001;
    elsif (a >= 50 and a < 52) then b := 1012;
    elsif (a >= 52 and a < 54) then b := 1021;
    elsif (a >= 54 and a < 56) then b := 1030;
    elsif (a >= 56 and a < 58) then b := 1039;
    elsif (a >= 58 and a < 60) then b := 1048;
    elsif (a >= 60 and a < 62) then b := 1057;
    elsif (a >= 62 and a < 64) then b := 1065;
    elsif (a >= 64 and a < 66) then b := 1073;
    elsif (a >= 66 and a < 68) then b := 1080;
    elsif (a >= 68 and a < 70) then b := 1088;
    elsif (a >= 70 and a < 72) then b := 1095;
    elsif (a >= 72 and a < 74) then b := 1102;
    elsif (a >= 74 and a < 76) then b := 1109;
    elsif (a >= 76 and a < 78) then b := 1115;
    elsif (a >= 78 and a < 80) then b := 1122;
    elsif (a >= 80 and a < 82) then b := 1128;
    elsif (a >= 82 and a < 84) then b := 1134;
    elsif (a >= 84 and a < 86) then b := 1140;
    elsif (a >= 86 and a < 88) then b := 1146;
    elsif (a >= 88 and a < 90) then b := 1152;
    elsif (a >= 90 and a < 92) then b := 1158;
    elsif (a >= 92 and a < 94) then b := 1163;
    elsif (a >= 94 and a < 96) then b := 1168;
    elsif (a >= 96 and a < 98) then b := 1174;
    elsif (a >= 98 and a < 100) then b := 1179;
    elsif (a >= 100 and a < 102) then b := 1184;
    elsif (a >= 102 and a < 104) then b := 1189;
    elsif (a >= 104 and a < 106) then b := 1194;
    elsif (a >= 106 and a < 108) then b := 1199;
    elsif (a >= 108 and a < 110) then b := 1203;
    elsif (a >= 110 and a < 112) then b := 1208;
    elsif (a >= 112 and a < 114) then b := 1212;
    elsif (a >= 114 and a < 116) then b := 1217;
    elsif (a >= 116 and a < 118) then b := 1221;
    elsif (a >= 118 and a < 120) then b := 1226;
    elsif (a >= 120 and a < 122) then b := 1230;
    elsif (a >= 122 and a < 124) then b := 1234;
    elsif (a >= 124 and a < 126) then b := 1238;
    elsif (a >= 126 and a < 128) then b := 1242;
    elsif (a >= 128 and a < 130) then b := 1246;
    elsif (a >= 130 and a < 132) then b := 1250;
    elsif (a >= 132 and a < 134) then b := 1254;
    elsif (a >= 134 and a < 136) then b := 1258;
    elsif (a >= 136 and a < 138) then b := 1261;
    elsif (a >= 138 and a < 140) then b := 1265;
    elsif (a >= 140 and a < 142) then b := 1269;
    elsif (a >= 142 and a < 144) then b := 1272;
    elsif (a >= 144 and a < 146) then b := 1276;
    elsif (a >= 146 and a < 148) then b := 1279;
    elsif (a >= 148 and a < 150) then b := 1283;
    elsif (a >= 150 and a < 152) then b := 1286;
    elsif (a >= 152 and a < 154) then b := 1289;
    elsif (a >= 154 and a < 156) then b := 1293;
    elsif (a >= 156 and a < 158) then b := 1296;
    elsif (a >= 158 and a < 160) then b := 1299;
    elsif (a >= 160 and a < 162) then b := 1302;
    elsif (a >= 162 and a < 164) then b := 1306;
    elsif (a >= 164 and a < 166) then b := 1309;
    elsif (a >= 166 and a < 168) then b := 1312;
    elsif (a >= 168 and a < 170) then b := 1315;
    elsif (a >= 170 and a < 172) then b := 1318;
    elsif (a >= 172 and a < 174) then b := 1321;
    elsif (a >= 174 and a < 176) then b := 1324;
    elsif (a >= 176 and a < 178) then b := 1327;
    elsif (a >= 178 and a < 180) then b := 1329;
    elsif (a >= 180 and a < 182) then b := 1332;
    elsif (a >= 182 and a < 184) then b := 1335;
    elsif (a >= 184 and a < 186) then b := 1338;
    elsif (a >= 186 and a < 188) then b := 1341;
    elsif (a >= 188 and a < 190) then b := 1343;
    elsif (a >= 190 and a < 192) then b := 1346;
    elsif (a >= 192 and a < 194) then b := 1349;
    elsif (a >= 194 and a < 196) then b := 1351;
    elsif (a >= 196 and a < 198) then b := 1354;
    elsif (a >= 198 and a < 200) then b := 1356;
    elsif (a >= 200 and a < 202) then b := 1359;
    elsif (a >= 202 and a < 204) then b := 1361;
    elsif (a >= 204 and a < 206) then b := 1364;
    elsif (a >= 206 and a < 208) then b := 1366;
    elsif (a >= 208 and a < 210) then b := 1369;
    elsif (a >= 210 and a < 212) then b := 1371;
    elsif (a >= 212 and a < 214) then b := 1374;
    elsif (a >= 214 and a < 216) then b := 1376;
    elsif (a >= 216 and a < 218) then b := 1378;
    elsif (a >= 218 and a < 220) then b := 1381;
    elsif (a >= 220 and a < 222) then b := 1383;
    elsif (a >= 222 and a < 224) then b := 1385;
    elsif (a >= 224 and a < 226) then b := 1388;
    elsif (a >= 226 and a < 228) then b := 1390;
    elsif (a >= 228 and a < 230) then b := 1392;
    elsif (a >= 230 and a < 232) then b := 1394;
    elsif (a >= 232 and a < 234) then b := 1397;
    elsif (a >= 234 and a < 236) then b := 1399;
    elsif (a >= 236 and a < 238) then b := 1401;
    elsif (a >= 238 and a < 240) then b := 1403;
    elsif (a >= 240 and a < 242) then b := 1405;
    elsif (a >= 242 and a < 244) then b := 1407;
    elsif (a >= 244 and a < 246) then b := 1409;
    elsif (a >= 246 and a < 248) then b := 1411;
    elsif (a >= 248 and a < 250) then b := 1413;
    elsif (a >= 250 and a < 252) then b := 1416;
    elsif (a >= 252 and a < 254) then b := 1418;
    else b := 1420;
    end if;
    return b;
  end function;

begin
  process(a)
    variable num : narr_type(0 to N-1);
    variable amin : integer;
    variable b : aarr_type(0 to N-1);
    variable sum : natural;
    variable logsum : natural;
  begin
    sum := 0;
    if is_X(a(0)) then
      z <= (others => (others => '-'));
    else
      -- calc min of a
      amin := min(a);
      for i in 0 to N-1 loop
        num(i) := to_integer(signed(a(i))-amin);
        b(i) := std_logic_vector(to_unsigned(conv(num(i)), ASIZE));
        sum := sum + to_integer(unsigned(b(i)));
        num(i) := slt2(std_logic_vector(to_unsigned(num(i), ASIZE)), WSIZE-1);
      end loop;

      -- denominator of z is 256=2**8, so the sum is multiplied in advance
      sum := slt2(std_logic_vector(to_unsigned(sum, ASIZE)), SIZE);
      logsum := log(sum);
      -- logsum
      for i in 0 to N-1 loop
        num(i) := logsum - num(i);
        z(i) <= std_logic_vector(to_unsigned(logsum-num(i), SIZE));
      end loop;
    end if;
  end process;
end architecture;
