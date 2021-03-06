library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.nn_pkg.ALL;

entity sigmoid is
  port (
    a : in std_logic_vector(ASIZE-1 downto 0);
    z : out std_logic_vector(SIZE-1 downto 0)
  );
end entity;

architecture behavior of sigmoid is
  function conv(a : integer) return natural is
    variable b : natural range 0 to 2**SIZE-1;
  begin
  if a < -45394 then b := 0;
  elsif (a >= -45394 and a < -39684) then b := 1;
  elsif (a >= -39684 and a < -36330) then b := 2;
  elsif (a >= -36330 and a < -33941) then b := 3;
  elsif (a >= -33941 and a < -32080) then b := 4;
  elsif (a >= -32080 and a < -30554) then b := 5;
  elsif (a >= -30554 and a < -29258) then b := 6;
  elsif (a >= -29258 and a < -28131) then b := 7;
  elsif (a >= -28131 and a < -27133) then b := 8;
  elsif (a >= -27133 and a < -26237) then b := 9;
  elsif (a >= -26237 and a < -25423) then b := 10;
  elsif (a >= -25423 and a < -24676) then b := 11;
  elsif (a >= -24676 and a < -23987) then b := 12;
  elsif (a >= -23987 and a < -23346) then b := 13;
  elsif (a >= -23346 and a < -22747) then b := 14;
  elsif (a >= -22747 and a < -22184) then b := 15;
  elsif (a >= -22184 and a < -21654) then b := 16;
  elsif (a >= -21654 and a < -21151) then b := 17;
  elsif (a >= -21151 and a < -20674) then b := 18;
  elsif (a >= -20674 and a < -20219) then b := 19;
  elsif (a >= -20219 and a < -19784) then b := 20;
  elsif (a >= -19784 and a < -19368) then b := 21;
  elsif (a >= -19368 and a < -18969) then b := 22;
  elsif (a >= -18969 and a < -18585) then b := 23;
  elsif (a >= -18585 and a < -18215) then b := 24;
  elsif (a >= -18215 and a < -17858) then b := 25;
  elsif (a >= -17858 and a < -17514) then b := 26;
  elsif (a >= -17514 and a < -17180) then b := 27;
  elsif (a >= -17180 and a < -16856) then b := 28;
  elsif (a >= -16856 and a < -16542) then b := 29;
  elsif (a >= -16542 and a < -16237) then b := 30;
  elsif (a >= -16237 and a < -15941) then b := 31;
  elsif (a >= -15941 and a < -15652) then b := 32;
  elsif (a >= -15652 and a < -15371) then b := 33;
  elsif (a >= -15371 and a < -15096) then b := 34;
  elsif (a >= -15096 and a < -14828) then b := 35;
  elsif (a >= -14828 and a < -14567) then b := 36;
  elsif (a >= -14567 and a < -14311) then b := 37;
  elsif (a >= -14311 and a < -14060) then b := 38;
  elsif (a >= -14060 and a < -13815) then b := 39;
  elsif (a >= -13815 and a < -13575) then b := 40;
  elsif (a >= -13575 and a < -13339) then b := 41;
  elsif (a >= -13339 and a < -13108) then b := 42;
  elsif (a >= -13108 and a < -12881) then b := 43;
  elsif (a >= -12881 and a < -12658) then b := 44;
  elsif (a >= -12658 and a < -12439) then b := 45;
  elsif (a >= -12439 and a < -12224) then b := 46;
  elsif (a >= -12224 and a < -12012) then b := 47;
  elsif (a >= -12012 and a < -11804) then b := 48;
  elsif (a >= -11804 and a < -11599) then b := 49;
  elsif (a >= -11599 and a < -11397) then b := 50;
  elsif (a >= -11397 and a < -11197) then b := 51;
  elsif (a >= -11197 and a < -11001) then b := 52;
  elsif (a >= -11001 and a < -10808) then b := 53;
  elsif (a >= -10808 and a < -10617) then b := 54;
  elsif (a >= -10617 and a < -10428) then b := 55;
  elsif (a >= -10428 and a < -10242) then b := 56;
  elsif (a >= -10242 and a < -10058) then b := 57;
  elsif (a >= -10058 and a < -9877) then b := 58;
  elsif (a >= -9877 and a < -9697) then b := 59;
  elsif (a >= -9697 and a < -9520) then b := 60;
  elsif (a >= -9520 and a < -9345) then b := 61;
  elsif (a >= -9345 and a < -9171) then b := 62;
  elsif (a >= -9171 and a < -9000) then b := 63;
  elsif (a >= -9000 and a < -8830) then b := 64;
  elsif (a >= -8830 and a < -8662) then b := 65;
  elsif (a >= -8662 and a < -8496) then b := 66;
  elsif (a >= -8496 and a < -8331) then b := 67;
  elsif (a >= -8331 and a < -8167) then b := 68;
  elsif (a >= -8167 and a < -8006) then b := 69;
  elsif (a >= -8006 and a < -7845) then b := 70;
  elsif (a >= -7845 and a < -7686) then b := 71;
  elsif (a >= -7686 and a < -7529) then b := 72;
  elsif (a >= -7529 and a < -7372) then b := 73;
  elsif (a >= -7372 and a < -7217) then b := 74;
  elsif (a >= -7217 and a < -7063) then b := 75;
  elsif (a >= -7063 and a < -6911) then b := 76;
  elsif (a >= -6911 and a < -6759) then b := 77;
  elsif (a >= -6759 and a < -6609) then b := 78;
  elsif (a >= -6609 and a < -6459) then b := 79;
  elsif (a >= -6459 and a < -6311) then b := 80;
  elsif (a >= -6311 and a < -6163) then b := 81;
  elsif (a >= -6163 and a < -6017) then b := 82;
  elsif (a >= -6017 and a < -5871) then b := 83;
  elsif (a >= -5871 and a < -5726) then b := 84;
  elsif (a >= -5726 and a < -5582) then b := 85;
  elsif (a >= -5582 and a < -5439) then b := 86;
  elsif (a >= -5439 and a < -5297) then b := 87;
  elsif (a >= -5297 and a < -5156) then b := 88;
  elsif (a >= -5156 and a < -5015) then b := 89;
  elsif (a >= -5015 and a < -4875) then b := 90;
  elsif (a >= -4875 and a < -4736) then b := 91;
  elsif (a >= -4736 and a < -4597) then b := 92;
  elsif (a >= -4597 and a < -4459) then b := 93;
  elsif (a >= -4459 and a < -4322) then b := 94;
  elsif (a >= -4322 and a < -4185) then b := 95;
  elsif (a >= -4185 and a < -4048) then b := 96;
  elsif (a >= -4048 and a < -3913) then b := 97;
  elsif (a >= -3913 and a < -3778) then b := 98;
  elsif (a >= -3778 and a < -3643) then b := 99;
  elsif (a >= -3643 and a < -3509) then b := 100;
  elsif (a >= -3509 and a < -3375) then b := 101;
  elsif (a >= -3375 and a < -3242) then b := 102;
  elsif (a >= -3242 and a < -3109) then b := 103;
  elsif (a >= -3109 and a < -2976) then b := 104;
  elsif (a >= -2976 and a < -2844) then b := 105;
  elsif (a >= -2844 and a < -2713) then b := 106;
  elsif (a >= -2713 and a < -2581) then b := 107;
  elsif (a >= -2581 and a < -2450) then b := 108;
  elsif (a >= -2450 and a < -2319) then b := 109;
  elsif (a >= -2319 and a < -2189) then b := 110;
  elsif (a >= -2189 and a < -2059) then b := 111;
  elsif (a >= -2059 and a < -1929) then b := 112;
  elsif (a >= -1929 and a < -1799) then b := 113;
  elsif (a >= -1799 and a < -1670) then b := 114;
  elsif (a >= -1670 and a < -1541) then b := 115;
  elsif (a >= -1541 and a < -1411) then b := 116;
  elsif (a >= -1411 and a < -1283) then b := 117;
  elsif (a >= -1283 and a < -1154) then b := 118;
  elsif (a >= -1154 and a < -1025) then b := 119;
  elsif (a >= -1025 and a < -897) then b := 120;
  elsif (a >= -897 and a < -769) then b := 121;
  elsif (a >= -769 and a < -640) then b := 122;
  elsif (a >= -640 and a < -512) then b := 123;
  elsif (a >= -512 and a < -384) then b := 124;
  elsif (a >= -384 and a < -256) then b := 125;
  elsif (a >= -256 and a < -128) then b := 126;
  elsif (a >= -128 and a < 0) then b := 127;
  elsif (a >= 0 and a < 128) then b := 128;
  elsif (a >= 128 and a < 256) then b := 129;
  elsif (a >= 256 and a < 384) then b := 130;
  elsif (a >= 384 and a < 512) then b := 131;
  elsif (a >= 512 and a < 640) then b := 132;
  elsif (a >= 640 and a < 769) then b := 133;
  elsif (a >= 769 and a < 897) then b := 134;
  elsif (a >= 897 and a < 1025) then b := 135;
  elsif (a >= 1025 and a < 1154) then b := 136;
  elsif (a >= 1154 and a < 1283) then b := 137;
  elsif (a >= 1283 and a < 1411) then b := 138;
  elsif (a >= 1411 and a < 1541) then b := 139;
  elsif (a >= 1541 and a < 1670) then b := 140;
  elsif (a >= 1670 and a < 1799) then b := 141;
  elsif (a >= 1799 and a < 1929) then b := 142;
  elsif (a >= 1929 and a < 2059) then b := 143;
  elsif (a >= 2059 and a < 2189) then b := 144;
  elsif (a >= 2189 and a < 2319) then b := 145;
  elsif (a >= 2319 and a < 2450) then b := 146;
  elsif (a >= 2450 and a < 2581) then b := 147;
  elsif (a >= 2581 and a < 2713) then b := 148;
  elsif (a >= 2713 and a < 2844) then b := 149;
  elsif (a >= 2844 and a < 2976) then b := 150;
  elsif (a >= 2976 and a < 3109) then b := 151;
  elsif (a >= 3109 and a < 3242) then b := 152;
  elsif (a >= 3242 and a < 3375) then b := 153;
  elsif (a >= 3375 and a < 3509) then b := 154;
  elsif (a >= 3509 and a < 3643) then b := 155;
  elsif (a >= 3643 and a < 3778) then b := 156;
  elsif (a >= 3778 and a < 3913) then b := 157;
  elsif (a >= 3913 and a < 4048) then b := 158;
  elsif (a >= 4048 and a < 4185) then b := 159;
  elsif (a >= 4185 and a < 4322) then b := 160;
  elsif (a >= 4322 and a < 4459) then b := 161;
  elsif (a >= 4459 and a < 4597) then b := 162;
  elsif (a >= 4597 and a < 4736) then b := 163;
  elsif (a >= 4736 and a < 4875) then b := 164;
  elsif (a >= 4875 and a < 5015) then b := 165;
  elsif (a >= 5015 and a < 5156) then b := 166;
  elsif (a >= 5156 and a < 5297) then b := 167;
  elsif (a >= 5297 and a < 5439) then b := 168;
  elsif (a >= 5439 and a < 5582) then b := 169;
  elsif (a >= 5582 and a < 5726) then b := 170;
  elsif (a >= 5726 and a < 5871) then b := 171;
  elsif (a >= 5871 and a < 6017) then b := 172;
  elsif (a >= 6017 and a < 6163) then b := 173;
  elsif (a >= 6163 and a < 6311) then b := 174;
  elsif (a >= 6311 and a < 6459) then b := 175;
  elsif (a >= 6459 and a < 6609) then b := 176;
  elsif (a >= 6609 and a < 6759) then b := 177;
  elsif (a >= 6759 and a < 6911) then b := 178;
  elsif (a >= 6911 and a < 7063) then b := 179;
  elsif (a >= 7063 and a < 7217) then b := 180;
  elsif (a >= 7217 and a < 7372) then b := 181;
  elsif (a >= 7372 and a < 7529) then b := 182;
  elsif (a >= 7529 and a < 7686) then b := 183;
  elsif (a >= 7686 and a < 7845) then b := 184;
  elsif (a >= 7845 and a < 8006) then b := 185;
  elsif (a >= 8006 and a < 8167) then b := 186;
  elsif (a >= 8167 and a < 8331) then b := 187;
  elsif (a >= 8331 and a < 8496) then b := 188;
  elsif (a >= 8496 and a < 8662) then b := 189;
  elsif (a >= 8662 and a < 8830) then b := 190;
  elsif (a >= 8830 and a < 9000) then b := 191;
  elsif (a >= 9000 and a < 9171) then b := 192;
  elsif (a >= 9171 and a < 9345) then b := 193;
  elsif (a >= 9345 and a < 9520) then b := 194;
  elsif (a >= 9520 and a < 9697) then b := 195;
  elsif (a >= 9697 and a < 9877) then b := 196;
  elsif (a >= 9877 and a < 10058) then b := 197;
  elsif (a >= 10058 and a < 10242) then b := 198;
  elsif (a >= 10242 and a < 10428) then b := 199;
  elsif (a >= 10428 and a < 10617) then b := 200;
  elsif (a >= 10617 and a < 10808) then b := 201;
  elsif (a >= 10808 and a < 11001) then b := 202;
  elsif (a >= 11001 and a < 11197) then b := 203;
  elsif (a >= 11197 and a < 11397) then b := 204;
  elsif (a >= 11397 and a < 11599) then b := 205;
  elsif (a >= 11599 and a < 11804) then b := 206;
  elsif (a >= 11804 and a < 12012) then b := 207;
  elsif (a >= 12012 and a < 12224) then b := 208;
  elsif (a >= 12224 and a < 12439) then b := 209;
  elsif (a >= 12439 and a < 12658) then b := 210;
  elsif (a >= 12658 and a < 12881) then b := 211;
  elsif (a >= 12881 and a < 13108) then b := 212;
  elsif (a >= 13108 and a < 13339) then b := 213;
  elsif (a >= 13339 and a < 13575) then b := 214;
  elsif (a >= 13575 and a < 13815) then b := 215;
  elsif (a >= 13815 and a < 14060) then b := 216;
  elsif (a >= 14060 and a < 14311) then b := 217;
  elsif (a >= 14311 and a < 14567) then b := 218;
  elsif (a >= 14567 and a < 14828) then b := 219;
  elsif (a >= 14828 and a < 15096) then b := 220;
  elsif (a >= 15096 and a < 15371) then b := 221;
  elsif (a >= 15371 and a < 15652) then b := 222;
  elsif (a >= 15652 and a < 15941) then b := 223;
  elsif (a >= 15941 and a < 16237) then b := 224;
  elsif (a >= 16237 and a < 16542) then b := 225;
  elsif (a >= 16542 and a < 16856) then b := 226;
  elsif (a >= 16856 and a < 17180) then b := 227;
  elsif (a >= 17180 and a < 17514) then b := 228;
  elsif (a >= 17514 and a < 17858) then b := 229;
  elsif (a >= 17858 and a < 18215) then b := 230;
  elsif (a >= 18215 and a < 18585) then b := 231;
  elsif (a >= 18585 and a < 18969) then b := 232;
  elsif (a >= 18969 and a < 19368) then b := 233;
  elsif (a >= 19368 and a < 19784) then b := 234;
  elsif (a >= 19784 and a < 20219) then b := 235;
  elsif (a >= 20219 and a < 20674) then b := 236;
  elsif (a >= 20674 and a < 21151) then b := 237;
  elsif (a >= 21151 and a < 21654) then b := 238;
  elsif (a >= 21654 and a < 22184) then b := 239;
  elsif (a >= 22184 and a < 22747) then b := 240;
  elsif (a >= 22747 and a < 23346) then b := 241;
  elsif (a >= 23346 and a < 23987) then b := 242;
  elsif (a >= 23987 and a < 24676) then b := 243;
  elsif (a >= 24676 and a < 25423) then b := 244;
  elsif (a >= 25423 and a < 26237) then b := 245;
  elsif (a >= 26237 and a < 27133) then b := 246;
  elsif (a >= 27133 and a < 28131) then b := 247;
  elsif (a >= 28131 and a < 29258) then b := 248;
  elsif (a >= 29258 and a < 30554) then b := 249;
  elsif (a >= 30554 and a < 32080) then b := 250;
  elsif (a >= 32080 and a < 33941) then b := 251;
  elsif (a >= 33941 and a < 36330) then b := 252;
  elsif (a >= 36330 and a < 39684) then b := 253;
  elsif (a >= 39684 and a < 45394) then b := 254;
  else b := 255;
  end if;
  return b;
  end function;
begin
  process(a) begin
    if is_X(a) then
      z <= (others => '-');
    else
      z <= std_logic_vector(to_unsigned(conv(to_integer(signed(a))), SIZE));
    end if;
  end process;
end architecture;
