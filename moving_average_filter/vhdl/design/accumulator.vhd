----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2025 03:30:56 PM
-- Design Name: 
-- Module Name: accumulator - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity accumulator is
generic(
    Nb: integer;
    log2NFIFO: integer);
  port (
    en, rst, clk: in std_logic;
    datain: in signed(Nb+log2NFIFO-1 downto 0);
    dataout: out signed(Nb+log2NFIFO-1 downto 0));
end accumulator;

architecture Behavioral of accumulator is

begin   

process(clk)
variable state: signed(Nb+log2NFIFO-1 downto 0) := (others => '0');
begin
    if rst='1' then
        state := (others=>'0');
    else if rising_edge(clk) then
        if en='1' then
            state := datain;
        end if;
    end if;
    end if;
    dataout <= state;
end process;

end Behavioral;
