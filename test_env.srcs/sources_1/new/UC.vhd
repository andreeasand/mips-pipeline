----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2022 16:59:24
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
--  Port ( );
Port ( 
    Instr : in std_logic_vector(15 downto 13);
    RegDst : out std_logic;    
    ExtOp : out std_logic;    
    ALUSrc : out std_logic;    
    Branch : out std_logic;    
    Jump : out std_logic;    
    ALUOp : out std_logic_vector(2 downto 0);    
    MemWrite : out std_logic;    
    MemToReg : out std_logic;    
    RegWrite : out std_logic;    
    BranchNE : out std_logic ;
    BranchGTZ: out std_logic
    );
end UC;

architecture Behavioral of UC is

begin
    process(Instr) 
    begin
        RegDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        Jump <= '0';
        ALUOp <= "000";
        MemWrite <= '0';
        MemToReg <= '0';
        RegWrite <= '0';
        BranchNE <= '0';
        BranchGTZ<='0';
        case Instr is
            when "000" => 
                RegDst <= '1'; 
                RegWrite <= '1';
                ALUOp<="000";
            when "001" => 
                Jump<='1';
            when "010" =>
                ExtOp <= '1';
                BranchGTZ<='1';
                ALUOp <= "001";
            when "011" =>
                ExtOp <= '1';
                BranchNE<='1';
                ALUOp <= "001"; 
            when "100" =>
                 ExtOp<='1';
                Branch <= '1';
                ALUOp <= "001";
            when "101" =>
                ALUSrc<='1';
                ExtOp<='1';
                ALUOp <= "010";
            when "110" =>
                ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
                MemToReg<='1';
                ALUOp <= "010";
            when "111" =>
                RegWrite <= '1';
                ALUSrc<='1';
                ExtOp<='1';
                ALUOp<="010";                      
        end case;
    end process;


end Behavioral;
