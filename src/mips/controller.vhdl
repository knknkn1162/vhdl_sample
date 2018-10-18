library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
  port (
    opcode : in std_logic_vector(5 downto 0);
    funct : in std_logic_vector(5 downto 0);
    -- write enable
    reg_we3, dmem_we : out std_logic;
    -- multiplex selector
    rt_rd_s, rt_imm_s, calc_rdata_s : out std_logic;
    -- alu
    alu_func : out std_logic_vector(2 downto 0);
    -- branch
    is_branch, is_jmp : out std_logic
    -- jump, branch
    -- pcn4_br_s, pcn_jmp_s : in std_logic;
  );
end entity;

architecture behavior of controller is
begin
  -- -- TODO: impl controllers
  -- reg_we3(sw, beq or not)
  -- rt_rd_s(I-type or R-type)
  -- rt_imm_s(lw, sw or others)
  -- dmem_we(sw or not)
  -- alu_func(when R-type, other instruction is +)
  -- calc_rdata_s(lw or others)
  process(opcode, funct)
    -- default
    variable calc_rdata_s_v : std_logic := '0';
    variable is_branch_v : std_logic := '0';
    variable is_jmp_v : std_logic := '0';
  begin
    case opcode is
      -- R-type
      when "000000" =>
        reg_we3 <= '1';
        rt_rd_s <= '1';
        rt_imm_s <= '0';
        dmem_we <= '0';
        -- funct
        case funct is
          -- sll(0x00)
          -- when "000000" =>
          -- srl(0x02)
          -- when "000010" =>
          -- sra(0x03)
          -- when "000011" =>
          -- add(0x20)
          when "100000" =>
            alu_func <= "010";
          -- and(0x24)
          when "100100" =>
            alu_func <= "000";
          -- sub(0x22)
          when "100010" =>
            alu_func <= "110";
          -- or(0x25)
          when "100101" =>
            alu_func <= "001";
          -- slt(0x2A)
          when "101010" =>
            alu_func <= "111";
          when others =>
        end case;
      -- j(0x02)
      when "000010" =>
        is_jmp_v := '1';
      -- jal(0x03)
      -- when "000011" =>
      -- I-type
      -- branch
      -- beq(0x04)
      when "000100" =>
        rt_imm_s <= '0';
        is_branch_v := '1';
      -- bne(0x05)
      -- when "000101" =>
      --   reg_we3 <= '0';
      --   rt_rd_s <= '0';
      --   rt_imm_s <= '1';
      --   dmem_we <= '1';
      --   is_branch_v := '1';
      -- blez(0x06)
      -- when "000110" =>
      -- addi(0x08)
      when "001000" =>
        reg_we3 <= '1';
        rt_rd_s <= '0';
        rt_imm_s <= '1';
        dmem_we <= '0';
        alu_func <= "010";
      -- slti(0x0A)
      -- when "001010" =>
      -- andi(0x0C)
      when "001100" =>
        reg_we3 <= '1';
        rt_rd_s <= '0';
        rt_imm_s <= '1';
        dmem_we <= '0';
        alu_func <= "000";
      -- ori(0x0D)
      when "001101" =>
        reg_we3 <= '1';
        rt_rd_s <= '0';
        rt_imm_s <= '1';
        dmem_we <= '0';
        alu_func <= "001";
      -- lw(0x23)
      when "100011" =>
        calc_rdata_s_v := '1';
      -- sw(0x2B)
      when "101011" =>
        reg_we3 <= '0';
        rt_rd_s <= '0';
        rt_imm_s <= '1';
        dmem_we <= '1';
        alu_func <= "010";
      when others =>
    end case;
    calc_rdata_s <= calc_rdata_s_v;
    is_branch <= is_branch_v;
    is_jmp <= is_jmp_v;
  end process;
end architecture;
