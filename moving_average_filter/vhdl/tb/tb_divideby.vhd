----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2025 01:49:05 PM
-- Design Name: 
-- Module Name: tf_fifo - Behavioral
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

entity tb_divide_by is
--  Port ( );
end tb_divide_by;

architecture Behavioral of tb_divide_by is

constant numbNb:integer:=8;
constant numblog2NFIFO:integer:=6;

component divide_by is 
generic (
    Nb: integer:=numbNb;
    log2NFIFO: integer:=numblog2NFIFO);
port (
    en, rst, clk: in std_logic;
    datain:in signed(Nb+log2NFIFO-1 downto 0);
    dataout: out signed(Nb+log2NFIFO-1 downto 0));
end component;

component counter is
    generic (Nb : integer:=numbNb+numblog2NFIFO) ;
    port(
        T: in std_logic;
        clk: in std_logic; 
        OUT_COUNT:out std_logic_vector(Nb-1 downto 0)
    );
    end component;

signal clks, rsts, ens: std_logic;
signal dataouts: signed(numbNb+numblog2NFIFO-1 downto 0);
signal datains: std_logic_vector(numbNb+numblog2NFIFO-1 downto 0);
signal datains_multiplied: signed(numbNb+numblog2NFIFO-1 downto 0);
begin

--- inizio codice tb_dividedby 
-- clock per il contatore
process_clks:process
begin
    clks <= '0';
    wait for 10 ns;
    clks <= '1';
    wait for 10 ns;
end process;

-- abilitazione ritardata del divide_by 
process_ens:process
begin
    ens <= '0';
    wait for 100 ns;
    ens <= '1';
    wait for 5130 ns;
end process;

-- termine del tb con reset del divide_by 
process_rsts:process
begin
    rsts <= '1';
    wait for 50 ns;
    rsts <= '0';
    wait for 5130 ns;
end process;

-- contatore per il datain
datainfifo_counter: counter port map (
        clk => clks, 
        T => '1',
        OUT_COUNT => datains); 

-- moltiplicando l'uscita dal contatore per 2^numblog2NFIFO
-- verifico che l'output generato dal dividedby
-- sia un conteggio: 0, 1, 2, 3, ... fino a 255
-- infatti:
--      2 ^ (8+6) = 16384 numeri rappresentabili in 8+6 bit 
--      16384 / 64 = 256 numeri nel conteggio uscente dal dividedby
--      10 + 256 * 20 = 5130ns => istante di tempo in cui il conteggio uscente dal dividedby si resetta
--      10ns => offset iniziale, quando si ha il primo colpo di clock
-- Tuttavia, siccome il componente viene abilitato nell'istante di tempo t=100ns 
-- il conteggio prodotto dal divided by ci si aspetta che parta da 100/20 = 5.
-- Infine, nell'intervallo di tempo [5180 ns, 5230 ns], quando risulta reset=1 e enable=1
-- si verifica la priorità del reset sull'enable.


datains_multiplied <= signed(shift_left(unsigned(datains), numblog2NFIFO));

-- divide_by 
divideby_tested: divide_by port map (
    en => ens, 
    rst => rsts, 
    clk => clks,
    datain => datains_multiplied,
    dataout => dataouts);


end Behavioral;
