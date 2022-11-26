----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.03.2022 22:20:35
-- Design Name: 
-- Module Name: rom - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom is
Port ( 
        clk : in std_logic;
        btn : in STD_LOGIC_VECTOR(5 downto 0);
        cat : out STD_LOGIC_VECTOR(6 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0)
);
end rom;

architecture Behavioral of rom is
component rom
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(5 downto 0);
           enable : out STD_LOGIC);
end component;
component ssd
    Port ( clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0);
           digit : STD_LOGIC_VECTOR(15 downto 0));
end component;

component mpg
     Port(clock: in STD_LOGIC;
       btn:in STD_LOGIC;
       en:out STD_LOGIC);
end component;
     

signal enable : std_logic;
signal adr : std_logic_vector(0 to 7);
signal sig_out : std_logic_VECTOR(15 downto 0);
type mem_rom is array (0 to 255) of std_logic_vector(15 downto 0);
signal romm : mem_rom;
begin 
 mpg1: mpg port map(clk,btn,enable);
    process(clk,enable)
    begin
        if(rising_edge(clk) AND enable = '1') then
            adr <= adr + 1;
        end if;
        if(adr = 10) then
            adr <= x"00";
        end if;
    end process;
    rom(0) <= x"0000";
    rom(1) <= x"1111";
    rom(2) <= x"2323";
    rom(3) <= x"5555";
    rom(4) <= x"8989";
    sig_out <= rom(conv_integer(adr));
    digits : Lab2SSD port map(clk,cat,an,sig_out);
    
    
end Behavioral;

