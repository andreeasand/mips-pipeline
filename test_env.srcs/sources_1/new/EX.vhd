----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 12:25:20 PM
-- Design Name: 
-- Module Name: EX_Unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
    Port ( NextInstr: in std_logic_vector(15 downto 0);
    RD1: in std_logic_vector(15 downto 0);
    RD2: in std_logic_vector(15 downto 0);
    Ext_Imm: in std_logic_vector(15 downto 0);
    ALUSrc: in std_logic;
    sa: in std_logic;
    func: in std_logic_vector(2 downto 0);
    ALUOp: in std_logic_vector(2 downto 0);
    zero: out std_logic;
    BranchAddress: out std_logic_vector(15 downto 0);
    ALURes: out std_logic_vector(15 downto 0);
    rt: in std_logic_vector(2 downto 0);
    rd: in std_logic_vector(2 downto 0);
    wa: out std_logic_vector(2 downto 0);
    RegDst: in std_logic);
end EX;

architecture Behavioral of EX is

signal ALUIn1, ALUIn2, ALUResAux: std_logic_Vector(15 downto 0);
signal ALUCtrl: std_logic_vector(2 downto 0);

begin

    with ALUSrc select
        ALUIn2 <= RD2 when '0',
               Ext_Imm when '1',
               (others => '0') when others;
    
    --ALU Control
    process(ALUOp, func)
    begin
       case ALUOp is -- R TYPE INSTRUCTIONS
            when "000" =>
                case func is
                    when "000" => ALUCtrl <= "000"; -- ADD
                    when "001" => ALUCtrl <= "001"; -- SUB
                    when "010" => ALUCtrl <= "010"; -- SLL
                    when "011" => ALUCtrl <= "011"; -- SRL
                    when "100" => ALUCtrl <= "100"; -- AND
                    when "101" => ALUCtrl <= "101"; -- OR
                    when "111" => ALUCtrl <= "111"; -- XOR
                    when "110" => ALUCtrl <= "110"; -- SLT
                    when others => ALUCtrl <= (others => '0'); -- unknown
                end case;
           when "001" => ALUCtrl <= "000"; -- +
           when "010" => ALUCtrl <= "001"; -- -
           when others => ALUCtrl <= (others => '0'); -- unknown
       end case;
    end process;
    
    
    -- ALU
    process(ALUCtrl, RD1, ALUIn2, sa, ALUResAux)
    begin
        case ALUCtrl is
            when "000" => -- ADD
                ALUResAux <= RD1 + ALUIn2;
            when "001" => -- SUB
                ALUResAux <= RD1 - ALUIn2;
            when "010" => -- SLL
                case sa is
                    when '1' => ALUResAux <= ALUIn2(14 downto 0) & "0";
                    when '0' => ALUResAux <= ALUIn2;
                    when others => ALUResAux <= (others => '0');
                end case;
            when "011" => -- SRL
                case sa is
                    when '1' => ALUResAux <= "0" & ALUIn2(15 downto 1);
                    when '0' => ALUResAux <= ALUIn2;
                    when others => ALUResAux <= (others => '0');
                end case;
            when "100" => -- AND
                ALUResAux <= RD1 and ALUIn2;
            when "101" => -- OR
                ALUResAux <= RD1 or ALUIn2;
            when "111" => -- XOR
                ALUResAux <= RD1 xor ALUIn2;
            when "110" => -- SLT
                if signed(RD1) < signed(ALUIn2) then
                    ALUResAux <= x"0001";
                else
                    ALUResAux <= x"0000";
                end if;
            when others => -- unknown
                ALUResAux <= (others => '0');    
        end case;
        
        case ALUResAux is
            when x"0000" => zero <= '1';
            when others => zero <= '0';
        end case; 
    end process;
    
    ALURes <= ALUResAux;
    BranchAddress <= NextInstr + Ext_Imm;
    wa <= rt when RegDst = '0' else rd;
end Behavioral;
