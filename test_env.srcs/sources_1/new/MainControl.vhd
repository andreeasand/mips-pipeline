----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2022 03:40:10 PM
-- Design Name: 
-- Module Name: UC_Unit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MainControl is
    Port(
    Instr: in std_logic_vector(2 downto 0);
    RegDst: out std_logic;
    ExtOp: out std_logic;
    ALUSrc: out std_logic;
    BranchOnEqual: out std_logic;
    BranchOnNotEqual: out std_logic;
    Jump: out std_logic;
    ALUOp: out std_logic_vector(2 downto 0);
    MemWrite: out std_logic;
    MemToReg: out std_logic;
    RegWrite: out std_logic);
end MainControl;

architecture Behavioral of MainControl is

begin

    process(Instr)
    begin
        RegDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        BranchOnEqual <= '0';
        BranchOnNotEqual <= '0';
        --BranchGTZ <= '0';
        Jump <= '0';
        ALUOp <= "000";
        MemWrite <= '0';
        MemToReg <= '0';
        RegWrite <= '0';
        case Instr is
            when "000" => -- R TYPE INSTRUCTIONS
                RegDst <= '1';
                RegWrite <= '1';
                ALUOp <= "000";
            when "111" => -- ADDI
                RegWrite <= '1';
                ALUSrc <= '1';
                ExtOp <= '1';
                ALUOp <= "001";
            when "110" => -- LW
                RegWrite <= '1';
                ALUSrc <= '1';
                ExtOp <= '1';
                MemToReg <= '1';
                ALUOp <= "001";
            when "101" => -- SW
                ALUSrc <= '1';
                ExtOp <= '1';
                MemWrite <= '1';
                ALUOp <= "001";
            when "100" => -- BEQ
                ExtOp <= '1';
                BranchOnEqual <= '1';
                ALUOp <= "010";
            when "010" => -- BGEZ
                ExtOp <= '1';
               -- BranchGTZ <= '1';
                ALUOp <= "011";
            when "011" => -- BNEQ
                ExtOp <= '1';
                BranchOnNotEqual <= '1';
                ALUOp <= "010";
            when "001" => -- J
                Jump <= '1';
            when others =>
                RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0';
                --BranchOnEqual <= '0'; BranchOnNotEqual <= '0'; BranchGTZ <= '0';
                Jump <= '0'; MemWrite <= '0'; MemToReg <= '0'; RegWrite <= '0';
                ALUOp <= "000";
        end case;
    end process;

end Behavioral;
