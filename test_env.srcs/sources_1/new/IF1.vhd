----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2022 04:07:28 PM
-- Design Name: 
-- Module Name: IF_Unity - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IF1 is
    Port (Instruction: out std_logic_vector(15 downto 0);
    NextInstruction: out std_logic_vector(15 downto 0);
    Jump: in std_logic;
    PCSrc: in std_logic;
    clk: in std_logic;
    enable: in std_logic;
    reset: in std_logic;
    JumpAddress: in std_logic_vector(15 downto 0);
    BranchAddress: in std_logic_vector(15 downto 0));
end IF1;

architecture Behavioral of IF1 is

signal PC: std_logic_vector(15 downto 0) := (others => '0');
signal PCAux, NextAddr, AuxSgn, AuxSgn1: std_logic_vector(15 downto 0);
    
type Memory_Rom is array(0 to 255) of std_logic_vector(15 downto 0);
signal ROM: Memory_Rom := (
--3&6 + 4|7
--b"111_000_001_0000011", --addi $1,$0,3
--b"111_000_001_0000110", --addi $2,$0,6
--b"000_001_010_011_0_100", --and $3,$1,$2
--b"111_000_100_0000100", --addi $4,$0,4
--b"111_000_101_0000111", --addi $5,$0,7
--b"000_100_101_110_0_101", --or $6, $4, $5
--b"000_011_110_111_0_000", --add $7,$3,$6

--addi $3,$0,4
--b"111_000_011_0000100",

--add $2, $0, $0   //suma=0
b"000_000_000_010_0_000",
--addi $3,$0,1    //nr(putere 2)=1
b"111_000_011_0000001",
--lw $4 1($0)     //pozititie inceput mem(poz1)->4
b"110_000_100_0000001",

B"000_000_000_000_0_000", -- x"0000" --                     nop 

--lw $5,2($0)     //pozitie finala
b"110_000_101_0000010",
----------------------------------------verif poz initiala=para
--addi $6,$4,0   //poz inceput => $6
b"111_100_110_0000000",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--srl $6,$6
b"000_110_110_110_0_011",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--sll $6,$6,0
b"000_110_110_110_0_010",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--beq $6,$4,9
b"100_110_100_0001001",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--addi $4,$4,1
b"111_100_100_0000001",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

---------------------------------- $3= 2^ $4
--add $6,$0,$0
b"000_000_000_110_0_000",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--beq $6,$4,14
b"100_110_100_0001110",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--addi $6,$6,1
b"111_110_110_0000001",
--sll $3,$3,0
b"000_011_011_011_0_010",
--j 10
b"001_0000000001010",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

------------------------------------ suma numerelor pare
--sub $6,$5,$4
b"000_101_100_110_0_001",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--bgez $6,20  //cat timp($6 <= 0)
b"010_110_001_0010100",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--addi $4,$4,2   //i=i+2
b"111_100_100_0000010",
--sll $3,$3,0    //$3=$3*4
b"000_011_011_011_0_010",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 
B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--add $2,$2,$3   //s=s+$3
b"000_010_011_010_0_000",
--j 14
b"001_0000000001110",

B"000_000_000_000_0_000", -- x"0000" --  6.                   nop 

--sw $2,2($0)  //suma => mem(poz2)
b"101_000_010_0000010",
others => x"0000");

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                PC <= (others => '0');
            elsif enable = '1' then
                PC <= NextAddr;
            end if;
        end if;
    end process;
    
    Instruction <= ROM(conv_integer(PC(7 downto 0)));
    
    PCAux <= PC + 1;
    NextInstruction <= PCAux;
    
    -- MUX Branch
    process(PCSrc, PCAux, BranchAddress)
    begin
        case PCSrc is
            when '1' => AuxSgn <= BranchAddress;
            when others => AuxSgn <= PCAux;
        end case;
    end process;
    
    -- MUX Jump
    process(Jump, AuxSgn, JumpAddress)
    begin
        case Jump is
            when '1' => NextAddr <= JumpAddress;
            when others => NextAddr <= AuxSgn;
        end case;
    end process;
end Behavioral;
