----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2025 03:20:50 PM
-- Design Name: 
-- Module Name: tb_multiadder - Behavioral
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

entity tb_multiadder is
--  Port ( );
end tb_multiadder;

architecture Behavioral of tb_multiadder is

constant numbNb:integer:=8;
constant numblog2NFIFO:integer:=6;

component multiadder is 
generic (
    Nb: integer:=numbNb;
    log2NFIFO: integer:=numblog2NFIFO);
port (
    datain_fifo, dataout_fifo: in signed(Nb-1 downto 0);
    dataout_accumulator: in signed(Nb+log2NFIFO-1 downto 0);
    dataout: out signed(Nb+log2NFIFO-1 downto 0));
end component;

component counter is
    generic (Nb : integer) ;
    port(
        T: in std_logic;
        clk: in std_logic; 
        OUT_COUNT: out std_logic_vector(Nb-1 downto 0)
    );
end component ; 
    

signal clock_fifo_in: std_logic;
signal clock_fifo_out: std_logic;
signal clock_accumulator: std_logic;
signal dataouts:signed(numbNb+numblog2NFIFO-1 downto 0);

signal datainfifo_counter_out: std_logic_vector(numbNb-1 downto 0);
signal dataoutfifo_counter_out: std_logic_vector(numbNb-1 downto 0);
signal dataoutaccumulator_counter_out: std_logic_vector(numbNb+numblog2NFIFO-1  downto 0);


begin

--- inizio codice tbadder
-- clock per i contatori
process_clock_fifo_in:process
begin
    clock_fifo_in <= '1';
    wait for 2 ns;
    clock_fifo_in <= '0';
    wait for 2 ns;
end process;

process_clock_fifo_out:process
begin
    clock_fifo_out <= '1';
    wait for 4 ns;
    clock_fifo_out <= '0';
    wait for 4 ns;
end process;

process_clock_accumulator:process
begin
    clock_accumulator <= '1';
    wait for 8 ns;
    clock_accumulator <= '0';
    wait for 8 ns;
end process;


-- contatore che simula datain_fifo
datainfifo_counter: counter
    generic map (
        Nb => numbNb
    )
    port map (
        clk => clock_fifo_in, 
        T => '1',
        OUT_COUNT => datainfifo_counter_out);

dataoutfifo_counter : counter
    generic map (
        Nb => numbNb
    )
    port map (
        clk => clock_fifo_out,  
        T => '1',
        OUT_COUNT => dataoutfifo_counter_out);
        
dataoutaccumulator_counter: counter
   generic map (
       Nb => numbNb+numblog2NFIFO
   )port map (
        clk => clock_accumulator,  
        T => '1',
        OUT_COUNT => dataoutaccumulator_counter_out);


-- verifico che 
-- dataouts = (datainfifo_counter_out - dataoutfifo_counter_out) + dataoutaccumulator_counter_out

--- multiadder
multiadder_tested: multiadder port map (
    datain_fifo=>signed(datainfifo_counter_out), 
    dataout_fifo=>signed(dataoutfifo_counter_out),
    dataout_accumulator=>signed(dataoutaccumulator_counter_out),
    dataout=>dataouts);

--- fine codice tbadder

end Behavioral;
