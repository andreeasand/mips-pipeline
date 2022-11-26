----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2022 02:48:58 PM
-- Design Name: 
-- Module Name: Memory_Unit - Behavioral
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

entity MEM is
    Port ( ALUResIn : in STD_LOGIC_VECTOR (15 downto 0);
    RD2: in std_logic_vector(15 downto 0);
    MemWrite: in std_logic;
    en: in std_logic;
    clk: in std_logic;
    ALUResOut: out std_logic_vector(15 downto 0);
    MemData: out std_logic_vector(15 downto 0));
end MEM;

architecture Behavioral of MEM is
type ram_type is array(0 to 31) of std_logic_vector(15 downto 0);
signal RAM: ram_type := (
    x"0001",
    x"0002",
    x"0003",
    x"0004",
    x"0005",
    x"0006",
    x"0007",
    x"0008",
    others => x"0000");

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                if en = '1' then
                    RAM(conv_integer(ALUResIn(4 downto 0))) <= rd2;
                end if;
            end if;
        end if;
    end process;

    MemData <= RAM(conv_integer(ALUResIn(4 downto 0)));
    ALUResOut <= ALUResIn;
end Behavioral;
