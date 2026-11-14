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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tf_fifo is
--  Port ( );
end tf_fifo;

architecture Behavioral of tf_fifo is

constant numb:integer:=8;

component fifo is 
generic (
    Nb: integer:=numb;
    log2NFIFO: integer:=6);
port (
    en, rst, clk: in std_logic;
    din: in signed(Nb-1 downto 0);
    dout: out signed(Nb-1 downto 0) );
end component;

component counter is
    generic (Nb : integer:=numb) ;
    port(
        T           :in std_logic;
        clk         :in std_logic;
        OUT_COUNT   :out std_logic_vector(Nb-1 downto 0)
    );
end component;

signal clks, rsts, ens: std_logic;
signal dinfifo: std_logic_vector(numb-1 downto 0);
signal doutfifo: signed(numb-1 downto 0);
file file_to_be_read : text;

begin

clk_process: process
begin
    clks <= '0'; wait for 10 ns;
    clks <= '1'; wait for 10 ns;
end process;

en_process: process
begin
    ens <= '0'; wait for 50 ns;
    ens <= '1'; wait for 1480 ns;
end process;

rst_process: process
begin
    rsts <= '1'; wait for 50 ns;
    rsts <= '0'; wait for 1480 ns;
end process;

-- Mi aspetto che il dato in ingresso al tempo 0 
-- (relativamente al momento in cui il componente risulta attivo)
-- sia dato in uscita dopo 64 colpi di clock.
--
-- In questa simulazione:
-- fino all'istante di tempo t = 50ns, il componente nfifo è disabilitato.
-- al terzo colpo di clock (t=50ns) il componente è attivo e in ingresso al nfifo c'è 2 (il contatore parte da 0 a contare)
-- quando il contatore arriva a 66 (64 + 2), in uscita dal nfifo si avrà 2.
-- l'nfifo manderà in output i numeri da 2 a 12, poiché al tempo
-- (50 + 64 * 20 + 10 * 20) ns il componente sarà resettato.
-- 64 * 20 + 10 * 20 = 1480ns è il periodo di tempo in cui il componente deve rimanere attivo
-- perché possa spedire in output 10 valori.
-- 50 ns: offset dovuto all'abilitazione del nfifo
-- 64 * 20: periodo di tempo che deve passare prima che l'nfifo riporti 2 in uscita.
-- 10 * 20: ulteriore periodo di tempo necessario per spedire in output altri 10 numeri, da parte dell'nfifo.

dut_counter: counter port map (
        T=>'1', 
        clk=>clks, 
        OUT_COUNT=>dinfifo);   

dut_fifo: fifo port map (
    en=>ens, 
    rst=> rsts, 
    clk => clks, 
    din => signed(dinfifo), 
    dout => doutfifo);

--process(clks)
--begin
--if rising_edge(clks) then
--dinfifo <= dinfifo1;
--end if;

--end process;


-- READ into a file
--process
--    variable linevariable_in     : line;
--    variable numb_of_sample :integer:=0; 
--    variable datafile: std_logic_vector(7 downto 0);
--  begin
 
--    file_open(file_to_be_read, "mysignal.txt",  read_mode);
     
--    while numb_of_sample < 4096  loop
--      readline(file_to_be_read, linevariable_in);
--      read(linevariable_in, datafile);
 
--      dinfifo1 <= datafile;
  
--      wait for 20 ns;
--      numb_of_sample:=numb_of_sample+1;
      
 --   end loop;
 
--file_close(file_to_be_read);

     
--    wait;

--  end process;

end Behavioral;
