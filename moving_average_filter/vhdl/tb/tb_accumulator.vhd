----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2025 03:36:52 PM
-- Design Name: 
-- Module Name: tb_accumulator - Behavioral
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

entity tb_accumulator is
--  Port ( );
end tb_accumulator;

architecture Behavioral of tb_accumulator is

constant numbNb:integer:=8;
constant numblog2NFIFO:integer:=6;

component accumulator is
generic(
    Nb: integer:=numbNb;
    log2NFIFO: integer:=numblog2NFIFO);
port (
    en, rst, clk: in std_logic;
    datain: in signed(Nb+log2NFIFO-1 downto 0);
    dataout: out signed(Nb+log2NFIFO-1 downto 0));
end component;

component counter is
    generic (Nb : integer:=numbNb+numblog2NFIFO) ;
    port(
        T: in std_logic;
        clk: in std_logic; 
        OUT_COUNT: out std_logic_vector(Nb-1 downto 0)
    );
end component;

signal clks, rsts, ens: std_logic;
signal dataouts: signed(numbNb+numblog2NFIFO-1 downto 0);
signal datains: std_logic_vector(numbNb+numblog2NFIFO-1 downto 0);

begin

--- inizio codice tbaccumulator
-- clock per il contatore
process_clks:process
begin
    clks <= '0';
    wait for 10 ns;
    clks <= '1';
    wait for 10 ns;
end process;

-- abilitazione ritardata dell'accumulatore
process_ens:process
begin
    ens <= '0';
    wait for 100 ns;
    ens <= '1';
    wait for 10 ms;
end process;

-- termine del tb con reset dell'accumulatore
process_rsts:process
begin
    rsts <= '1';
    wait for 50 ns;
    rsts <= '0';
    wait for 10 ms;
end process;

-- verifico che il dato in ingresso all'accumulatore sia portato in uscita al colpo di clock successivo.
-- Inoltre, nell'intervallo di tempo [10.00005 ms, 10.0001 ms], quando risulta reset=1 e enable=1
-- si verifica la priorità del reset sull'enable.

-- contatore per il datain
datainfifo_counter: counter port map (
    clk => clks, 
    T => '1',
    OUT_COUNT => datains);

-- accumulatore
accumulator_tested: accumulator port map (
    en => ens, 
    rst => rsts, 
    clk => clks,
    datain => signed(datains),
    dataout => dataouts);

end Behavioral;
